import 'package:drift/drift.dart';

/// 定位记录表
/// 用于存储用户的定位信息
class LocationRecordTable extends Table {
  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 纬度
  RealColumn get latitude => real()();

  /// 经度
  RealColumn get longitude => real()();

  /// 位置名称/地址描述
  TextColumn get locationName => text().withLength(min: 1, max: 500).nullable()();

  /// 定位精度（米）
  RealColumn get accuracy => real().nullable()();

  /// 海拔高度（米）
  RealColumn get altitude => real().nullable()();

  /// 与上一次定位的直线距离（米）
  RealColumn get distanceFromPrevious => real().nullable()();

  /// 记录时间（Unix时间戳）
  IntColumn get recordedAt => integer()();

  /// 用户ID
  IntColumn get userId => integer()();

  /// 创建时间（Unix时间戳）
  IntColumn get createdAt => integer()();

  @override
  String get tableName => 'location_record_table';
}
