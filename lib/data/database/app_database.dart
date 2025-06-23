import 'package:drift/drift.dart';
import 'package:WeekLife/data/database/tables/journal_writer_tbl.dart';
import 'package:WeekLife/data/database/tables/location_record_tbl.dart';
import 'package:WeekLife/data/database/tables/app_global_info_tbl.dart';
import 'package:WeekLife/data/database/tables/todo_record_tbl.dart';
import 'package:WeekLife/data/database/tables/weekly_journal_tbl.dart';

part 'app_database.g.dart';

/// 应用主数据库
/// 包含所有数据表的定义和管理
@DriftDatabase(tables: [
  JournalWriterTable,
  LocationRecordTable,
  AppGlobalInfoTable,
  TodoRecordTable,
  WeeklyJournalTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // 处理数据库升级逻辑
      },
    );
  }
}
