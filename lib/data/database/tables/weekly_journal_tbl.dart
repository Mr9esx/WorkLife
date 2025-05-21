// 导入 Drift 包，提供数据库表定义的功能
import 'package:drift/drift.dart';

/// @DataClassName 注解
/// 指定生成的数据类名称
/// 这里会生成一个名为 "WeeklyJournal" 的数据类
@DataClassName("WeeklyJournal")
class WeeklyJournalTable extends Table {  // 继承 Table 类，表示这是一个数据库表
  // 自增主键
  IntColumn get id => integer().autoIncrement()();

  // 作者ID
  IntColumn get writerId => integer()();

  // 周数
  IntColumn get weekNumber => integer()();

  // 标题
  TextColumn get title => text()();

  // 内容
  TextColumn get content => text()();

  // 心情
  IntColumn get mood => integer()();

  // 心情颜色
  TextColumn get moodColor => text()();

  // 图片
  TextColumn get pics => text()();

  // 位置
  TextColumn get geo => text()();

  // 创建时间，日期时间类型
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // 更新时间，可为空
  DateTimeColumn get updatedAt => dateTime().nullable()();

  // 删除时间
  DateTimeColumn get deletedAt => dateTime().nullable()();
}