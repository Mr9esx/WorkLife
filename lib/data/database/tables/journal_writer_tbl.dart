// 导入 Drift 包，提供数据库表定义的功能
import 'package:drift/drift.dart';

/// @DataClassName 注解
/// 指定生成的数据类名称
/// 这里会生成一个名为 "WriterTableData" 的数据类
@DataClassName("JournalWriter")
class JournalWriterTable extends Table {  // 继承 Table 类，表示这是一个数据库表
  // 自增主键
  IntColumn get id => integer().autoIncrement()();

  // 用户名，唯一约束
  TextColumn get username => text().unique()();

  // 性别，文本类型
  IntColumn get gender => integer()();

  // 生日，日期时间类型
  DateTimeColumn get birthDay => dateTime()();

  // 头像，可为空
  TextColumn get avatar => text().nullable()();

  // 出生地，可为空
  TextColumn get birthPlace => text().nullable()();

  // 创建时间，日期时间类型
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // 更新时间，可为空
  DateTimeColumn get updatedAt => dateTime().nullable()();
}