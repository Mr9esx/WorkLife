import 'package:flutter/widgets.dart';
import 'package:WeekLife/core/services/background_location_service.dart';
import 'package:WeekLife/core/services/geocoding_service.dart';
import 'package:WeekLife/data/repositories/location/location_repo.dart';
import 'package:WeekLife/data/models/location/location_record_data.dart';
import 'package:WeekLife/core/services/user_service.dart';
import 'package:WeekLife/data/database/app_database.dart';
import 'package:WeekLife/core/services/ios_widget_channel.dart';

/// 定位管理器
/// 整合后台定位服务和数据存储
/// 增强版本：支持应用生命周期感知和更强的后台持续性
class LocationManager {
  static final LocationManager _instance = LocationManager._internal();
  factory LocationManager() => _instance;
  LocationManager._internal();

  final BackgroundLocationService _locationService = BackgroundLocationService();
  final LocationRepository _locationRepository = LocationRepository();
  final UserService _userService = UserService();
  final GeocodingService _geocodingService = GeocodingService();

  bool _isInitialized = false;
  bool _autoRestartEnabled = true; // 是否启用自动重启

  /// 初始化定位管理器
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 设置定位更新回调
    _locationService.setLocationUpdateCallback(_onLocationUpdate);

    // 设置应用生命周期回调
    _locationService.setAppLifecycleCallback(_onAppLifecycleChanged);

    _isInitialized = true;
    debugPrint('✅ LocationManager: 定位管理器初始化完成');
  }

  /// 启动后台定位服务
  Future<bool> startBackgroundLocation() async {
    if (!_isInitialized) {
      await initialize();
    }

    final success = await _locationService.startLocationService();
    if (success) {
      debugPrint('✅ LocationManager: 后台定位服务已启动');
    } else {
      debugPrint('❌ LocationManager: 后台定位服务启动失败');
    }

    return success;
  }

  /// 停止后台定位服务
  void stopBackgroundLocation() {
    _locationService.stopLocationService();
    debugPrint('🛑 LocationManager: 后台定位服务已停止');
  }

  /// 检查服务是否在运行
  bool get isRunning => _locationService.isRunning;

  /// 设置自动重启功能
  void setAutoRestart(bool enabled) {
    _autoRestartEnabled = enabled;
    debugPrint('🔄 LocationManager: 自动重启功能${enabled ? '已启用' : '已禁用'}');
  }

  /// 应用生命周期变化处理
  void _onAppLifecycleChanged(AppLifecycleState state) {
    debugPrint('🔄 LocationManager: 收到应用生命周期变化 - $state');

    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.detached:
        _onAppDetached();
        break;
      default:
        break;
    }
  }

  /// 应用恢复到前台
  void _onAppResumed() {
    debugPrint('🌟 LocationManager: 应用恢复到前台');

    // 同步Widget收集的定位数据
    if (IOSWidgetChannel.isIOSPlatform) {
      syncWidgetLocations();
    }

    // 如果自动重启启用且服务未运行，尝试重启
    if (_autoRestartEnabled && !_locationService.isRunning) {
      debugPrint('🔄 LocationManager: 检测到服务未运行，尝试自动重启');
      startBackgroundLocation();
    }
  }

  /// 应用进入后台
  void _onAppPaused() {
    debugPrint('🌙 LocationManager: 应用进入后台');
    // 后台模式下保持服务运行
  }

  /// 应用被分离
  void _onAppDetached() {
    debugPrint('🔌 LocationManager: 应用被分离');
    // 保存当前状态，为下次启动做准备
    _saveLocationServiceState();
  }

  /// 保存定位服务状态
  void _saveLocationServiceState() {
    try {
      // 这里可以保存到SharedPreferences或数据库
      // 记录服务是否应该在下次启动时自动开启
      debugPrint('💾 LocationManager: 保存定位服务状态');
    } catch (e) {
      debugPrint('❌ LocationManager: 保存状态失败 - $e');
    }
  }

  /// 定位更新回调
  Future<void> _onLocationUpdate(
    double latitude,
    double longitude,
    String? locationName,
    double? accuracy,
    double? altitude,
  ) async {
    final startTime = DateTime.now();
    debugPrint('📍 LocationManager: [${startTime.toLocal()}] 收到定位更新');
    debugPrint('📍 位置信息: 纬度=$latitude, 经度=$longitude, 地址=$locationName');

    try {
      // 获取当前用户ID
      final userId = await _userService.getCurrentUserId();
      if (userId == null) {
        debugPrint('❌ LocationManager: 无法获取当前用户ID，跳过定位记录保存');
        return;
      }

      // 检查距离阈值（避免重复记录相近位置）
      final shouldSave = await _shouldSaveLocation(userId, latitude, longitude);
      if (!shouldSave) {
        debugPrint('⚠️ LocationManager: 位置变化不足，跳过保存');
        return;
      }

      // 保存到数据库
      final locationRecord = LocationRecordData.create(
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
        accuracy: accuracy,
        altitude: altitude,
        userId: userId,
      );
      await _locationRepository.createLocationRecord(locationRecord);

      final endTime = DateTime.now();
      debugPrint('✅ LocationManager: [${endTime.toLocal()}] 定位记录保存成功');
      debugPrint('📍 处理耗时: ${endTime.difference(startTime).inMilliseconds}ms');

      // 清理旧记录（可选）
      await _cleanupOldRecordsIfNeeded();
    } catch (e, stackTrace) {
      final errorTime = DateTime.now();
      debugPrint('❌ LocationManager: [${errorTime.toLocal()}] 保存定位记录失败');
      debugPrint('❌ 错误详情: $e');
      debugPrint('❌ 堆栈跟踪: $stackTrace');
      debugPrint('❌ 处理耗时: ${errorTime.difference(startTime).inMilliseconds}ms');
    }
  }

  /// 检查是否应该保存定位记录
  Future<bool> _shouldSaveLocation(int userId, double latitude, double longitude) async {
    try {
      // 获取最近的定位记录
      final recentRecords = await _locationRepository.getLocationRecordsByUserId(
        userId,
        limit: 1,
      );
      if (recentRecords.isEmpty) {
        return true; // 没有历史记录，直接保存
      }

      final lastRecord = recentRecords.first;
      final distance = _locationService.calculateDistance(
        lastRecord.latitude,
        lastRecord.longitude,
        latitude,
        longitude,
      );

      // 获取距离阈值配置
      const minDistance = 50.0; // 最小距离阈值（米）

      if (distance >= minDistance) {
        debugPrint('📍 LocationManager: 距离变化 ${distance.toStringAsFixed(1)}m，满足保存条件');
        return true;
      } else {
        debugPrint('📍 LocationManager: 距离变化 ${distance.toStringAsFixed(1)}m，不满足保存条件（阈值: ${minDistance}m）');
        return false;
      }
    } catch (e) {
      debugPrint('❌ LocationManager: 检查保存条件失败 - $e');
      return true; // 出错时默认保存
    }
  }

  /// 定期清理旧记录
  Future<void> _cleanupOldRecordsIfNeeded() async {
    try {
      // 可以根据需要实现定期清理逻辑
      // 例如：每保存10条记录后清理一次
      // 或者根据时间戳清理超过30天的记录
    } catch (e) {
      debugPrint('❌ LocationManager: 清理旧记录失败 - $e');
    }
  }

  /// 手动获取一次定位
  Future<void> getLocationOnce() async {
    final startTime = DateTime.now();
    debugPrint('📍 LocationManager: [${startTime.toLocal()}] 开始手动获取定位...');

    try {
      final position = await _locationService.getManualLocation();
      if (position != null) {
        debugPrint('📍 LocationManager: 定位获取成功 - 纬度: ${position.latitude}, 经度: ${position.longitude}');

        // 获取地址信息
        String? locationName;
        try {
          debugPrint('🌍 LocationManager: 开始获取地址信息...');
          final addressStartTime = DateTime.now();

          locationName = await _geocodingService.getAddressFromCoordinates(
            position.latitude,
            position.longitude,
          );

          final addressEndTime = DateTime.now();
          if (locationName != null) {
            debugPrint('✅ LocationManager: 地址解析成功 - $locationName');
            debugPrint('🌍 地址解析耗时: ${addressEndTime.difference(addressStartTime).inMilliseconds}ms');
          } else {
            debugPrint('⚠️ LocationManager: 地址解析返回空值');
          }
        } catch (e) {
          debugPrint('❌ LocationManager: 地址解析失败 - $e');
        }

        // 保存定位记录（包含地址信息）
        _onLocationUpdate(
          position.latitude,
          position.longitude,
          locationName,
          position.accuracy,
          position.altitude,
        );

        final endTime = DateTime.now();
        debugPrint('✅ LocationManager: [${endTime.toLocal()}] 手动定位完成');
        debugPrint('📍 总耗时: ${endTime.difference(startTime).inMilliseconds}ms');
      } else {
        debugPrint('❌ LocationManager: 手动获取定位失败');
      }
    } catch (e, stackTrace) {
      final errorTime = DateTime.now();
      debugPrint('❌ LocationManager: [${errorTime.toLocal()}] 手动定位异常');
      debugPrint('❌ 错误详情: $e');
      debugPrint('❌ 堆栈跟踪: $stackTrace');
      debugPrint('❌ 处理耗时: ${errorTime.difference(startTime).inMilliseconds}ms');
    }
  }

  /// 获取用户定位记录
  Future<List<LocationRecordTableData>> getUserLocationRecords(
    int userId, {
    int limit = 50,
    int? startTimestamp,
    int? endTimestamp,
  }) async {
    try {
      List<LocationRecordData> records;
      if (startTimestamp != null && endTimestamp != null) {
        records = await _locationRepository.getLocationRecordsByTimeRange(
          userId,
          startTimestamp,
          endTimestamp,
        );
      } else {
        records = await _locationRepository.getLocationRecordsByUserId(
          userId,
          limit: limit,
        );
      }

      // 将 LocationRecordData 转换为 LocationRecordTableData
      return records
          .map((record) => LocationRecordTableData(
                id: record.id ?? 0,
                userId: record.userId,
                latitude: record.latitude,
                longitude: record.longitude,
                accuracy: record.accuracy,
                altitude: record.altitude,
                locationName: record.locationName,
                recordedAt: record.recordedAt,
                createdAt: record.createdAt,
              ))
          .toList();
    } catch (e) {
      debugPrint('❌ LocationManager: 获取用户定位记录失败 - $e');
      return [];
    }
  }

  /// 清理旧的定位记录
  Future<void> cleanupOldLocationRecords({int? daysToKeep}) async {
    try {
      final daysToKeepValue = daysToKeep ?? 30;
      final cutoffTime = DateTime.now().subtract(Duration(days: daysToKeepValue)).millisecondsSinceEpoch ~/ 1000;
      await _locationRepository.deleteLocationRecordsBeforeTime(cutoffTime);
      debugPrint('✅ LocationManager: 旧定位记录清理完成');
    } catch (e) {
      debugPrint('❌ LocationManager: 清理旧定位记录失败 - $e');
    }
  }

  /// 获取定位统计信息
  Future<Map<String, dynamic>> getLocationStats(int userId) async {
    try {
      final records = await getUserLocationRecords(userId, limit: 1000);

      if (records.isEmpty) {
        return {
          'totalRecords': 0,
          'totalDistance': 0.0,
          'firstRecordTime': null,
          'lastRecordTime': null,
        };
      }

      // 计算总距离
      double totalDistance = 0.0;
      for (int i = 1; i < records.length; i++) {
        final prev = records[i - 1];
        final curr = records[i];
        totalDistance += _locationService.calculateDistance(
          prev.latitude,
          prev.longitude,
          curr.latitude,
          curr.longitude,
        );
      }

      return {
        'totalRecords': records.length,
        'totalDistance': totalDistance,
        'firstRecordTime': records.last.recordedAt,
        'lastRecordTime': records.first.recordedAt,
      };
    } catch (e) {
      debugPrint('❌ LocationManager: 获取定位统计失败 - $e');
      return {
        'totalRecords': 0,
        'totalDistance': 0.0,
        'firstRecordTime': null,
        'lastRecordTime': null,
      };
    }
  }

  /// 同步Widget收集的定位数据
  Future<void> syncWidgetLocations() async {
    if (!IOSWidgetChannel.isIOSPlatform) {
      debugPrint('⚠️ LocationManager: 非iOS平台，跳过Widget数据同步');
      return;
    }

    try {
      debugPrint('📱 LocationManager: 开始同步Widget定位数据...');

      final widgetLocations = await IOSWidgetChannel.getWidgetLocations();

      if (widgetLocations.isEmpty) {
        debugPrint('📱 LocationManager: 没有Widget定位数据需要同步');
        return;
      }

      // 获取当前用户ID
      final userId = await _userService.getCurrentUserId();
      if (userId == null) {
        debugPrint('❌ LocationManager: 无法获取当前用户ID，跳过Widget数据同步');
        return;
      }

      int syncedCount = 0;
      int skippedCount = 0;

      for (final locationData in widgetLocations) {
        try {
          final latitude = (locationData['latitude'] as num?)?.toDouble();
          final longitude = (locationData['longitude'] as num?)?.toDouble();
          final timestamp = (locationData['timestamp'] as num?)?.toDouble();
          final accuracy = (locationData['accuracy'] as num?)?.toDouble();
          final altitude = (locationData['altitude'] as num?)?.toDouble();
          final address = locationData['address'] as String?;

          if (latitude == null || longitude == null || timestamp == null) {
            debugPrint('⚠️ LocationManager: Widget数据不完整，跳过：$locationData');
            skippedCount++;
            continue;
          }

          // 检查是否需要保存（距离阈值检查）
          final shouldSave = await _shouldSaveLocation(userId, latitude, longitude);
          if (!shouldSave) {
            debugPrint('⚠️ LocationManager: Widget位置变化不足，跳过保存');
            skippedCount++;
            continue;
          }

          // 保存Widget定位记录
          final locationRecord = LocationRecordData(
            userId: userId,
            latitude: latitude,
            longitude: longitude,
            accuracy: accuracy,
            altitude: altitude,
            locationName: address?.isNotEmpty == true ? address : null,
            recordedAt: timestamp.toInt(),
            createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          );
          await _locationRepository.createLocationRecord(locationRecord);

          syncedCount++;
          debugPrint('✅ LocationManager: Widget定位记录已保存 - 纬度: $latitude, 经度: $longitude');
        } catch (e) {
          debugPrint('❌ LocationManager: 处理Widget定位数据失败 - $e');
          skippedCount++;
        }
      }

      // 清理已同步的Widget数据
      await IOSWidgetChannel.clearWidgetLocations();

      debugPrint('✅ LocationManager: Widget数据同步完成');
      debugPrint('📊 同步统计: 成功 $syncedCount 条，跳过 $skippedCount 条');
    } catch (e) {
      debugPrint('❌ LocationManager: 同步Widget定位数据失败 - $e');
    }
  }

  /// 获取Widget定位统计信息
  Future<WidgetLocationStats> getWidgetLocationStats() async {
    if (!IOSWidgetChannel.isIOSPlatform) {
      return WidgetLocationStats(
        totalCount: 0,
        oldestTimestamp: null,
        newestTimestamp: null,
        averageAccuracy: 0,
      );
    }

    try {
      return await IOSWidgetChannel.getWidgetLocationStats();
    } catch (e) {
      debugPrint('❌ LocationManager: 获取Widget统计信息失败 - $e');
      return WidgetLocationStats(
        totalCount: 0,
        oldestTimestamp: null,
        newestTimestamp: null,
        averageAccuracy: 0,
      );
    }
  }

  /// 清理资源
  void dispose() {
    _locationService.dispose();
  }
}
