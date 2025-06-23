import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// 权限服务
/// 专门处理应用所需的各种权限
class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// 检查并请求定位权限
  Future<LocationPermissionResult> checkAndRequestLocationPermission() async {
    debugPrint('🔐 PermissionService: 开始检查定位权限...');

    try {
      // 1. 检查定位服务是否开启
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('❌ PermissionService: 定位服务未开启');
        return LocationPermissionResult(
          isGranted: false,
          status: LocationPermissionStatus.serviceDisabled,
          message: '定位服务未开启，请在设置中开启定位服务',
        );
      }
      debugPrint('✅ PermissionService: 定位服务已开启');

      // 2. 检查基础定位权限
      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('🔐 PermissionService: 当前定位权限状态: $permission');

      if (permission == LocationPermission.denied) {
        debugPrint('🔐 PermissionService: 权限被拒绝，尝试请求权限...');
        permission = await Geolocator.requestPermission();
        debugPrint('🔐 PermissionService: 权限请求结果: $permission');
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('❌ PermissionService: 定位权限被永久拒绝');
        return LocationPermissionResult(
          isGranted: false,
          status: LocationPermissionStatus.deniedForever,
          message: '定位权限被永久拒绝，请在设置中手动开启定位权限',
        );
      }

      if (permission == LocationPermission.denied) {
        debugPrint('❌ PermissionService: 定位权限被拒绝');
        return LocationPermissionResult(
          isGranted: false,
          status: LocationPermissionStatus.denied,
          message: '定位权限被拒绝，无法获取位置信息',
        );
      }

      // 3. 检查后台定位权限（可选）
      bool backgroundLocationGranted = false;
      if (Platform.isAndroid) {
        debugPrint('🔐 PermissionService: 检查Android后台定位权限...');
        final backgroundStatus = await Permission.locationAlways.status;
        debugPrint('🔐 PermissionService: Android后台定位权限状态: $backgroundStatus');

        if (backgroundStatus.isDenied) {
          debugPrint('🔐 PermissionService: 请求Android后台定位权限...');
          final requestResult = await Permission.locationAlways.request();
          debugPrint('🔐 PermissionService: Android后台定位权限请求结果: $requestResult');
          backgroundLocationGranted = requestResult.isGranted;
        } else {
          backgroundLocationGranted = backgroundStatus.isGranted;
        }
      } else if (Platform.isIOS) {
        // iOS的后台定位权限通过Geolocator处理
        debugPrint('🔐 PermissionService: iOS平台，后台定位权限通过Info.plist配置');
        backgroundLocationGranted = permission == LocationPermission.always;
      }

      debugPrint('✅ PermissionService: 定位权限检查完成');
      debugPrint('📍 基础定位权限: $permission');
      debugPrint('📍 后台定位权限: $backgroundLocationGranted');

      return LocationPermissionResult(
        isGranted: true,
        status: LocationPermissionStatus.granted,
        message: '定位权限已获取',
        hasBackgroundPermission: backgroundLocationGranted,
        geolocatorPermission: permission,
      );
    } catch (e) {
      debugPrint('❌ PermissionService: 权限检查失败 - $e');
      return LocationPermissionResult(
        isGranted: false,
        status: LocationPermissionStatus.error,
        message: '权限检查失败: $e',
      );
    }
  }

  /// 打开应用设置页面
  Future<bool> openAppSettings() async {
    try {
      debugPrint('🔐 PermissionService: 打开应用设置页面...');
      return await openAppSettings();
    } catch (e) {
      debugPrint('❌ PermissionService: 打开设置页面失败 - $e');
      return false;
    }
  }

  /// 检查特定权限状态
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    try {
      final status = await permission.status;
      debugPrint('🔐 PermissionService: ${permission.toString()} 权限状态: $status');
      return status;
    } catch (e) {
      debugPrint('❌ PermissionService: 检查权限状态失败 - $e');
      return PermissionStatus.denied;
    }
  }

  /// 请求特定权限
  Future<PermissionStatus> requestPermission(Permission permission) async {
    try {
      debugPrint('🔐 PermissionService: 请求权限: ${permission.toString()}');
      final status = await permission.request();
      debugPrint('🔐 PermissionService: 权限请求结果: $status');
      return status;
    } catch (e) {
      debugPrint('❌ PermissionService: 请求权限失败 - $e');
      return PermissionStatus.denied;
    }
  }
}

/// 定位权限结果
class LocationPermissionResult {
  final bool isGranted;
  final LocationPermissionStatus status;
  final String message;
  final bool hasBackgroundPermission;
  final LocationPermission? geolocatorPermission;

  LocationPermissionResult({
    required this.isGranted,
    required this.status,
    required this.message,
    this.hasBackgroundPermission = false,
    this.geolocatorPermission,
  });

  @override
  String toString() {
    return 'LocationPermissionResult{isGranted: $isGranted, status: $status, message: $message, hasBackgroundPermission: $hasBackgroundPermission, geolocatorPermission: $geolocatorPermission}';
  }
}

/// 定位权限状态
enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
  error,
}
