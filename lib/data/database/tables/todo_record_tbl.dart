// 导入 Drift 包，提供数据库表定义的功能
import 'package:drift/drift.dart';

/// @DataClassName 注解
/// 指定生成的数据类名称
/// 这里会生成一个名为 "TodoRecord" 的数据类
@DataClassName("TodoRecord")
class TodoRecordTable extends Table {
  // 继承 Table 类，表示这是一个数据库表
  // 自增主键
  IntColumn get id => integer().autoIncrement()();

  // 关联的周记ID（外键），可为空（用于未来周份的TODO）
  IntColumn get weeklyJournalId => integer().nullable()();

  // 关联的作者ID（外键）
  IntColumn get writerId => integer()();

  // 周数（用于未来周份的TODO）
  IntColumn get weekNumber => integer().nullable()();

  // 年份（用于未来周份的TODO）
  IntColumn get year => integer().nullable()();

  // TODO内容
  TextColumn get content => text()();

  // 是否完成，默认为false（保留兼容性）
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  // TODO状态（0-未开始，1-进行中，2-已完成），默认为0
  IntColumn get status => integer().withDefault(const Constant(0))();

  // 优先级（1-低，2-中，3-高），默认为1
  IntColumn get priority => integer().withDefault(const Constant(1))();

  // 排序顺序
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  // 提醒时间，可为空
  DateTimeColumn get reminderTime => dateTime().nullable()();

  // 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // 更新时间，可为空
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
