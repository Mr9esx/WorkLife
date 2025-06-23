import 'package:drift/drift.dart' hide JsonKey;
import 'package:WeekLife/data/database/tables/location_record_tbl.dart';

/// 定位记录数据模型
class LocationRecordData {
  final int? id;
  final double latitude;
  final double longitude;
  final String? locationName;
  final double? accuracy;
  final double? altitude;
  final double? distanceFromPrevious;
  final int recordedAt;
  final int userId;
  final int createdAt;

  const LocationRecordData({
    this.id,
    required this.latitude,
    required this.longitude,
    this.locationName,
    this.accuracy,
    this.altitude,
    this.distanceFromPrevious,
    required this.recordedAt,
    required this.userId,
    required this.createdAt,
  });

  /// 从时间戳创建便捷方法
  factory LocationRecordData.create({
    required double latitude,
    required double longitude,
    String? locationName,
    double? accuracy,
    double? altitude,
    double? distanceFromPrevious,
    required int userId,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return LocationRecordData(
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
      accuracy: accuracy,
      altitude: altitude,
      distanceFromPrevious: distanceFromPrevious,
      recordedAt: now,
      userId: userId,
      createdAt: now,
    );
  }

  /// 复制并修改部分字段
  LocationRecordData copyWith({
    int? id,
    double? latitude,
    double? longitude,
    String? locationName,
    double? accuracy,
    double? altitude,
    double? distanceFromPrevious,
    int? recordedAt,
    int? userId,
    int? createdAt,
  }) {
    return LocationRecordData(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      distanceFromPrevious: distanceFromPrevious ?? this.distanceFromPrevious,
      recordedAt: recordedAt ?? this.recordedAt,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// 获取记录时间的 DateTime 对象
  DateTime get recordedDateTime => DateTime.fromMillisecondsSinceEpoch(recordedAt * 1000);

  /// 获取创建时间的 DateTime 对象
  DateTime get createdDateTime => DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);

  @override
  String toString() {
    return 'LocationRecordData(id: $id, lat: $latitude, lng: $longitude, locationName: $locationName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationRecordData &&
        other.id == id &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.locationName == locationName &&
        other.accuracy == accuracy &&
        other.altitude == altitude &&
        other.distanceFromPrevious == distanceFromPrevious &&
        other.recordedAt == recordedAt &&
        other.userId == userId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      latitude,
      longitude,
      locationName,
      accuracy,
      altitude,
      distanceFromPrevious,
      recordedAt,
      userId,
      createdAt,
    );
  }
}

/// 定位记录查询条件
class LocationRecordQuery {
  final int? id;
  final int? userId;
  final double? minLatitude;
  final double? maxLatitude;
  final double? minLongitude;
  final double? maxLongitude;
  final String? locationName;
  final int? recordedAtStart;
  final int? recordedAtEnd;
  final int? createdAtStart;
  final int? createdAtEnd;
  final int? limit;
  final int? offset;
  final String? orderBy;
  final bool? orderDesc;

  LocationRecordQuery({
    this.id,
    this.userId,
    this.minLatitude,
    this.maxLatitude,
    this.minLongitude,
    this.maxLongitude,
    this.locationName,
    this.recordedAtStart,
    this.recordedAtEnd,
    this.createdAtStart,
    this.createdAtEnd,
    this.limit,
    this.offset,
    this.orderBy,
    this.orderDesc,
  });

  /// 将查询条件转换为数据库查询表达式
  Expression<bool> Function(LocationRecordTable) toWhereClause() {
    return (tbl) {
      var conditions = <Expression<bool>>[];

      if (id != null) {
        conditions.add(tbl.id.equals(id!));
      }
      if (userId != null) {
        conditions.add(tbl.userId.equals(userId!));
      }
      if (minLatitude != null) {
        conditions.add(tbl.latitude.isBiggerOrEqualValue(minLatitude!));
      }
      if (maxLatitude != null) {
        conditions.add(tbl.latitude.isSmallerOrEqualValue(maxLatitude!));
      }
      if (minLongitude != null) {
        conditions.add(tbl.longitude.isBiggerOrEqualValue(minLongitude!));
      }
      if (maxLongitude != null) {
        conditions.add(tbl.longitude.isSmallerOrEqualValue(maxLongitude!));
      }
      if (locationName != null) {
        conditions.add(tbl.locationName.like('%$locationName%'));
      }
      if (recordedAtStart != null) {
        conditions.add(tbl.recordedAt.isBiggerOrEqualValue(recordedAtStart!));
      }
      if (recordedAtEnd != null) {
        conditions.add(tbl.recordedAt.isSmallerOrEqualValue(recordedAtEnd!));
      }
      if (createdAtStart != null) {
        conditions.add(tbl.createdAt.isBiggerOrEqualValue(createdAtStart!));
      }
      if (createdAtEnd != null) {
        conditions.add(tbl.createdAt.isSmallerOrEqualValue(createdAtEnd!));
      }

      return conditions.fold(
        const Constant(true),
        (prev, condition) => prev & condition,
      );
    };
  }
}

/// 排序字段枚举
enum LocationRecordSortField {
  id,
  latitude,
  longitude,
  recordedAt,
  createdAt,
}

/// 排序顺序枚举
enum SortOrder {
  asc,
  desc,
}
