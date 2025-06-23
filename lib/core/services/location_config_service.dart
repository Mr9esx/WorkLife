import 'package:shared_preferences/shared_preferences.dart';

/// 定位配置服务
/// 管理定位相关的配置参数
class LocationConfigService {
  static const String _keyLocationInterval = 'location_interval_minutes';
  static const String _keyMinDistanceThreshold = 'min_distance_threshold_meters';

  // 默认配置值
  static const int _defaultIntervalMinutes = 15;
  static const double _defaultMinDistanceThreshold = 50.0; // 50米

  /// 获取定位间隔（分钟）
  static Future<int> getLocationIntervalMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyLocationInterval) ?? _defaultIntervalMinutes;
  }

  /// 设置定位间隔（分钟）
  static Future<void> setLocationIntervalMinutes(int minutes) async {
    if (minutes < 1 || minutes > 1440) {
      // 1分钟到24小时
      throw ArgumentError('定位间隔必须在1-1440分钟之间');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLocationInterval, minutes);
  }

  /// 获取最小距离阈值（米）
  /// 只有当新定位与上次定位的距离大于此阈值时才记录
  static Future<double> getMinDistanceThreshold() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyMinDistanceThreshold) ?? _defaultMinDistanceThreshold;
  }

  /// 设置最小距离阈值（米）
  static Future<void> setMinDistanceThreshold(double meters) async {
    if (meters < 0 || meters > 10000) {
      // 0米到10公里
      throw ArgumentError('最小距离阈值必须在0-10000米之间');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyMinDistanceThreshold, meters);
  }

  /// 获取可选的间隔选项（分钟）
  static List<int> getIntervalOptions() {
    return [1, 5, 10, 15, 30, 60, 120, 180, 360, 720, 1440]; // 1分钟到24小时
  }

  /// 获取间隔选项的显示文本
  static String getIntervalDisplayText(int minutes) {
    if (minutes < 60) {
      return '$minutes分钟';
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours小时';
      } else {
        return '$hours小时$remainingMinutes分钟';
      }
    } else {
      final days = minutes ~/ 1440;
      return '$days天';
    }
  }

  /// 获取距离阈值选项（米）
  static List<double> getDistanceThresholdOptions() {
    return [0, 10, 20, 50, 100, 200, 500, 1000]; // 0米到1公里
  }

  /// 获取距离阈值的显示文本
  static String getDistanceThresholdDisplayText(double meters) {
    if (meters == 0) {
      return '不限制';
    } else if (meters < 1000) {
      return '${meters.toInt()}米';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)}公里';
    }
  }

  /// 重置所有配置为默认值
  static Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLocationInterval);
    await prefs.remove(_keyMinDistanceThreshold);
  }
}
