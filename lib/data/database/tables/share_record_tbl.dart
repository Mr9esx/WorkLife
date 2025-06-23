// 导入 Drift 包，提供数据库表定义的功能
import 'package:drift/drift.dart';
import 'journal_writer_tbl.dart';

/// @DataClassName 注解
/// 指定生成的数据类名称
/// 这里会生成一个名为 "ShareRecord" 的数据类
@DataClassName("ShareRecord")
class ShareRecordTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get writerId => integer().references(JournalWriterTable, #id)();

  TextColumn get shareChannel => text()();

  TextColumn get shareData => text()();

  TextColumn get shareTemplate => text()();

  DateTimeColumn get sharedAt => dateTime()();
}