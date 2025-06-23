// 导入必要的包
import 'package:drift/drift.dart';  // Drift 数据库核心包
import 'package:WeekLife/data/database/tables/journal_writer_tbl.dart';
import 'package:WeekLife/data/models/journal_writer/journal_writer_data.dart';
import 'package:WeekLife/data/repositories/journal_writer/interfaces/journal_writer_repo_interface.dart';

// 声明这是一个生成代码的部分
// 这行代码告诉 Dart 编译器，writer_repo.g.dart 是当前文件的一部分
part 'journal_writer_repo.g.dart';

/// @DriftDatabase 注解说明：
/// 1. 声明这是一个 Drift 数据库类
/// 2. tables: [JournalWriter] 指定数据库包含哪些表
/// 3. 自动生成：
///    - 数据库连接代码
///    - 表的 CRUD 操作
///    - 类型安全的查询方法
///    - 数据库迁移代码
/// 具体功能：
/// 自动创建数据库文件
/// 管理数据库连接
/// 提供类型安全的 API 来操作 Writer 表
/// 处理数据库版本和迁移
/// 生成必要的辅助代码（在 writer_repo.g.dart 中）
@DriftDatabase(tables: [JournalWriterTable])
class JournalWriterRepo extends _$JournalWriterRepo implements IJournalWriterRepository {
  JournalWriterRepo(super.db);

  /// 数据库版本号
  /// 每次修改数据库结构时，需要增加版本号
  /// 例如：添加新表、修改表结构等
  @override  // @override 表示重写父类的方法
  int get schemaVersion => 2;  // 当前数据库版本为 2，添加了 currentWriter 字段

  /// 数据库迁移策略
  /// 用于处理数据库版本升级时的数据迁移
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      // 数据库创建时的回调
      onCreate: (Migrator m) async {
        // 创建所有表
        await m.createAll();
      },
      // 数据库升级时的回调
      onUpgrade: (Migrator m, int from, int to) async {
        // from: 当前版本
        // to: 目标版本
        // 在这里处理数据库升级逻辑
        if (from < 2) {
          // 版本 1 到 2：添加 currentWriter 字段
          await m.addColumn(journalWriterTable, journalWriterTable.currentWriter);
        }
      },
    );
  }

  /// 创建 Writer
  @override
  Future<JournalWriterData> createWriter(JournalWriterData writer) async {
    final id = await into(journalWriterTable).insert(writer.toCompanion());
    return writer.copyWith(id: id);
  }

  /// 批量创建 Writer
  @override
  Future<List<JournalWriterData>> createWriters(List<JournalWriterData> writers) async {
    return transaction(() async {
      final results = <JournalWriterData>[];
      for (final writer in writers) {
        final id = await into(journalWriterTable).insert(writer.toCompanion());
        results.add(writer.copyWith(id: id));
      }
      return results;
    });
  }

  /// 查询 Writer
  @override
  Future<List<JournalWriterData>> queryWriters(JournalWriterQuery query) async {
    var selectQuery = select(journalWriterTable);

    // 应用过滤条件
    selectQuery.where(query.toWhereClause());

    // 应用排序
    if (query.orderBy != null) {
      Expression<Object> Function(JournalWriterTable) getOrderColumn() {
        switch (query.orderBy!) {
          case 'id':
            return (t) => t.id;
          case 'username':
            return (t) => t.username;
          case 'currentWriter':
            return (t) => t.currentWriter;
          case 'createdAt':
            return (t) => t.createdAt;
          case 'updatedAt':
            return (t) => t.updatedAt;
          default:
            return (t) => t.createdAt;  // 默认按创建时间排序
        }
      }

      final orderColumn = getOrderColumn();
      final orderMode = query.orderDesc == true
          ? OrderingMode.desc
          : OrderingMode.asc;
      selectQuery = selectQuery
        ..orderBy([
          (t) => orderMode == OrderingMode.desc 
            ? OrderingTerm.desc(orderColumn(t))
            : OrderingTerm.asc(orderColumn(t))
        ]);
    }

    // 应用分页
    if (query.limit != null && query.offset != null) {
      final offset = (query.limit! - 1) * query.offset!;
      selectQuery = selectQuery
        ..limit(query.limit!, offset: offset);
    }

    final writers = await selectQuery.get();
    return writers.map(JournalWriterData.fromDb).toList();
  }

  /// 更新 Writer
  @override
  Future<int> updateWriter(int id, JournalWriterData writer) async {
    return (update(journalWriterTable)
          ..where((t) => t.id.equals(id)))
        .write(writer.toCompanion());
  }

  /// 删除 Writer
  @override
  Future<int> deleteWriter(int id) async {
    return (delete(journalWriterTable)..where((t) => t.id.equals(id))).go();
  }

  /// 获取 Writer 数量
  @override
  Future<int> getWriterCount() async {
    final query = selectOnly(journalWriterTable)
      ..addColumns([journalWriterTable.id.count()]);
    final result = await query.getSingle();
    return result.read(journalWriterTable.id.count()) ?? 0;
  }

  @override
  Future<T> transaction<T>(Future<T> Function() action, {bool requireNew = false}) async {
    return await super.transaction(action, requireNew: requireNew);
  }
}