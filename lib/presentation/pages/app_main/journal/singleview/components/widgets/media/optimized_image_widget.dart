import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import '../../utils/performance_optimizations.dart';

/// 优化的图片组件
/// 支持缓存、懒加载、自动压缩等性能优化功能
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
  final int? cacheWidth;
  final int? cacheHeight;
  final FilterQuality filterQuality;

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
    this.enableLazyLoading = false,
    this.cacheWidth,
    this.cacheHeight,
    this.filterQuality = FilterQuality.medium,
  });

  @override
  State<OptimizedImageWidget> createState() => _OptimizedImageWidgetState();
}

class _OptimizedImageWidgetState extends State<OptimizedImageWidget> {
  final PerformanceOptimizations _optimizer = PerformanceOptimizations();
  Uint8List? _imageData;
  bool _isLoading = false;
  bool _hasError = false;
  bool _isVisible = false;

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
          _isLoading = false;
        });
      }
    }
  }

  /// 直接使用原图（不压缩）
  Future<Uint8List> _compressImageIfNeeded(Uint8List bytes) async {
    debugPrint('📸 直接使用原图，保留完整EXIF信息');
    debugPrint('📊 文件大小: ${_formatBytes(bytes.length)}');
    return bytes;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  /// 处理可见性变化
  void _onVisibilityChanged(bool isVisible) {
    if (isVisible && !_isVisible && widget.enableLazyLoading) {
      _isVisible = true;
      if (_imageData == null && !_isLoading && !_hasError) {
        _loadImage();
      }
    }
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
        // 简化的可见性检测
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _onVisibilityChanged(true);
          }
        });
        return _buildImageWidget();
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
      cacheWidth: widget.cacheWidth,
      cacheHeight: widget.cacheHeight,
      filterQuality: widget.filterQuality,
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

  @override
  void dispose() {
    // 组件销毁时不需要特殊清理，因为使用的是全局缓存
    super.dispose();
  }
}
