import 'package:WeekLife/data/models/app_global_info/app_global_info_data.dart';

/// App Global Info 仓库接口
/// 定义所有数据库操作的基本方法
abstract class IAppGlobalInfoRepository {
  /// 创建单个 App Global Info
  /// 返回创建后的 App Global Info 数据（包含 ID）
  Future<AppGlobalInfoData> createAppGlobalInfo(AppGlobalInfoData info);

  /// 批量创建 App Global Info
  /// 返回创建后的 App Global Info 数据列表（包含 ID）
  Future<List<AppGlobalInfoData>> createAppGlobalInfos(List<AppGlobalInfoData> infos);

  /// 查询 App Global Info
  /// [query] 查询条件
  /// 返回符合条件的 App Global Info 列表
  Future<List<AppGlobalInfoData>> queryAppGlobalInfos(AppGlobalInfoQuery query);

  /// 更新 App Global Info
  /// [id] App Global Info ID
  /// [info] 更新后的数据
  /// 返回更新的记录数
  Future<int> updateAppGlobalInfo(int id, AppGlobalInfoData info);

  /// 删除 App Global Info
  /// [id] App Global Info ID
  /// 返回删除的记录数
  Future<int> deleteAppGlobalInfo(int id);

  /// 获取 App Global Info 数量
  /// 返回 App Global Info 数量
  Future<int> getAppGlobalInfoCount();

  /// 开始事务
  /// [action] 事务中执行的操作
  /// [requireNew] 是否要求新的事务
  /// 返回事务执行结果
  Future<T> transaction<T>(Future<T> Function() action, {bool requireNew = false});
} 