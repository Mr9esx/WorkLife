// 导入必要的包
import 'package:drift/drift.dart';  // Drift 数据库核心包
import 'package:WeekLife/data/database/tables/operate_log_tbl.dart';
import 'package:WeekLife/data/repositories/operate_log/interfaces/operate_log_repo_interface.dart';
import 'package:WeekLife/data/models/operate_log/operate_log_data.dart';

// 声明这是一个生成代码的部分
// 这行代码告诉 Dart operate_log_repo.g.dart 是当前文件的一部分
part 'operate_log_repo.g.dart';

/// @DriftDatabase 注解说明：
/// 1. 声明这是一个 Drift 数据库类
/// 2. tables: [OperateLog] 指定数据库包含哪些表
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
/// 生成必要的辅助代码（在 operate_log_repo.g.dart 中）
@DriftDatabase(tables: [OperateLogTable])
class OperateLogRepo extends _$OperateLogRepo implements IOperateLogRepository {
  OperateLogRepo(super.db);

  /// 数据库版本号
  /// 每次修改数据库结构时，需要增加版本号
  /// 例如：添加新表、修改表结构等
  @override  // @override 表示重写父类的方法
  int get schemaVersion => 1;  // 当前数据库版本为 1

  @override
  Future<OperateLogData> createOperateLog(OperateLogData writer) {
    // TODO: implement createOperateLog
    throw UnimplementedError();
  }
}