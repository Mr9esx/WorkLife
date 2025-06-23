import 'dart:io';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cross_file/cross_file.dart';

/// 图片缓存条目
class ImageCacheEntry {
  final Uint8List data;
  final int size;
  final DateTime lastAccessed;

  ImageCacheEntry({
    required this.data,
    required this.size,
    required this.lastAccessed,
  });

  ImageCacheEntry copyWithLastAccessed(DateTime time) {
    return ImageCacheEntry(
      data: data,
      size: size,
      lastAccessed: time,
    );
  }
}

/// 性能优化工具类
/// 包含图片缓存、内存管理、懒加载等功能
class PerformanceOptimizations {
  static final PerformanceOptimizations _instance = PerformanceOptimizations._internal();
  factory PerformanceOptimizations() => _instance;
  PerformanceOptimizations._internal();

  // 图片缓存 - 使用LRU策略
  final Map<String, ImageCacheEntry> _imageCache = {};
  final List<String> _cacheOrder = [];
  static const int _maxCacheSize = 50; // 最大缓存50张图片
  static const int _maxMemoryUsage = 100 * 1024 * 1024; // 100MB内存限制
  int _currentMemoryUsage = 0;

  /// 获取缓存的图片数据
  Uint8List? getCachedImage(String path) {
    final entry = _imageCache[path];
    if (entry != null) {
      // 更新访问时间
      _imageCache[path] = entry.copyWithLastAccessed(DateTime.now());
      _updateCacheOrder(path);
      return entry.data;
    }
    return null;
  }

  /// 缓存图片数据
  Future<void> cacheImage(String path, Uint8List data) async {
    final size = data.length;

    // 检查内存使用量，如果超过限制则清理缓存
    while (_currentMemoryUsage + size > _maxMemoryUsage && _cacheOrder.isNotEmpty) {
      _removeLeastRecentlyUsed();
    }

    // 如果缓存数量超过限制，移除最旧的
    while (_cacheOrder.length >= _maxCacheSize && _cacheOrder.isNotEmpty) {
      _removeLeastRecentlyUsed();
    }

    // 添加到缓存
    _imageCache[path] = ImageCacheEntry(
      data: data,
      size: size,
      lastAccessed: DateTime.now(),
    );
    _cacheOrder.add(path);
    _currentMemoryUsage += size;

    debugPrint('📸 图片已缓存: $path (${_formatBytes(size)})');
    debugPrint('💾 当前缓存: ${_cacheOrder.length}张图片, ${_formatBytes(_currentMemoryUsage)}');
  }

  /// 移除最近最少使用的缓存项
  void _removeLeastRecentlyUsed() {
    if (_cacheOrder.isEmpty) return;

    final oldestPath = _cacheOrder.removeAt(0);
    final entry = _imageCache.remove(oldestPath);
    if (entry != null) {
      _currentMemoryUsage -= entry.size;
      debugPrint('🗑️ 移除缓存: $oldestPath (${_formatBytes(entry.size)})');
    }
  }

  /// 更新缓存顺序
  void _updateCacheOrder(String path) {
    _cacheOrder.remove(path);
    _cacheOrder.add(path);
  }

  /// 清理所有缓存
  void clearCache() {
    _imageCache.clear();
    _cacheOrder.clear();
    _currentMemoryUsage = 0;
    debugPrint('🧹 已清理所有图片缓存');
  }

  /// 格式化字节数
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  /// 获取缓存统计信息
  Map<String, dynamic> getCacheStats() {
    return {
      'count': _cacheOrder.length,
      'memoryUsage': _currentMemoryUsage,
      'memoryUsageFormatted': _formatBytes(_currentMemoryUsage),
      'maxMemoryUsage': _maxMemoryUsage,
      'maxMemoryUsageFormatted': _formatBytes(_maxMemoryUsage),
    };
  }
}

/// 优化的图片组件
/// 支持懒加载、缓存、内存管理
class OptimizedImageWidget extends StatefulWidget {
  final XFile imageFile;
  final double? width;
  final double? height;
  final BoxFit fit;
  final VoidCallback? onTap;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableCache;
  final bool enableLazyLoading;

  const OptimizedImageWidget({
    super.key,
    required this.imageFile,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.onTap,
    this.placeholder,
    this.errorWidget,
    this.enableCache = true,
    this.enableLazyLoading = true,
  });

  @override
  State<OptimizedImageWidget> createState() => _OptimizedImageWidgetState();
}

class _OptimizedImageWidgetState extends State<OptimizedImageWidget> {
  final PerformanceOptimizations _optimizer = PerformanceOptimizations();
  Uint8List? _imageData;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (!widget.enableLazyLoading) {
      _loadImage();
    }
  }

  @override
  void didUpdateWidget(OptimizedImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageFile.path != widget.imageFile.path) {
      _imageData = null;
      _hasError = false;
      _errorMessage = null;
      if (!widget.enableLazyLoading) {
        _loadImage();
      }
    }
  }

  /// 加载图片
  Future<void> _loadImage() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      // 首先检查缓存
      if (widget.enableCache) {
        final cachedData = _optimizer.getCachedImage(widget.imageFile.path);
        if (cachedData != null) {
          if (mounted) {
            setState(() {
              _imageData = cachedData;
              _isLoading = false;
            });
          }
          return;
        }
      }

      // 从文件加载
      final file = File(widget.imageFile.path);
      if (!file.existsSync()) {
        throw Exception('图片文件不存在');
      }

      final bytes = await file.readAsBytes();

      // 图片压缩优化
      final compressedBytes = await _compressImageIfNeeded(bytes);

      // 缓存图片
      if (widget.enableCache) {
        await _optimizer.cacheImage(widget.imageFile.path, compressedBytes);
      }

      if (mounted) {
        setState(() {
          _imageData = compressedBytes;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ 加载图片失败: ${widget.imageFile.path}, 错误: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  /// 压缩图片（如果需要）
  Future<Uint8List> _compressImageIfNeeded(Uint8List bytes) async {
    // 如果图片小于1MB，不需要压缩
    if (bytes.length < 1024 * 1024) {
      return bytes;
    }

    try {
      // 解码图片
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      // 计算压缩后的尺寸
      final originalWidth = image.width;
      final originalHeight = image.height;
      final maxDimension = 1920; // 最大尺寸

      double scale = 1.0;
      if (originalWidth > maxDimension || originalHeight > maxDimension) {
        scale = maxDimension / (originalWidth > originalHeight ? originalWidth : originalHeight);
      }

      final newWidth = (originalWidth * scale).round();
      final newHeight = (originalHeight * scale).round();

      // 如果不需要缩放，返回原始数据
      if (scale >= 1.0) {
        return bytes;
      }

      // 创建画布并绘制缩放后的图片
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint()..filterQuality = FilterQuality.high;

      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, originalWidth.toDouble(), originalHeight.toDouble()),
        Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()),
        paint,
      );

      final picture = recorder.endRecording();
      final compressedImage = await picture.toImage(newWidth, newHeight);
      final compressedBytes = await compressedImage.toByteData(format: ui.ImageByteFormat.png);

      debugPrint('🗜️ 图片压缩: ${originalWidth}x$originalHeight -> ${newWidth}x$newHeight');
      debugPrint('📦 大小变化: ${_formatBytes(bytes.length)} -> ${_formatBytes(compressedBytes!.lengthInBytes)}');

      return compressedBytes.buffer.asUint8List();
    } catch (e) {
      debugPrint('⚠️ 图片压缩失败，使用原始图片: $e');
      return bytes;
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: widget.enableLazyLoading ? _buildLazyLoadingWidget() : _buildImageWidget(),
      ),
    );
  }

  /// 构建懒加载组件
  Widget _buildLazyLoadingWidget() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 使用 Visibility 检测组件是否在视口中
        return VisibilityDetector(
          key: Key(widget.imageFile.path),
          onVisibilityChanged: (info) {
            if (info.visibleFraction > 0 && _imageData == null && !_isLoading && !_hasError) {
              _loadImage();
            }
          },
          child: _buildImageWidget(),
        );
      },
    );
  }

  /// 构建图片组件
  Widget _buildImageWidget() {
    if (_hasError) {
      return widget.errorWidget ?? _buildErrorWidget();
    }

    if (_imageData == null) {
      return widget.placeholder ?? _buildPlaceholderWidget();
    }

    return Image.memory(
      _imageData!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) {
        return widget.errorWidget ?? _buildErrorWidget();
      },
    );
  }

  /// 构建占位符组件
  Widget _buildPlaceholderWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[200],
      child: _isLoading
          ? const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : const Center(
              child: Icon(
                Icons.image,
                color: Colors.grey,
                size: 32,
              ),
            ),
    );
  }

  /// 构建错误组件
  Widget _buildErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 32,
          ),
          const SizedBox(height: 4),
          Text(
            '加载失败',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// 可见性检测器（简化版）
class VisibilityDetector extends StatefulWidget {
  @override
  final Key key;
  final Widget child;
  final Function(VisibilityInfo) onVisibilityChanged;

  const VisibilityDetector({
    required this.key,
    required this.child,
    required this.onVisibilityChanged,
  }) : super(key: key);

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    // 简化的可见性检测，实际项目中可以使用更精确的实现
    widget.onVisibilityChanged(VisibilityInfo(visibleFraction: 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// 可见性信息
class VisibilityInfo {
  final double visibleFraction;

  VisibilityInfo({required this.visibleFraction});
}

/// 内存管理工具
class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  /// 清理内存
  void clearMemory() {
    // 清理图片缓存
    PerformanceOptimizations().clearCache();

    debugPrint('🧹 内存清理完成');
  }

  /// 获取内存使用情况
  Map<String, dynamic> getMemoryStats() {
    final cacheStats = PerformanceOptimizations().getCacheStats();
    return {
      'imageCache': cacheStats,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
