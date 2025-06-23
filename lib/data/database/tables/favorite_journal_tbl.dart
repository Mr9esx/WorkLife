// 导入 Drift 包，提供数据库表定义的功能
import 'package:drift/drift.dart';

/// @DataClassName 注解
/// 指定生成的数据类名称
/// 这里会生成一个名为 "FavoriteJournal" 的数据类
@DataClassName("FavoriteJournal")
class FavoriteJournalTable extends Table {
  // 继承 Table 类，表示这是一个数据库表
  // 自增主键
  IntColumn get id => integer().autoIncrement()();

  // 收藏周份
  IntColumn get weekNumber => integer()();

  // 收藏年份
  IntColumn get year => integer()();

  // 收藏作者ID
  IntColumn get writerId => integer()();

  // 收藏时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        // 作者ID + 年份 + 周数的唯一索引
        // 确保同一作者在同一年的同一周只能有一条收藏记录
        {writerId, year, weekNumber},
      ];
}
