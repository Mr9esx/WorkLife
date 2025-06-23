import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// iOS Widget 通信服务
/// 负责与iOS Widget Extension进行数据交换
class IOSWidgetChannel {
  static const MethodChannel _channel = MethodChannel('ios_widget_location');

  /// 获取Widget收集的定位数据
  static Future<List<Map<String, dynamic>>> getWidgetLocations() async {
    try {
      debugPrint('📱 IOSWidgetChannel: 开始获取Widget定位数据...');

      final result = await _channel.invokeMethod('getWidgetLocations');

      if (result == null) {
        debugPrint('📱 IOSWidgetChannel: Widget返回空数据');
        return [];
      }

      final locations = List<Map<String, dynamic>>.from(result.map((item) => Map<String, dynamic>.from(item)));
      debugPrint('📱 IOSWidgetChannel: 获取到${locations.length}条Widget定位记录');

      return locations;
    } catch (e) {
      debugPrint('❌ IOSWidgetChannel: 获取Widget定位数据失败 - $e');
      return [];
    }
  }

  /// 清理Widget收集的定位数据
  static Future<void> clearWidgetLocations() async {
    try {
      debugPrint('📱 IOSWidgetChannel: 开始清理Widget定位数据...');

      await _channel.invokeMethod('clearWidgetLocations');

      debugPrint('✅ IOSWidgetChannel: Widget定位数据清理完成');
    } catch (e) {
      debugPrint('❌ IOSWidgetChannel: 清理Widget定位数据失败 - $e');
    }
  }

  /// 检查是否为iOS平台
  static bool get isIOSPlatform {
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// 获取Widget定位统计信息
  static Future<WidgetLocationStats> getWidgetLocationStats() async {
    try {
      final locations = await getWidgetLocations();

      if (locations.isEmpty) {
        return WidgetLocationStats(
          totalCount: 0,
          oldestTimestamp: null,
          newestTimestamp: null,
          averageAccuracy: 0,
        );
      }

      // 计算统计信息
      final timestamps = locations
          .map((loc) => (loc['timestamp'] as num?)?.toDouble())
          .where((ts) => ts != null)
          .cast<double>()
          .toList();

      final accuracies = locations
          .map((loc) => (loc['accuracy'] as num?)?.toDouble())
          .where((acc) => acc != null && acc > 0)
          .cast<double>()
          .toList();

      timestamps.sort();

      return WidgetLocationStats(
        totalCount: locations.length,
        oldestTimestamp: timestamps.isNotEmpty ? timestamps.first : null,
        newestTimestamp: timestamps.isNotEmpty ? timestamps.last : null,
        averageAccuracy: accuracies.isNotEmpty ? accuracies.reduce((a, b) => a + b) / accuracies.length : 0,
      );
    } catch (e) {
      debugPrint('❌ IOSWidgetChannel: 获取Widget统计信息失败 - $e');
      return WidgetLocationStats(
        totalCount: 0,
        oldestTimestamp: null,
        newestTimestamp: null,
        averageAccuracy: 0,
      );
    }
  }
}

/// Widget定位统计信息
class WidgetLocationStats {
  final int totalCount;
  final double? oldestTimestamp;
  final double? newestTimestamp;
  final double averageAccuracy;

  WidgetLocationStats({
    required this.totalCount,
    required this.oldestTimestamp,
    required this.newestTimestamp,
    required this.averageAccuracy,
  });

  /// 获取时间跨度（小时）
  double? get timeSpanHours {
    if (oldestTimestamp == null || newestTimestamp == null) return null;
    return (newestTimestamp! - oldestTimestamp!) / 3600;
  }

  /// 获取最新记录的年龄（分钟）
  double? get latestRecordAgeMinutes {
    if (newestTimestamp == null) return null;
    final now = DateTime.now().millisecondsSinceEpoch / 1000;
    return (now - newestTimestamp!) / 60;
  }

  @override
  String toString() {
    return 'WidgetLocationStats{'
        'totalCount: $totalCount, '
        'timeSpanHours: ${timeSpanHours?.toStringAsFixed(1)}, '
        'averageAccuracy: ${averageAccuracy.toStringAsFixed(1)}m, '
        'latestRecordAge: ${latestRecordAgeMinutes?.toStringAsFixed(1)}min'
        '}';
  }
}
