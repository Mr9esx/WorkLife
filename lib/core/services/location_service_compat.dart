import 'package:WeekLife/core/services/simple_permission_service.dart';
import 'package:WeekLife/core/services/location_manager.dart';
import 'package:WeekLife/core/services/geocoding_service.dart';
import 'package:WeekLife/data/models/location/location_data.dart';
import 'package:geolocator/geolocator.dart';

/// 兼容性定位服务
/// 为了兼容旧代码，提供与原LocationService相同的接口
class LocationService {
  final SimplePermissionService _permissionService = SimplePermissionService();
  final LocationManager _locationManager = LocationManager();
  final GeocodingService _geocodingService = GeocodingService();

  /// 检查定位权限
  Future<bool> checkLocationPermission() async {
    final result = await _permissionService.checkAndRequestLocationPermission();
    return result.isGranted;
  }

  /// 请求定位权限
  Future<bool> requestLocationPermission() async {
    final result = await _permissionService.checkAndRequestLocationPermission();
    return result.isGranted;
  }

  /// 检查定位服务是否开启
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// 获取当前位置
  Future<LocationData?> getCurrentLocation({
    bool useCache = true,
    bool includeAddress = false,
  }) async {
    try {
      // 检查权限
      if (!await checkLocationPermission()) {
        return null;
      }

      // 获取位置
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );

      // 获取地址信息（如果需要）
      String? address;
      if (includeAddress) {
        try {
          address = await _geocodingService.getAddressFromCoordinates(
            position.latitude,
            position.longitude,
          );
        } catch (e) {
          print('获取地址信息失败: $e');
        }
      }

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        accuracy: position.accuracy,
        timestamp: DateTime.now(),
        address: address,
      );
    } catch (e) {
      print('获取位置失败: $e');
      return null;
    }
  }

  /// 打开应用设置
  Future<void> openAppSettings() async {
    await _permissionService.openAppSettings();
  }

  /// 打开定位设置
  Future<void> openLocationSettings() async {
    // 这个方法在新的服务中没有对应的实现，使用openAppSettings代替
    await _permissionService.openAppSettings();
  }
}
