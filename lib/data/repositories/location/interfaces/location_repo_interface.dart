import 'package:WeekLife/data/models/location/location_record_data.dart';

/// 定位记录仓库接口
/// 定义所有定位记录数据库操作的基本方法
abstract class ILocationRepository {
  /// 创建单个定位记录
  /// 返回创建后的定位记录数据（包含 ID）
  Future<LocationRecordData> createLocationRecord(LocationRecordData record);

  /// 批量创建定位记录
  /// 返回创建后的定位记录数据列表（包含 ID）
  Future<List<LocationRecordData>> createLocationRecords(List<LocationRecordData> records);

  /// 查询定位记录
  /// [query] 查询条件
  /// 返回符合条件的定位记录列表
  Future<List<LocationRecordData>> queryLocationRecords(LocationRecordQuery query);

  /// 更新定位记录
  /// [id] 记录 ID
  /// [record] 更新后的数据
  /// 返回更新的记录数
  Future<int> updateLocationRecord(int id, LocationRecordData record);

  /// 删除定位记录
  /// [id] 记录 ID
  /// 返回删除的记录数
  Future<int> deleteLocationRecord(int id);

  /// 根据用户ID查询定位记录
  /// [userId] 用户ID
  /// [limit] 限制返回数量
  /// [offset] 偏移量
  /// 返回用户的定位记录列表
  Future<List<LocationRecordData>> getLocationRecordsByUserId(
    int userId, {
    int? limit,
    int? offset,
  });

  /// 根据时间范围查询定位记录
  /// [userId] 用户ID
  /// [startTime] 开始时间（Unix时间戳）
  /// [endTime] 结束时间（Unix时间戳）
  /// 返回时间范围内的定位记录列表
  Future<List<LocationRecordData>> getLocationRecordsByTimeRange(
    int userId,
    int startTime,
    int endTime,
  );

  /// 获取最近的定位记录
  /// [userId] 用户ID
  /// 返回最近的定位记录，如果没有则返回null
  Future<LocationRecordData?> getLatestLocationRecord(int userId);

  /// 删除指定时间之前的定位记录
  /// [timestamp] 时间戳
  /// 返回删除的记录数
  Future<int> deleteLocationRecordsBeforeTime(int timestamp);

  /// 获取定位记录总数
  /// [userId] 用户ID
  /// 返回定位记录总数
  Future<int> getLocationRecordCount(int userId);

  /// 删除用户的所有定位记录
  /// [userId] 用户ID
  /// 返回删除的记录数
  Future<int> deleteAllLocationRecords(int userId);

  /// 开始事务
  /// [action] 事务中执行的操作
  /// [requireNew] 是否要求新的事务
  /// 返回事务执行结果
  Future<T> transaction<T>(Future<T> Function() action, {bool requireNew = false});
}
