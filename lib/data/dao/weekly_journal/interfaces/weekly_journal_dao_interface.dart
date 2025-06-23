import 'package:WeekLife/data/models/weekly_journal/weekly_journal_data.dart';

abstract class IWeeklyJournalDao {
  /// 创建新的周记
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
  });

  /// 根据 ID 获取周记
  Future<WeeklyJournalData?> getWeeklyJournalById(int id);

  /// 根据作者ID、周数和年份获取周记
  Future<WeeklyJournalData?> getWeeklyJournalByWeek(int writerId, int weekNumber, int year);

  /// 获取作者的所有周记
  Future<List<WeeklyJournalData>> getWeeklyJournalsByWriter(int writerId, {
    int? limit,
    int? offset,
    String? orderBy,
    bool? orderDesc,
  });

  /// 获取作者今年的所有周记基础信息
  Future<List<WeeklyJournalData>> getYearlyJournalsSummary(int writerId, int year);

  /// 更新周记
  Future<bool> updateWeeklyJournal(int id, Map<String, dynamic> updates);

  /// 软删除周记
  Future<bool> deleteWeeklyJournal(int id);

  /// 获取作者的周记统计信息
  Future<Map<String, int>> getJournalStats(int writerId);
}
