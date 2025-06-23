import 'package:WeekLife/data/models/operate_log/operate_log_data.dart';

/// OperateLog 仓库接口
/// 定义所有数据库操作的基本方法
abstract class IOperateLogRepository {
  /// 创建操作记录
  /// 只返回创建后的操作记录ID和错误
  Future<OperateLogData> createOperateLog(OperateLogData writer);
} 