import 'package:WeekLife/data/models/location/location_record_data.dart';

/// 定位记录数据访问对象接口
abstract class ILocationDao {
  /// 创建定位记录
  Future<int> createLocationRecord({
    required double latitude,
    required double longitude,
    String? locationName,
    double? accuracy,
    double? altitude,
    double? distanceFromPrevious,
    required int userId,
  });

  /// 根据ID获取定位记录
  Future<LocationRecordData?> getLocationRecordById(int id);

  /// 根据用户ID获取定位记录列表
  Future<List<LocationRecordData>> getLocationRecordsByUserId(
    int userId, {
    int? limit,
    int? offset,
    String? orderBy,
    bool? orderDesc,
  });

  /// 根据时间范围获取定位记录
  Future<List<LocationRecordData>> getLocationRecordsByTimeRange(
    int userId,
    int startTime,
    int endTime,
  );

  /// 获取最新的定位记录
  Future<LocationRecordData?> getLatestLocationRecord(int userId);

  /// 更新定位记录
  Future<int> updateLocationRecord(int id, Map<String, dynamic> updates);

  /// 删除定位记录
  Future<int> deleteLocationRecord(int id);

  /// 删除指定时间之前的记录
  Future<int> deleteLocationRecordsBeforeTime(int timestamp);

  /// 获取定位记录数量
  Future<int> getLocationRecordCount(int userId);

  /// 删除用户所有定位记录
  Future<int> deleteAllLocationRecords(int userId);
}
