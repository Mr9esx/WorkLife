import 'package:WeekLife/data/models/weekly_journal/weekly_journal_data.dart';
import 'package:WeekLife/data/dao/weekly_journal/interfaces/weekly_journal_dao_interface.dart';
import 'package:WeekLife/data/database/app_database.dart';
import 'package:drift/drift.dart';

/// WeeklyJournal 数据访问对象
/// 提供周记表的所有数据库操作方法
class WeeklyJournalDao implements IWeeklyJournalDao {
  final AppDatabase _db;

  WeeklyJournalDao(AppDatabase db) : _db = db;

  /// 创建新的周记
  @override
  Future<int> createWeeklyJournal({
    required int writerId,
    required int year,
    required int weekNumber,
    required String title,
    required String content,
    required int mood,
    required String moodColor,
    String pics = '',
    String geo = '',
  }) async {
    try {
      final now = DateTime.now();
      final id = await _db.into(_db.weeklyJournalTable).insert(
        WeeklyJournalTableCompanion.insert(
          writerId: writerId,
          year: year,
          weekNumber: weekNumber,
          title: title,
          content: content,
          mood: mood,
          moodColor: moodColor,
          pics: pics,
          geo: geo,
          createdAt: Value(now),
        ),
      );
      return id;
    } catch (e) {
      throw Exception('创建周记失败: $e');
    }
  }

  /// 根据 ID 获取周记
  @override
  Future<WeeklyJournalData?> getWeeklyJournalById(int id) async {
    try {
      final journals = await (_db.select(_db.weeklyJournalTable)
            ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
          .get();
      return journals.isEmpty ? null : _convertToWeeklyJournalData(journals.first);
    } catch (e) {
      throw Exception('获取周记失败: $e');
    }
  }

  /// 根据作者ID、周数和年份获取周记
  @override
  Future<WeeklyJournalData?> getWeeklyJournalByWeek(int writerId, int weekNumber, int year) async {
    try {
      final journals = await (_db.select(_db.weeklyJournalTable)
            ..where((t) => t.writerId.equals(writerId) & 
                          t.year.equals(year) &
                          t.weekNumber.equals(weekNumber) & 
                          t.deletedAt.isNull()))
          .get();
      return journals.isEmpty ? null : _convertToWeeklyJournalData(journals.first);
    } catch (e) {
      throw Exception('获取周记失败: $e');
    }
  }

  /// 获取作者的所有周记
  @override
  Future<List<WeeklyJournalData>> getWeeklyJournalsByWriter(int writerId, {
    int? limit,
    int? offset,
    String? orderBy,
    bool? orderDesc,
  }) async {
    try {
      var query = _db.select(_db.weeklyJournalTable)
        ..where((t) => t.writerId.equals(writerId) & t.deletedAt.isNull());
      
      // 应用排序
      if (orderBy != null) {
        Expression<Object> Function($WeeklyJournalTableTable) getOrderColumn() {
          switch (orderBy) {
            case 'year':
              return (t) => t.year;
            case 'weekNumber':
              return (t) => t.weekNumber;
            case 'createdAt':
              return (t) => t.createdAt;
            case 'updatedAt':
              return (t) => t.updatedAt;
            default:
              return (t) => t.year;
          }
        }

        final orderColumn = getOrderColumn();
        final orderMode = orderDesc == true
            ? OrderingMode.desc
            : OrderingMode.asc;
        query = query
          ..orderBy([
            (t) => orderMode == OrderingMode.desc 
              ? OrderingTerm.desc(orderColumn(t))
              : OrderingTerm.asc(orderColumn(t))
          ]);
      }

      // 应用分页
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final journals = await query.get();
      return journals.map(_convertToWeeklyJournalData).toList();
    } catch (e) {
      throw Exception('获取周记列表失败: $e');
    }
  }

  /// 获取作者今年的所有周记基础信息
  @override
  Future<List<WeeklyJournalData>> getYearlyJournalsSummary(int writerId, int year) async {
    try {
      final journals = await (_db.select(_db.weeklyJournalTable)
            ..where((t) => t.writerId.equals(writerId) & 
                          t.year.equals(year) &
                          t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.weekNumber)]))
          .get();
      
      return journals.map(_convertToWeeklyJournalData).toList();
    } catch (e) {
      throw Exception('获取年度周记摘要失败: $e');
    }
  }

  /// 更新周记
  @override
  Future<bool> updateWeeklyJournal(int id, Map<String, dynamic> updates) async {
    try {
      // 检查周记是否存在
      final journal = await getWeeklyJournalById(id);
      if (journal == null) {
        throw Exception('周记不存在');
      }

      final now = DateTime.now();
      final companion = WeeklyJournalTableCompanion(
        title: updates.containsKey('title') ? Value(updates['title']) : const Value.absent(),
        content: updates.containsKey('content') ? Value(updates['content']) : const Value.absent(),
        mood: updates.containsKey('mood') ? Value(updates['mood']) : const Value.absent(),
        moodColor: updates.containsKey('moodColor') ? Value(updates['moodColor']) : const Value.absent(),
        pics: updates.containsKey('pics') ? Value(updates['pics']) : const Value.absent(),
        geo: updates.containsKey('geo') ? Value(updates['geo']) : const Value.absent(),
        updatedAt: Value(now),
      );

      final result = await (_db.update(_db.weeklyJournalTable)
            ..where((t) => t.id.equals(id)))
          .write(companion);
      return result > 0;
    } catch (e) {
      throw Exception('更新周记失败: $e');
    }
  }

  /// 软删除周记
  @override
  Future<bool> deleteWeeklyJournal(int id) async {
    try {
      final now = DateTime.now();
      final result = await (_db.update(_db.weeklyJournalTable)
            ..where((t) => t.id.equals(id)))
          .write(WeeklyJournalTableCompanion(
            deletedAt: Value(now),
          ));
      return result > 0;
    } catch (e) {
      throw Exception('删除周记失败: $e');
    }
  }

  /// 获取作者的周记统计信息
  @override
  Future<Map<String, int>> getJournalStats(int writerId) async {
    try {
      final totalCount = await (_db.selectOnly(_db.weeklyJournalTable)
            ..addColumns([_db.weeklyJournalTable.id.count()])
            ..where(_db.weeklyJournalTable.writerId.equals(writerId) & 
                   _db.weeklyJournalTable.deletedAt.isNull()))
          .getSingle();

      final currentYear = DateTime.now().year;
      
      final yearCount = await (_db.selectOnly(_db.weeklyJournalTable)
            ..addColumns([_db.weeklyJournalTable.id.count()])
            ..where(_db.weeklyJournalTable.writerId.equals(writerId) & 
                   _db.weeklyJournalTable.year.equals(currentYear) &
                   _db.weeklyJournalTable.deletedAt.isNull()))
          .getSingle();

      return {
        'total': totalCount.read(_db.weeklyJournalTable.id.count()) ?? 0,
        'thisYear': yearCount.read(_db.weeklyJournalTable.id.count()) ?? 0,
      };
    } catch (e) {
      throw Exception('获取周记统计失败: $e');
    }
  }

  /// 将数据库记录转换为数据模型
  WeeklyJournalData _convertToWeeklyJournalData(WeeklyJournal journal) {
    return WeeklyJournalData(
      id: journal.id,
      writerId: journal.writerId,
      year: journal.year,
      weekNumber: journal.weekNumber,
      title: journal.title,
      content: journal.content,
      mood: journal.mood,
      moodColor: journal.moodColor,
      pics: journal.pics,
      geo: journal.geo,
      createdAt: journal.createdAt,
      updatedAt: journal.updatedAt,
      deletedAt: journal.deletedAt,
    );
  }
}
