// 导入 Drift 包，提供数据库表定义的功能
import 'package:drift/drift.dart';

/// @DataClassName 注解
/// 指定生成的数据类名称
/// 这里会生成一个名为 "OperateLog" 的数据类
@DataClassName("OperateLog")
class OperateLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get writerId => integer()();

  IntColumn get operateType => integer()();

  TextColumn get operateAfterData => text()();

  TextColumn get operateBeforeData => text()();

  DateTimeColumn get operatedAt => dateTime()();
}