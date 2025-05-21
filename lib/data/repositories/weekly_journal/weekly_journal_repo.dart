// 导入必要的包
import 'package:drift/drift.dart';  // Drift 数据库核心包
import 'package:WeekLife/data/database/tables/weekly_journal_tbl.dart';  // 导入 WeeklyJournalTable 定义

// 声明这是一个生成代码的部分
// 这行代码告诉 Dart 编译器，writer_repo.g.dart 是当前文件的一部分
part 'weekly_journal_repo.g.dart';

@DriftDatabase(tables: [WeeklyJournalTable])
class WeeklyJournalRepo extends _$WeeklyJournalRepo {
  WeeklyJournalRepo(super.db);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
    );
  } 
}