import 'package:drift/drift.dart';
import 'package:WeekLife/data/database/app_database.dart';
import 'package:WeekLife/core/utils/database/database_manager.dart';

/// 定位记录仓库
/// 负责定位数据的数据库操作
class LocationRepository {
  final AppDatabase _database;

  LocationRepository() : _database = DatabaseManager.instance.database;

  /// 插入定位记录
  Future<int> insertLocationRecord({
    required double latitude,
    required double longitude,
    String? locationName,
    double? accuracy,
    double? altitude,
    double? distanceFromPrevious,
    required int userId,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final companion = LocationRecordTableCompanion(
      latitude: Value(latitude),
      longitude: Value(longitude),
      locationName: Value(locationName),
      accuracy: Value(accuracy),
      altitude: Value(altitude),
      distanceFromPrevious: Value(distanceFromPrevious),
      recordedAt: Value(now),
      userId: Value(userId),
      createdAt: Value(now),
    );

    return await _database.into(_database.locationRecordTable).insert(companion);
  }

  /// 根据用户ID查询定位记录
  Future<List<LocationRecordTableData>> getLocationRecordsByUserId(
    int userId, {
    int? limit,
    int? offset,
  }) async {
    var query = _database.select(_database.locationRecordTable)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]);

    if (limit != null) {
      query = query..limit(limit, offset: offset);
    }

    return await query.get();
  }

  /// 根据时间范围查询定位记录
  Future<List<LocationRecordTableData>> getLocationRecordsByTimeRange(
    int userId,
    int startTime,
    int endTime,
  ) async {
    return await (_database.select(_database.locationRecordTable)
          ..where((t) => t.userId.equals(userId) & t.recordedAt.isBetweenValues(startTime, endTime))
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
        .get();
  }

  /// 获取最近的定位记录
  Future<LocationRecordTableData?> getLatestLocationRecord(int userId) async {
    final result = await (_database.select(_database.locationRecordTable)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
          ..limit(1))
        .getSingleOrNull();

    return result;
  }

  /// 删除指定时间之前的定位记录
  Future<int> deleteLocationRecordsBeforeTime(int timestamp) async {
    return await (_database.delete(_database.locationRecordTable)
          ..where((t) => t.recordedAt.isSmallerThanValue(timestamp)))
        .go();
  }

  /// 获取定位记录总数
  Future<int> getLocationRecordCount(int userId) async {
    final query = _database.selectOnly(_database.locationRecordTable)
      ..addColumns([_database.locationRecordTable.id.count()])
      ..where(_database.locationRecordTable.userId.equals(userId));

    final result = await query.getSingle();
    return result.read(_database.locationRecordTable.id.count()) ?? 0;
  }

  /// 删除用户的所有定位记录
  Future<int> deleteAllLocationRecords(int userId) async {
    return await (_database.delete(_database.locationRecordTable)..where((t) => t.userId.equals(userId))).go();
  }
}
