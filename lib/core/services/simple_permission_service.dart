import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// 简化的权限服务
class SimplePermissionService {
  static final SimplePermissionService _instance = SimplePermissionService._internal();
  factory SimplePermissionService() => _instance;
  SimplePermissionService._internal();

  /// 检查并请求定位权限
  Future<LocationPermissionResult> checkAndRequestLocationPermission() async {
    debugPrint('🔐 SimplePermissionService: 开始检查定位权限...');

    try {
      // 1. 检查定位服务是否开启
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('❌ SimplePermissionService: 定位服务未开启');
        return LocationPermissionResult(
          isGranted: false,
          status: 'serviceDisabled',
          message: '定位服务未开启，请在系统设置中开启定位服务',
        );
      }
      debugPrint('✅ SimplePermissionService: 定位服务已开启');

      // 2. 检查基础定位权限
      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('🔐 SimplePermissionService: 当前定位权限状态: $permission');

      if (permission == LocationPermission.denied) {
        debugPrint('🔐 SimplePermissionService: 权限被拒绝，尝试请求权限...');
        permission = await Geolocator.requestPermission();
        debugPrint('🔐 SimplePermissionService: 权限请求结果: $permission');
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('❌ SimplePermissionService: 定位权限被永久拒绝');
        return LocationPermissionResult(
          isGranted: false,
          status: 'deniedForever',
          message: '定位权限被永久拒绝，请在应用设置中手动开启定位权限',
          canOpenSettings: true,
        );
      }

      if (permission == LocationPermission.denied) {
        debugPrint('❌ SimplePermissionService: 定位权限被拒绝');
        return LocationPermissionResult(
          isGranted: false,
          status: 'denied',
          message: '定位权限被拒绝，无法获取位置信息',
        );
      }

      // 3. 检查后台定位权限（可选）
      bool backgroundLocationGranted = false;
      if (Platform.isAndroid) {
        debugPrint('🔐 SimplePermissionService: 检查Android后台定位权限...');
        try {
          final backgroundStatus = await ph.Permission.locationAlways.status;
          debugPrint('🔐 SimplePermissionService: Android后台定位权限状态: $backgroundStatus');

          if (backgroundStatus.isDenied) {
            debugPrint('🔐 SimplePermissionService: 请求Android后台定位权限...');
            final requestResult = await ph.Permission.locationAlways.request();
            debugPrint('🔐 SimplePermissionService: Android后台定位权限请求结果: $requestResult');
            backgroundLocationGranted = requestResult.isGranted;
          } else {
            backgroundLocationGranted = backgroundStatus.isGranted;
          }
        } catch (e) {
          debugPrint('⚠️ SimplePermissionService: 后台定位权限检查失败 - $e');
        }
      } else if (Platform.isIOS) {
        // iOS的后台定位权限通过Geolocator处理
        debugPrint('🔐 SimplePermissionService: iOS平台，后台定位权限通过Info.plist配置');
        backgroundLocationGranted = permission == LocationPermission.always;
      }

      debugPrint('✅ SimplePermissionService: 定位权限检查完成');
      debugPrint('📍 基础定位权限: $permission');
      debugPrint('📍 后台定位权限: $backgroundLocationGranted');

      return LocationPermissionResult(
        isGranted: true,
        status: 'granted',
        message: '定位权限已获取',
        hasBackgroundPermission: backgroundLocationGranted,
        permissionLevel: _getPermissionLevelText(permission),
      );
    } catch (e) {
      debugPrint('❌ SimplePermissionService: 权限检查失败 - $e');
      return LocationPermissionResult(
        isGranted: false,
        status: 'error',
        message: '权限检查失败: $e',
      );
    }
  }

  /// 打开应用设置页面
  Future<bool> openAppSettings() async {
    try {
      debugPrint('🔐 SimplePermissionService: 尝试打开应用设置页面...');
      final result = await ph.openAppSettings();
      debugPrint('🔐 SimplePermissionService: 打开设置页面结果: $result');
      return result;
    } catch (e) {
      debugPrint('❌ SimplePermissionService: 打开设置页面失败 - $e');
      return false;
    }
  }

  /// 获取权限级别文本
  String _getPermissionLevelText(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
        return '始终允许';
      case LocationPermission.whileInUse:
        return '使用时允许';
      case LocationPermission.denied:
        return '已拒绝';
      case LocationPermission.deniedForever:
        return '永久拒绝';
      case LocationPermission.unableToDetermine:
        return '无法确定';
    }
  }
}

/// 定位权限结果
class LocationPermissionResult {
  final bool isGranted;
  final String status;
  final String message;
  final bool hasBackgroundPermission;
  final String? permissionLevel;
  final bool canOpenSettings;

  LocationPermissionResult({
    required this.isGranted,
    required this.status,
    required this.message,
    this.hasBackgroundPermission = false,
    this.permissionLevel,
    this.canOpenSettings = false,
  });

  @override
  String toString() {
    return 'LocationPermissionResult{isGranted: $isGranted, status: $status, message: $message, hasBackgroundPermission: $hasBackgroundPermission, permissionLevel: $permissionLevel, canOpenSettings: $canOpenSettings}';
  }
}
