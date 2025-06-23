import 'package:WeekLife/data/models/location/location_record_data.dart';
import 'package:WeekLife/data/repositories/location/interfaces/location_repo_interface.dart';
import 'package:WeekLife/data/dao/location/location_dao.dart';

/// 定位记录仓库
/// 使用 DAO 模式进行定位记录的数据管理
class LocationRepository implements ILocationRepository {
  final LocationDao _dao;

  LocationRepository() : _dao = LocationDao();

  /// 创建定位记录
  @override
  Future<LocationRecordData> createLocationRecord(LocationRecordData record) async {
    final id = await _dao.createLocationRecord(
      latitude: record.latitude,
      longitude: record.longitude,
      locationName: record.locationName,
      accuracy: record.accuracy,
      altitude: record.altitude,
      distanceFromPrevious: record.distanceFromPrevious,
      userId: record.userId,
    );
    return record.copyWith(id: id);
  }

  /// 批量创建定位记录
  @override
  Future<List<LocationRecordData>> createLocationRecords(List<LocationRecordData> records) async {
    final results = <LocationRecordData>[];
    for (final record in records) {
      final created = await createLocationRecord(record);
      results.add(created);
    }
    return results;
  }

  /// 查询定位记录
  @override
  Future<List<LocationRecordData>> queryLocationRecords(LocationRecordQuery query) async {
    // 简化查询，先实现基本的用户ID查询
    if (query.userId != null) {
      return await _dao.getLocationRecordsByUserId(
        query.userId!,
        limit: query.limit,
        offset: query.offset,
        orderBy: query.orderBy,
        orderDesc: query.orderDesc,
      );
    }
    return [];
  }

  /// 更新定位记录
  @override
  Future<int> updateLocationRecord(int id, LocationRecordData record) async {
    final updates = <String, dynamic>{
      'latitude': record.latitude,
      'longitude': record.longitude,
      'locationName': record.locationName,
      'accuracy': record.accuracy,
      'altitude': record.altitude,
      'distanceFromPrevious': record.distanceFromPrevious,
      'recordedAt': record.recordedAt,
      'userId': record.userId,
      'createdAt': record.createdAt,
    };
    return await _dao.updateLocationRecord(id, updates);
  }

  /// 删除定位记录
  @override
  Future<int> deleteLocationRecord(int id) async {
    return await _dao.deleteLocationRecord(id);
  }

  /// 根据用户ID查询定位记录
  @override
  Future<List<LocationRecordData>> getLocationRecordsByUserId(
    int userId, {
    int? limit,
    int? offset,
  }) async {
    return await _dao.getLocationRecordsByUserId(
      userId,
      limit: limit,
      offset: offset,
    );
  }

  /// 根据时间范围查询定位记录
  @override
  Future<List<LocationRecordData>> getLocationRecordsByTimeRange(
    int userId,
    int startTime,
    int endTime,
  ) async {
    return await _dao.getLocationRecordsByTimeRange(userId, startTime, endTime);
  }

  /// 获取最近的定位记录
  @override
  Future<LocationRecordData?> getLatestLocationRecord(int userId) async {
    return await _dao.getLatestLocationRecord(userId);
  }

  /// 删除指定时间之前的定位记录
  @override
  Future<int> deleteLocationRecordsBeforeTime(int timestamp) async {
    return await _dao.deleteLocationRecordsBeforeTime(timestamp);
  }

  /// 获取定位记录总数
  @override
  Future<int> getLocationRecordCount(int userId) async {
    return await _dao.getLocationRecordCount(userId);
  }

  /// 删除用户的所有定位记录
  @override
  Future<int> deleteAllLocationRecords(int userId) async {
    return await _dao.deleteAllLocationRecords(userId);
  }

  /// 开始事务
  @override
  Future<T> transaction<T>(Future<T> Function() action, {bool requireNew = false}) async {
    // 简化事务处理，直接执行操作
    return await action();
  }
}
