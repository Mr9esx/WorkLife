import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'performance_optimizations.dart';

/// 性能监控工具
/// 用于监控内存使用、帧率、加载时间等性能指标
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  // 性能指标
  final List<double> _frameTimes = [];
  final List<int> _memoryUsages = [];
  final Map<String, int> _loadTimes = {};
  Timer? _monitorTimer;
  bool _isMonitoring = false;

  /// 开始性能监控
  void startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _frameTimes.clear();
    _memoryUsages.clear();
    _loadTimes.clear();
    
    // 每秒收集一次性能数据
    _monitorTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _collectPerformanceData();
    });
    
    debugPrint('🔍 性能监控已启动');
  }

  /// 停止性能监控
  void stopMonitoring() {
    if (!_isMonitoring) return;
    
    _isMonitoring = false;
    _monitorTimer?.cancel();
    _monitorTimer = null;
    
    debugPrint('⏹️ 性能监控已停止');
    _printPerformanceReport();
  }

  /// 收集性能数据
  void _collectPerformanceData() {
    // 收集内存使用情况
    _collectMemoryUsage();
    
    // 收集帧率信息（简化版）
    _collectFrameRate();
  }

  /// 收集内存使用情况
  void _collectMemoryUsage() {
    try {
      // 获取图片缓存使用情况
      final cacheStats = PerformanceOptimizations().getCacheStats();
      final memoryUsage = cacheStats['memoryUsage'] as int;
      _memoryUsages.add(memoryUsage);
      
      // 保持最近100个数据点
      if (_memoryUsages.length > 100) {
        _memoryUsages.removeAt(0);
      }
    } catch (e) {
      debugPrint('❌ 收集内存数据失败: $e');
    }
  }

  /// 收集帧率信息（简化版）
  void _collectFrameRate() {
    // 这里可以添加更复杂的帧率监控逻辑
    // 目前使用模拟数据
    final frameTime = DateTime.now().millisecondsSinceEpoch.toDouble();
    _frameTimes.add(frameTime);
    
    // 保持最近60个数据点（约1分钟）
    if (_frameTimes.length > 60) {
      _frameTimes.removeAt(0);
    }
  }

  /// 记录加载时间
  void recordLoadTime(String operation, int milliseconds) {
    _loadTimes[operation] = milliseconds;
    debugPrint('⏱️ $operation 耗时: ${milliseconds}ms');
  }

  /// 打印性能报告
  void _printPerformanceReport() {
    debugPrint('📊 ===== 性能报告 =====');
    
    // 内存使用报告
    if (_memoryUsages.isNotEmpty) {
      final avgMemory = _memoryUsages.reduce((a, b) => a + b) / _memoryUsages.length;
      final maxMemory = _memoryUsages.reduce((a, b) => a > b ? a : b);
      debugPrint('💾 内存使用:');
      debugPrint('  - 平均: ${_formatBytes(avgMemory.round())}');
      debugPrint('  - 峰值: ${_formatBytes(maxMemory)}');
    }
    
    // 加载时间报告
    if (_loadTimes.isNotEmpty) {
      debugPrint('⏱️ 加载时间:');
      _loadTimes.forEach((operation, time) {
        debugPrint('  - $operation: ${time}ms');
      });
    }
    
    // 缓存统计
    final cacheStats = PerformanceOptimizations().getCacheStats();
    debugPrint('🗂️ 缓存统计:');
    debugPrint('  - 缓存数量: ${cacheStats['count']}');
    debugPrint('  - 内存使用: ${cacheStats['memoryUsageFormatted']}');
    debugPrint('  - 内存限制: ${cacheStats['maxMemoryUsageFormatted']}');
    
    debugPrint('========================');
  }

  /// 获取性能统计信息
  Map<String, dynamic> getPerformanceStats() {
    final cacheStats = PerformanceOptimizations().getCacheStats();
    
    double avgMemory = 0;
    int maxMemory = 0;
    if (_memoryUsages.isNotEmpty) {
      avgMemory = _memoryUsages.reduce((a, b) => a + b) / _memoryUsages.length;
      maxMemory = _memoryUsages.reduce((a, b) => a > b ? a : b);
    }
    
    return {
      'isMonitoring': _isMonitoring,
      'memory': {
        'average': avgMemory.round(),
        'averageFormatted': _formatBytes(avgMemory.round()),
        'peak': maxMemory,
        'peakFormatted': _formatBytes(maxMemory),
        'samples': _memoryUsages.length,
      },
      'cache': cacheStats,
      'loadTimes': Map.from(_loadTimes),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  /// 清理监控数据
  void clearData() {
    _frameTimes.clear();
    _memoryUsages.clear();
    _loadTimes.clear();
    debugPrint('🧹 性能监控数据已清理');
  }
}

/// 性能监控组件
/// 可以在开发模式下显示性能信息
class PerformanceOverlay extends StatefulWidget {
  final Widget child;
  final bool showOverlay;

  const PerformanceOverlay({
    super.key,
    required this.child,
    this.showOverlay = kDebugMode,
  });

  @override
  State<PerformanceOverlay> createState() => _PerformanceOverlayState();
}

class _PerformanceOverlayState extends State<PerformanceOverlay> {
  final PerformanceMonitor _monitor = PerformanceMonitor();
  Timer? _updateTimer;
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    if (widget.showOverlay) {
      _monitor.startMonitoring();
      _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (mounted) {
          setState(() {
            _stats = _monitor.getPerformanceStats();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _monitor.stopMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showOverlay && _stats.isNotEmpty)
          Positioned(
            top: 0,
            right: 10,
            child: _buildPerformanceInfo(),
          ),
      ],
    );
  }

  Widget _buildPerformanceInfo() {
    final memory = _stats['memory'] as Map<String, dynamic>? ?? {};
    final cache = _stats['cache'] as Map<String, dynamic>? ?? {};
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '📊 性能监控',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          if (memory.isNotEmpty) ...[
            Text(
              '💾 内存: ${memory['averageFormatted']}',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            Text(
              '📈 峰值: ${memory['peakFormatted']}',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
          if (cache.isNotEmpty) ...[
            Text(
              '🗂️ 缓存: ${cache['count']}张',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            Text(
              '💽 占用: ${cache['memoryUsageFormatted']}',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ],
      ),
    );
  }
}

/// 性能优化建议工具
class PerformanceOptimizer {
  static final PerformanceOptimizer _instance = PerformanceOptimizer._internal();
  factory PerformanceOptimizer() => _instance;
  PerformanceOptimizer._internal();

  /// 分析性能并提供优化建议
  List<String> analyzeAndSuggest() {
    final suggestions = <String>[];
    final stats = PerformanceMonitor().getPerformanceStats();
    
    // 分析内存使用
    final memory = stats['memory'] as Map<String, dynamic>? ?? {};
    if (memory['peak'] != null && memory['peak'] > 50 * 1024 * 1024) { // 50MB
      suggestions.add('内存使用过高，建议清理图片缓存或减少同时加载的图片数量');
    }
    
    // 分析缓存效率
    final cache = stats['cache'] as Map<String, dynamic>? ?? {};
    if (cache['count'] != null && cache['count'] > 40) {
      suggestions.add('图片缓存数量较多，可能影响内存使用，建议调整缓存策略');
    }
    
    // 分析加载时间
    final loadTimes = stats['loadTimes'] as Map<String, dynamic>? ?? {};
    loadTimes.forEach((operation, time) {
      if (time > 1000) { // 超过1秒
        suggestions.add('$operation 加载时间过长(${time}ms)，建议优化图片大小或网络连接');
      }
    });
    
    if (suggestions.isEmpty) {
      suggestions.add('性能表现良好，无需特别优化');
    }
    
    return suggestions;
  }

  /// 自动优化性能
  void autoOptimize() {
    debugPrint('🚀 开始自动性能优化...');
    
    // 清理过期缓存
    PerformanceOptimizations().clearCache();
    
    // 清理监控数据
    PerformanceMonitor().clearData();
    
    debugPrint('✅ 自动优化完成');
  }
} 