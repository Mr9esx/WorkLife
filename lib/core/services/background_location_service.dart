import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:WeekLife/core/services/simple_permission_service.dart';
import 'package:WeekLife/core/services/geocoding_service.dart';
import 'package:WeekLife/core/services/location_config_service.dart';

/// 定位更新回调函数类型
typedef LocationUpdateCallback = void Function(
  double latitude,
  double longitude,
  String? locationName,
  double? accuracy,
  double? altitude,
);

/// 应用生命周期状态回调
typedef AppLifecycleCallback = void Function(AppLifecycleState state);

/// 后台定位服务
/// 负责后台定位和定位数据存储
/// 增强版本：支持应用生命周期监听和更强的后台持续性
class BackgroundLocationService with WidgetsBindingObserver {
  static final BackgroundLocationService _instance = BackgroundLocationService._internal();
  factory BackgroundLocationService() => _instance;
  BackgroundLocationService._internal();

  Timer? _locationTimer;
  Timer? _healthCheckTimer;
  bool _isRunning = false;
  bool _isInBackground = false;
  bool _lifecycleObserverAdded = false;

  final SimplePermissionService _permissionService = SimplePermissionService();
  final GeocodingService _geocodingService = GeocodingService();

  LocationUpdateCallback? _locationUpdateCallback;
  AppLifecycleCallback? _appLifecycleCallback;

  // 后台定位相关配置
  static const int _backgroundLocationInterval = 5; // 后台定位间隔（分钟）
  static const int _foregroundLocationInterval = 1; // 前台定位间隔（分钟）
  static const int _healthCheckInterval = 30; // 健康检查间隔（秒）

  /// 设置定位更新回调
  void setLocationUpdateCallback(LocationUpdateCallback callback) {
    _locationUpdateCallback = callback;
    debugPrint('🔔 BackgroundLocationService: 定位更新回调已设置');
  }

  /// 设置应用生命周期回调
  void setAppLifecycleCallback(AppLifecycleCallback callback) {
    _appLifecycleCallback = callback;
    debugPrint('🔔 BackgroundLocationService: 应用生命周期回调已设置');
  }

  /// 启动后台定位服务
  Future<bool> startLocationService() async {
    if (_isRunning) {
      debugPrint('⚠️ BackgroundLocationService: 服务已在运行中');
      return true;
    }

    try {
      // 添加生命周期监听器
      if (!_lifecycleObserverAdded) {
        WidgetsBinding.instance.addObserver(this);
        _lifecycleObserverAdded = true;
        debugPrint('✅ BackgroundLocationService: 已添加生命周期监听器');
      }

      // 检查定位权限
      final hasPermission = await _checkLocationPermission();
      if (!hasPermission) {
        debugPrint('❌ BackgroundLocationService: 定位权限不足');
        return false;
      }

      // 获取配置的定位间隔
      final intervalMinutes = await LocationConfigService.getLocationIntervalMinutes();
      final intervalDuration = Duration(minutes: intervalMinutes);

      debugPrint('🚀 BackgroundLocationService: 启动定位服务');
      debugPrint('⏰ 定位间隔: ${LocationConfigService.getIntervalDisplayText(intervalMinutes)}');

      // 立即获取一次定位
      await _performLocationUpdate();

      // 启动定时器
      _startLocationTimer(intervalDuration);

      // 启动健康检查定时器
      _startHealthCheckTimer();

      _isRunning = true;
      debugPrint('✅ BackgroundLocationService: 服务启动成功');
      return true;
    } catch (e) {
      debugPrint('❌ BackgroundLocationService: 启动失败 - $e');
      return false;
    }
  }

  /// 启动定位定时器
  void _startLocationTimer(Duration interval) {
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(interval, (timer) async {
      await _performLocationUpdate();
    });
    debugPrint('⏰ BackgroundLocationService: 定位定时器已启动，间隔: ${interval.inMinutes}分钟');
  }

  /// 启动健康检查定时器
  void _startHealthCheckTimer() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(
      const Duration(seconds: _healthCheckInterval),
      (timer) async {
        await _performHealthCheck();
      },
    );
    debugPrint('🏥 BackgroundLocationService: 健康检查定时器已启动');
  }

  /// 执行健康检查
  Future<void> _performHealthCheck() async {
    try {
      // 检查定位服务是否可用
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('⚠️ BackgroundLocationService: 定位服务不可用');
        return;
      }

      // 检查权限状态
      final result = await _permissionService.checkAndRequestLocationPermission();
      if (!result.isGranted) {
        debugPrint('⚠️ BackgroundLocationService: 定位权限丢失');
        return;
      }

      // 如果在后台，尝试获取一次定位以保持活跃
      if (_isInBackground) {
        try {
          await _performLocationUpdate();
          debugPrint('🏥 BackgroundLocationService: 后台健康检查定位成功');
        } catch (e) {
          debugPrint('⚠️ BackgroundLocationService: 后台健康检查定位失败 - $e');
        }
      }

      debugPrint('🏥 BackgroundLocationService: 健康检查完成');
    } catch (e) {
      debugPrint('❌ BackgroundLocationService: 健康检查失败 - $e');
    }
  }

  /// 停止后台定位服务
  void stopLocationService() {
    _locationTimer?.cancel();
    _locationTimer = null;

    _healthCheckTimer?.cancel();
    _healthCheckTimer = null;

    if (_lifecycleObserverAdded) {
      WidgetsBinding.instance.removeObserver(this);
      _lifecycleObserverAdded = false;
      debugPrint('✅ BackgroundLocationService: 已移除生命周期监听器');
    }

    _isRunning = false;
    debugPrint('🛑 BackgroundLocationService: 后台定位服务已停止');
  }

  /// 检查服务是否在运行
  bool get isRunning => _isRunning;

  /// 应用生命周期变化处理
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('🔄 BackgroundLocationService: 应用生命周期变化 - $state');

    _appLifecycleCallback?.call(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.inactive:
        _onAppInactive();
        break;
      case AppLifecycleState.detached:
        _onAppDetached();
        break;
      case AppLifecycleState.hidden:
        _onAppHidden();
        break;
    }
  }

  /// 应用恢复到前台
  void _onAppResumed() {
    debugPrint('🌟 BackgroundLocationService: 应用恢复到前台');
    _isInBackground = false;

    if (_isRunning) {
      // 切换到前台定位间隔
      _switchToForegroundMode();
    }
  }

  /// 应用进入后台
  void _onAppPaused() {
    debugPrint('🌙 BackgroundLocationService: 应用进入后台');
    _isInBackground = true;

    if (_isRunning) {
      // 切换到后台定位间隔
      _switchToBackgroundMode();
    }
  }

  /// 应用变为非活跃状态
  void _onAppInactive() {
    debugPrint('😴 BackgroundLocationService: 应用变为非活跃状态');
  }

  /// 应用被分离
  void _onAppDetached() {
    debugPrint('🔌 BackgroundLocationService: 应用被分离');
    // 应用即将被完全关闭，尝试保存当前状态
    _saveServiceState();
  }

  /// 应用被隐藏
  void _onAppHidden() {
    debugPrint('👻 BackgroundLocationService: 应用被隐藏');
    _isInBackground = true;
  }

  /// 切换到前台模式
  void _switchToForegroundMode() {
    debugPrint('🌟 BackgroundLocationService: 切换到前台模式');
    final interval = Duration(minutes: _foregroundLocationInterval);
    _startLocationTimer(interval);
  }

  /// 切换到后台模式
  void _switchToBackgroundMode() {
    debugPrint('🌙 BackgroundLocationService: 切换到后台模式');
    final interval = Duration(minutes: _backgroundLocationInterval);
    _startLocationTimer(interval);

    // 立即执行一次定位更新
    _performLocationUpdate();
  }

  /// 保存服务状态
  void _saveServiceState() {
    try {
      // 这里可以保存服务状态到本地存储
      // 以便应用重启后恢复服务
      debugPrint('💾 BackgroundLocationService: 保存服务状态');
    } catch (e) {
      debugPrint('❌ BackgroundLocationService: 保存服务状态失败 - $e');
    }
  }

  /// 检查定位权限
  Future<bool> _checkLocationPermission() async {
    debugPrint('🔐 BackgroundLocationService: 开始权限检查...');

    try {
      final result = await _permissionService.checkAndRequestLocationPermission();
      debugPrint('🔐 BackgroundLocationService: 权限检查结果: $result');

      if (!result.isGranted) {
        debugPrint('❌ BackgroundLocationService: ${result.message}');

        // 如果权限被永久拒绝，提示用户手动开启
        if (result.status == 'deniedForever') {
          debugPrint('💡 BackgroundLocationService: 建议用户手动开启权限');
          // 这里可以显示对话框引导用户到设置页面
        }

        return false;
      }

      debugPrint('✅ BackgroundLocationService: 定位权限已获取');
      if (result.hasBackgroundPermission) {
        debugPrint('✅ BackgroundLocationService: 后台定位权限已获取');
      } else {
        debugPrint('⚠️ BackgroundLocationService: 后台定位权限未获取，将使用前台定位');
      }

      return true;
    } catch (e) {
      debugPrint('❌ BackgroundLocationService: 权限检查异常 - $e');
      return false;
    }
  }

  /// 获取当前定位并保存
  Future<void> _performLocationUpdate() async {
    final startTime = DateTime.now();
    final modeText = _isInBackground ? '后台' : '前台';
    debugPrint('📍 BackgroundLocationService: [${startTime.toLocal()}] 开始获取定位($modeText)...');

    try {
      // 根据当前模式调整定位精度
      final accuracy = _isInBackground ? LocationAccuracy.medium : LocationAccuracy.high;

      final timeLimit = _isInBackground ? const Duration(seconds: 60) : const Duration(seconds: 30);

      // 获取当前位置
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeLimit,
      );

      final locationTime = DateTime.now();
      debugPrint('📍 BackgroundLocationService: [${locationTime.toLocal()}] 定位获取成功($modeText)');
      debugPrint('📍 详细信息:');
      debugPrint('   - 纬度: ${position.latitude}');
      debugPrint('   - 经度: ${position.longitude}');
      debugPrint('   - 精度: ${position.accuracy}m');
      debugPrint('   - 海拔: ${position.altitude}m');
      debugPrint('   - 获取耗时: ${locationTime.difference(startTime).inMilliseconds}ms');

      // 尝试获取地址信息
      String? locationName;
      try {
        debugPrint('🌍 BackgroundLocationService: 开始获取地址信息...');
        final addressStartTime = DateTime.now();

        locationName = await _geocodingService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );

        final addressEndTime = DateTime.now();
        if (locationName != null) {
          debugPrint('✅ BackgroundLocationService: 地址解析成功 - $locationName');
          debugPrint('🌍 地址解析耗时: ${addressEndTime.difference(addressStartTime).inMilliseconds}ms');
        } else {
          debugPrint('⚠️ BackgroundLocationService: 地址解析返回空值');
        }
      } catch (e) {
        debugPrint('❌ BackgroundLocationService: 地址解析失败 - $e');
      }

      // 调用回调函数保存定位记录
      if (_locationUpdateCallback != null) {
        try {
          _locationUpdateCallback!(
            position.latitude,
            position.longitude,
            locationName,
            position.accuracy,
            position.altitude,
          );
          debugPrint('✅ BackgroundLocationService: 定位数据已传递给回调函数');
        } catch (e) {
          debugPrint('❌ BackgroundLocationService: 回调函数执行失败 - $e');
        }
      } else {
        debugPrint('⚠️ BackgroundLocationService: 未设置回调函数');
      }

      final endTime = DateTime.now();
      debugPrint('✅ BackgroundLocationService: [${endTime.toLocal()}] 定位处理完成($modeText)');
      debugPrint('📍 总耗时: ${endTime.difference(startTime).inMilliseconds}ms');

      // 显示下次定位时间
      try {
        final currentInterval =
            _isInBackground ? _backgroundLocationInterval : await LocationConfigService.getLocationIntervalMinutes();
        final nextLocationTime = endTime.add(Duration(minutes: currentInterval));
        debugPrint('📍 下次定位时间: ${nextLocationTime.toLocal()}');
      } catch (e) {
        debugPrint('📍 无法获取定位间隔配置');
      }
    } catch (e) {
      final errorTime = DateTime.now();
      debugPrint('❌ BackgroundLocationService: [${errorTime.toLocal()}] 获取定位失败($modeText)');
      debugPrint('❌ 错误详情: $e');
      debugPrint('❌ 错误类型: ${e.runtimeType}');
      debugPrint('❌ 处理耗时: ${errorTime.difference(startTime).inMilliseconds}ms');

      // 显示下次重试时间
      try {
        final currentInterval =
            _isInBackground ? _backgroundLocationInterval : await LocationConfigService.getLocationIntervalMinutes();
        final nextRetryTime = errorTime.add(Duration(minutes: currentInterval));
        debugPrint('📍 下次重试时间: ${nextRetryTime.toLocal()}');
      } catch (e) {
        debugPrint('📍 无法获取定位间隔配置');
      }
    }
  }

  /// 手动获取一次定位
  Future<Position?> getManualLocation() async {
    try {
      if (!await _checkLocationPermission()) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );

      return position;
    } catch (e) {
      debugPrint('❌ BackgroundLocationService: 手动获取定位失败 - $e');
      return null;
    }
  }

  /// 计算两点之间的距离（米）
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  /// 清理服务资源
  void dispose() {
    stopLocationService();
  }
}

/// 简单地址信息类
class SimpleAddress {
  final String? name;
  final String? street;
  final String? locality;
  final String? administrativeArea;
  final String? subAdministrativeArea;
  final String? country;
  final String? postalCode;

  SimpleAddress({
    this.name,
    this.street,
    this.locality,
    this.administrativeArea,
    this.subAdministrativeArea,
    this.country,
    this.postalCode,
  });
}
