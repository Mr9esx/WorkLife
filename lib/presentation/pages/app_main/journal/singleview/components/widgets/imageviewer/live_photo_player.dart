import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:cross_file/cross_file.dart';
import 'package:photo_view/photo_view.dart';
import 'package:WeekLife/common/ui/icon/app_icon.dart';

/// 实况图片播放器
class LivePhotoPlayer extends StatefulWidget {
  final XFile imageFile;
  final bool autoPlay;
  final VoidCallback? onPlayStateChanged;

  const LivePhotoPlayer({
    super.key,
    required this.imageFile,
    this.autoPlay = false,
    this.onPlayStateChanged,
  });

  @override
  State<LivePhotoPlayer> createState() => _LivePhotoPlayerState();
}

class _LivePhotoPlayerState extends State<LivePhotoPlayer> with TickerProviderStateMixin {
  bool _isPlaying = false;
  Timer? _playbackTimer;
  int _currentFrameIndex = 0;
  final List<File> _frames = [];
  bool _isLoading = true;

  // 性能优化相关
  final Map<int, ui.Image> _preloadedImages = {};
  final Map<int, Completer<void>> _preloadingCompleters = {};
  late final AnimationController _frameController;
  final int _preloadAheadCount = 5; // 预加载帧数
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    // 初始化帧动画控制器
    _frameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(_onFrameChanged);

    _loadLivePhoto();
    if (widget.autoPlay) {
      _startPlayback();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _stopPlayback();
    _frameController.dispose();
    _clearCache();
    super.dispose();
  }

  /// 清理缓存
  void _clearCache() {
    for (final image in _preloadedImages.values) {
      image.dispose();
    }
    _preloadedImages.clear();
    _preloadingCompleters.clear();
  }

  /// 预加载图片
  Future<void> _preloadImages(int startIndex) async {
    if (_isDisposed) return;

    final endIndex = (startIndex + _preloadAheadCount).clamp(0, _frames.length - 1);

    for (var i = startIndex; i <= endIndex; i++) {
      if (_preloadedImages.containsKey(i) || _preloadingCompleters.containsKey(i)) {
        continue;
      }

      final completer = Completer<void>();
      _preloadingCompleters[i] = completer;

      unawaited(_loadImage(i).then((_) {
        if (!_isDisposed) {
          completer.complete();
          _preloadingCompleters.remove(i);
        }
      }));
    }
  }

  /// 加载单帧图片
  Future<void> _loadImage(int index) async {
    if (_isDisposed || _preloadedImages.containsKey(index)) return;

    try {
      final file = _frames[index];
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: MediaQuery.of(context).size.width.round(),
      );
      final frame = await codec.getNextFrame();

      if (!_isDisposed) {
        _preloadedImages[index] = frame.image;
      } else {
        frame.image.dispose();
      }
    } catch (e) {
      print('加载图片帧失败: $e');
    }
  }

  /// 帧变化处理
  void _onFrameChanged() {
    if (!mounted || _frames.isEmpty) return;

    final newIndex = (_currentFrameIndex + 1) % _frames.length;
    setState(() {
      _currentFrameIndex = newIndex;
    });

    // 预加载后续帧
    _preloadImages(newIndex);

    // 释放不需要的帧
    _releaseOldFrames(newIndex);
  }

  /// 释放旧的帧
  void _releaseOldFrames(int currentIndex) {
    final keysToRemove =
        _preloadedImages.keys.where((index) => (index - currentIndex).abs() > _preloadAheadCount).toList();

    for (final key in keysToRemove) {
      final image = _preloadedImages.remove(key);
      image?.dispose();
    }
  }

  /// 加载实况图片
  Future<void> _loadLivePhoto() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: 根据实际的实况图片格式实现帧提取
      // 这里需要根据具体的实况图片格式来实现
      // 1. 检查文件格式
      // 2. 提取视频帧或动图帧
      // 3. 将帧保存到 _frames 列表中

      if (_frames.isNotEmpty && mounted) {
        // 预加载前几帧
        await _preloadImages(0);
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('加载实况图片失败: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startPlayback() {
    if (_frames.isEmpty || _isPlaying) return;

    setState(() {
      _isPlaying = true;
    });
    widget.onPlayStateChanged?.call();

    _frameController.repeat();
  }

  void _stopPlayback() {
    if (!_isPlaying) return;

    _frameController.stop();

    if (mounted) {
      setState(() {
        _isPlaying = false;
        _currentFrameIndex = 0;
      });
      widget.onPlayStateChanged?.call();
    }
  }

  void _togglePlayback() {
    if (_isPlaying) {
      _stopPlayback();
    } else {
      _startPlayback();
    }
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        // 图片显示
        RepaintBoundary(
          child: PhotoView(
            imageProvider: _frames.isNotEmpty
                ? _FrameImageProvider(
                    frameFile: _frames[_currentFrameIndex],
                    cachedImage: _preloadedImages[_currentFrameIndex],
                  )
                : FileImage(File(widget.imageFile.path)) as ImageProvider,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.contained,
            backgroundDecoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            gaplessPlayback: true,
          ),
        ),

        // 播放控制按钮
        if (_frames.isNotEmpty)
          Positioned.fill(
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _togglePlayback,
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: AppIcon(
                        assetName: _isPlaying ? 'pause-01' : 'play-01',
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// 自定义图片提供器，支持缓存的图片帧
class _FrameImageProvider extends ImageProvider<_FrameImageProvider> {
  final File frameFile;
  final ui.Image? cachedImage;

  const _FrameImageProvider({
    required this.frameFile,
    this.cachedImage,
  });

  @override
  Future<_FrameImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<_FrameImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadBuffer(
    _FrameImageProvider key,
    DecoderBufferCallback decode,
  ) {
    return OneFrameImageStreamCompleter(_loadAsync(key));
  }

  Future<ImageInfo> _loadAsync(_FrameImageProvider key) async {
    if (cachedImage != null) {
      return ImageInfo(image: cachedImage!);
    }

    final bytes = await frameFile.readAsBytes();
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    final codec = await descriptor.instantiateCodec();
    final frameImage = await codec.getNextFrame();

    buffer.dispose();
    codec.dispose();

    return ImageInfo(image: frameImage.image);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _FrameImageProvider && other.frameFile.path == frameFile.path;
  }

  @override
  int get hashCode => frameFile.path.hashCode;
}
