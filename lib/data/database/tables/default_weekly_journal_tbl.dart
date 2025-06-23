// 导入 Drift 包，提供数据库表定义的功能
import 'package:drift/drift.dart';

/// @DataClassName 注解
/// 指定生成的数据类名称
/// 这里会生成一个名为 "DefaultWeeklyJournal" 的数据类
@DataClassName("DefaultWeeklyJournal")
class DefaultWeeklyJournalTable extends Table {
  IntColumn get id => integer().autoIncrement()();
}