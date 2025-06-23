import 'package:WeekLife/data/repositories/operate_log/operate_log_repo.dart';

/// OperateLog 数据模型
class OperateLogData {
  final int id;
  final int writerId;
  final int operateType;
  final String operateAfterData;
  final String operateBeforeData;
  final DateTime operatedAt;

  const OperateLogData({
    required this.id,
    required this.writerId,
    required this.operateType,
    required this.operateAfterData,
    required this.operateBeforeData,
    required this.operatedAt,
  });

  factory OperateLogData.fromDb(OperateLog operateLog) => OperateLogData(
    id: operateLog.id,
    writerId: operateLog.writerId,
    operateType: operateLog.operateType,
    operateAfterData: operateLog.operateAfterData,
    operateBeforeData: operateLog.operateBeforeData,
    operatedAt: operateLog.operatedAt,
  );
  
  
}