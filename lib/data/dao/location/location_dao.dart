import 'package:WeekLife/data/models/location/location_record_data.dart';
import 'package:WeekLife/data/dao/location/interfaces/location_dao_interface.dart';
import 'package:WeekLife/core/utils/database/database_manager.dart';
import 'package:WeekLife/data/database/app_database.dart';
import 'package:drift/drift.dart';

/// 定位记录数据访问对象
/// 提供定位记录表的所有数据库操作方法
class LocationDao implements ILocationDao {
  final AppDatabase _db;

  LocationDao() : _db = DatabaseManager.instance.database;

  /// 创建定位记录
  @override
  Future<int> createLocationRecord({
    required double latitude,
    required double longitude,
    String? locationName,
    double? accuracy,
    double? altitude,
    double? distanceFromPrevious,
    required int userId,
  }) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final id = await _db.into(_db.locationRecordTable).insert(
            LocationRecordTableCompanion.insert(
              latitude: latitude,
              longitude: longitude,
              locationName: Value(locationName),
              accuracy: Value(accuracy),
              altitude: Value(altitude),
              distanceFromPrevious: Value(distanceFromPrevious),
              recordedAt: now,
              userId: userId,
              createdAt: now,
            ),
          );
      return id;
    } catch (e) {
      throw Exception('创建定位记录失败: $e');
    }
  }

  /// 根据ID获取定位记录
  @override
  Future<LocationRecordData?> getLocationRecordById(int id) async {
    try {
      final records = await (_db.select(_db.locationRecordTable)..where((t) => t.id.equals(id))).get();
      return records.isEmpty ? null : _convertToLocationRecordData(records.first);
    } catch (e) {
      throw Exception('获取定位记录失败: $e');
    }
  }

  /// 根据用户ID获取定位记录列表
  @override
  Future<List<LocationRecordData>> getLocationRecordsByUserId(
    int userId, {
    int? limit,
    int? offset,
    String? orderBy,
    bool? orderDesc,
  }) async {
    try {
      var query = _db.select(_db.locationRecordTable)..where((t) => t.userId.equals(userId));

      // 应用排序
      if (orderBy != null) {
        Expression<Object> Function($LocationRecordTableTable) getOrderColumn() {
          switch (orderBy) {
            case 'id':
              return (t) => t.id;
            case 'latitude':
              return (t) => t.latitude;
            case 'longitude':
              return (t) => t.longitude;
            case 'recordedAt':
              return (t) => t.recordedAt;
            case 'createdAt':
              return (t) => t.createdAt;
            default:
              return (t) => t.recordedAt;
          }
        }

        final orderColumn = getOrderColumn();
        final orderMode = orderDesc == true ? OrderingMode.desc : OrderingMode.asc;
        query = query
          ..orderBy([
            (t) => orderMode == OrderingMode.desc ? OrderingTerm.desc(orderColumn(t)) : OrderingTerm.asc(orderColumn(t))
          ]);
      } else {
        query = query..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]);
      }

      // 应用分页
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final records = await query.get();
      return records.map(_convertToLocationRecordData).toList();
    } catch (e) {
      throw Exception('获取用户定位记录失败: $e');
    }
  }

  /// 根据时间范围获取定位记录
  @override
  Future<List<LocationRecordData>> getLocationRecordsByTimeRange(
    int userId,
    int startTime,
    int endTime,
  ) async {
    try {
      final records = await (_db.select(_db.locationRecordTable)
            ..where((t) => t.userId.equals(userId) & t.recordedAt.isBetweenValues(startTime, endTime))
            ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
          .get();

      return records.map(_convertToLocationRecordData).toList();
    } catch (e) {
      throw Exception('获取时间范围内定位记录失败: $e');
    }
  }

  /// 获取最新的定位记录
  @override
  Future<LocationRecordData?> getLatestLocationRecord(int userId) async {
    try {
      final result = await (_db.select(_db.locationRecordTable)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
            ..limit(1))
          .getSingleOrNull();

      return result == null ? null : _convertToLocationRecordData(result);
    } catch (e) {
      throw Exception('获取最新定位记录失败: $e');
    }
  }

  /// 更新定位记录
  @override
  Future<int> updateLocationRecord(int id, Map<String, dynamic> updates) async {
    try {
      final companion = LocationRecordTableCompanion(
        latitude: updates.containsKey('latitude') ? Value(updates['latitude']) : const Value.absent(),
        longitude: updates.containsKey('longitude') ? Value(updates['longitude']) : const Value.absent(),
        locationName: updates.containsKey('locationName') ? Value(updates['locationName']) : const Value.absent(),
        accuracy: updates.containsKey('accuracy') ? Value(updates['accuracy']) : const Value.absent(),
        altitude: updates.containsKey('altitude') ? Value(updates['altitude']) : const Value.absent(),
        distanceFromPrevious:
            updates.containsKey('distanceFromPrevious') ? Value(updates['distanceFromPrevious']) : const Value.absent(),
        recordedAt: updates.containsKey('recordedAt') ? Value(updates['recordedAt']) : const Value.absent(),
        userId: updates.containsKey('userId') ? Value(updates['userId']) : const Value.absent(),
        createdAt: updates.containsKey('createdAt') ? Value(updates['createdAt']) : const Value.absent(),
      );

      return await (_db.update(_db.locationRecordTable)..where((t) => t.id.equals(id))).write(companion);
    } catch (e) {
      throw Exception('更新定位记录失败: $e');
    }
  }

  /// 删除定位记录
  @override
  Future<int> deleteLocationRecord(int id) async {
    try {
      return await (_db.delete(_db.locationRecordTable)..where((t) => t.id.equals(id))).go();
    } catch (e) {
      throw Exception('删除定位记录失败: $e');
    }
  }

  /// 删除指定时间之前的记录
  @override
  Future<int> deleteLocationRecordsBeforeTime(int timestamp) async {
    try {
      return await (_db.delete(_db.locationRecordTable)..where((t) => t.recordedAt.isSmallerThanValue(timestamp))).go();
    } catch (e) {
      throw Exception('删除历史定位记录失败: $e');
    }
  }

  /// 获取定位记录数量
  @override
  Future<int> getLocationRecordCount(int userId) async {
    try {
      final query = _db.selectOnly(_db.locationRecordTable)
        ..addColumns([_db.locationRecordTable.id.count()])
        ..where(_db.locationRecordTable.userId.equals(userId));

      final result = await query.getSingle();
      return result.read(_db.locationRecordTable.id.count()) ?? 0;
    } catch (e) {
      throw Exception('获取定位记录数量失败: $e');
    }
  }

  /// 删除用户所有定位记录
  @override
  Future<int> deleteAllLocationRecords(int userId) async {
    try {
      return await (_db.delete(_db.locationRecordTable)..where((t) => t.userId.equals(userId))).go();
    } catch (e) {
      throw Exception('删除用户所有定位记录失败: $e');
    }
  }

  /// 将数据库记录转换为数据模型
  LocationRecordData _convertToLocationRecordData(LocationRecordTableData record) {
    return LocationRecordData(
      id: record.id,
      latitude: record.latitude,
      longitude: record.longitude,
      locationName: record.locationName,
      accuracy: record.accuracy,
      altitude: record.altitude,
      distanceFromPrevious: record.distanceFromPrevious,
      recordedAt: record.recordedAt,
      userId: record.userId,
      createdAt: record.createdAt,
    );
  }
}
