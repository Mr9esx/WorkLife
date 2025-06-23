import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cross_file/cross_file.dart';
import 'package:exif/exif.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:path/path.dart' as path;
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/icon/app_icon.dart';
import './live_photo_player.dart';

/// 图片信息模型
class ImageInfo {
  final String name;
  final String size;
  final String format;
  final DateTime? dateTime;
  final String? location;
  final bool isLive;
  final int width;
  final int height;

  // EXIF信息
  final String? cameraMake; // 相机制造商
  final String? cameraModel; // 相机型号
  final String? iso; // ISO感光度
  final String? aperture; // 光圈值
  final String? shutterSpeed; // 快门速度
  final String? focalLength; // 焦距
  final String? flash; // 闪光灯
  final String? whiteBalance; // 白平衡
  final double? latitude; // 纬度
  final double? longitude; // 经度
  final double? altitude; // 海拔
  final String? orientation; // 方向

  ImageInfo({
    required this.name,
    required this.size,
    required this.format,
    this.dateTime,
    this.location,
    this.isLive = false,
    this.width = 0,
    this.height = 0,
    this.cameraMake,
    this.cameraModel,
    this.iso,
    this.aperture,
    this.shutterSpeed,
    this.focalLength,
    this.flash,
    this.whiteBalance,
    this.latitude,
    this.longitude,
    this.altitude,
    this.orientation,
  });
}

/// 图片浏览器
class ImageViewer extends StatefulWidget {
  final List<XFile> images;
  final int initialIndex;
  final Function(int)? onPageChanged;
  final VoidCallback? onClose;

  const ImageViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.onPageChanged,
    this.onClose,
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> with TickerProviderStateMixin {
  late PageController _pageController;
  late int _currentIndex;

  // 图片信息相关
  final Map<int, ImageInfo> _imageInfos = {};

  // 动画控制器（保留以防后续需要）
  late AnimationController _colorAnimationController;

  // UI状态
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.8, // 设置视口比例，让左右图片可见
    );

    // 初始化颜色动画控制器（保留以防后续需要）
    _colorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // 设置状态栏样式
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    // 在下一帧立即开始加载当前图片及其相邻图片的信息
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🚀 开始加载图片信息');
      _preloadImages(_currentIndex);
    });
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    _pageController.dispose();

    // 恢复状态栏样式
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    super.dispose();
  }

  /// 预加载图片
  void _preloadImages(int currentIndex) async {
    print('🔄 预加载图片，当前索引: $currentIndex');

    // 加载当前图片
    _loadImageData(currentIndex);

    // 预加载前一张图片
    if (currentIndex > 0) {
      _loadImageData(currentIndex - 1);
    }

    // 预加载后一张图片
    if (currentIndex < widget.images.length - 1) {
      _loadImageData(currentIndex + 1);
    }
  }

  /// 加载图片数据（仅信息，不需要颜色）
  Future<void> _loadImageData(int index) async {
    if (index < 0 || index >= widget.images.length) return;
    if (_imageInfos.containsKey(index)) return; // 如果已经加载过，直接返回

    try {
      // 只加载图片信息
      await _loadImageInfo(index);
    } catch (e) {
      print('加载图片数据失败: $e');
    }
  }

  /// 加载图片信息
  Future<void> _loadImageInfo(int index) async {
    print('🔄 开始加载图片信息，索引: $index');

    final image = widget.images[index];
    final file = File(image.path);

    if (!file.existsSync()) {
      print('❌ 文件不存在: ${image.path}');
      return;
    }

    try {
      final stat = await file.stat();
      final bytes = await file.readAsBytes();

      print('📸 处理原图: ${path.basename(image.path)}');
      print('📊 文件大小: ${(bytes.length / 1024 / 1024).toStringAsFixed(2)}MB');

      // 获取图片尺寸
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final imageSize = frame.image;

      // 提取EXIF信息（直接从原图读取）
      Map<String, IfdTag>? exifData;
      String? cameraMake, cameraModel, iso, aperture, shutterSpeed, focalLength;
      String? flash, whiteBalance, orientation;
      double? latitude, longitude, altitude;
      DateTime? captureDateTime;

      try {
        exifData = await readExifFromBytes(bytes);
        print('✅ 从原图读取到 ${exifData.length} 个EXIF标签');

        if (exifData.isNotEmpty) {
          // 打印所有EXIF标签以便调试
          print('=== 原图EXIF信息 ===');
          exifData.forEach((key, value) {
            print('$key: ${value.printable}');
          });
          print('==================');

          // 基本相机信息
          cameraMake = exifData['Image Make']?.printable ?? exifData['Make']?.printable;
          cameraModel = exifData['Image Model']?.printable ?? exifData['Model']?.printable;

          // 拍摄参数 - 尝试多种可能的标签名
          iso = exifData['EXIF ISOSpeedRatings']?.printable ??
              exifData['EXIF PhotographicSensitivity']?.printable ??
              exifData['ISO']?.printable ??
              exifData['ISOSpeedRatings']?.printable;

          // 光圈值处理
          final apertureTag = exifData['EXIF FNumber'] ??
              exifData['FNumber'] ??
              exifData['EXIF ApertureValue'] ??
              exifData['ApertureValue'] ??
              exifData['EXIF MaxApertureValue'] ??
              exifData['MaxApertureValue'];
          if (apertureTag != null) {
            try {
              final apertureValue = apertureTag.printable;
              if (apertureValue.contains('/')) {
                final parts = apertureValue.split('/');
                if (parts.length == 2) {
                  final numerator = double.parse(parts[0]);
                  final denominator = double.parse(parts[1]);
                  final result = numerator / denominator;
                  aperture = 'f/${result.toStringAsFixed(1)}';
                } else {
                  aperture = 'f/$apertureValue';
                }
              } else {
                aperture = 'f/$apertureValue';
              }
            } catch (e) {
              print('⚠️ 解析光圈值失败: $e');
              aperture = 'f/${apertureTag.printable}';
            }
          }

          // 快门速度处理
          final shutterTag = exifData['EXIF ExposureTime'] ??
              exifData['ExposureTime'] ??
              exifData['EXIF ShutterSpeedValue'] ??
              exifData['ShutterSpeedValue'];
          if (shutterTag != null) {
            try {
              final shutterValue = shutterTag.printable;
              if (shutterValue.contains('/')) {
                final parts = shutterValue.split('/');
                if (parts.length == 2) {
                  final numerator = double.parse(parts[0]);
                  final denominator = double.parse(parts[1]);
                  if (numerator == 1) {
                    shutterSpeed = '1/${denominator}s';
                  } else {
                    shutterSpeed = '$numerator/${denominator}s';
                  }
                } else {
                  shutterSpeed = '${shutterValue}s';
                }
              } else {
                shutterSpeed = '${shutterValue}s';
              }
            } catch (e) {
              print('⚠️ 解析快门速度失败: $e');
              shutterSpeed = '${shutterTag.printable}s';
            }
          }

          // 焦距处理
          final focalTag = exifData['EXIF FocalLength'] ??
              exifData['FocalLength'] ??
              exifData['EXIF FocalLengthIn35mmFilm'] ??
              exifData['FocalLengthIn35mmFilm'];
          if (focalTag != null) {
            try {
              final focalValue = focalTag.printable;
              final cleanValue = focalValue.replaceAll(RegExp(r'[^\d./]'), '');
              if (cleanValue.contains('/')) {
                final parts = cleanValue.split('/');
                if (parts.length == 2) {
                  final numerator = double.parse(parts[0]);
                  final denominator = double.parse(parts[1]);
                  final result = numerator / denominator;
                  focalLength = '${result.toStringAsFixed(0)}mm';
                } else {
                  focalLength = '${cleanValue}mm';
                }
              } else {
                focalLength = '${cleanValue}mm';
              }
            } catch (e) {
              print('⚠️ 解析焦距失败: $e');
              focalLength = '${focalTag.printable}mm';
            }
          }

          // 其他EXIF信息
          flash = exifData['EXIF Flash']?.printable ?? exifData['Flash']?.printable;
          whiteBalance = exifData['EXIF WhiteBalance']?.printable ?? exifData['WhiteBalance']?.printable;
          orientation = exifData['Image Orientation']?.printable ?? exifData['Orientation']?.printable;

          // 拍摄时间
          final dateTimeTag = exifData['EXIF DateTimeOriginal'] ?? exifData['Image DateTime'];
          if (dateTimeTag != null) {
            try {
              final dateTimeStr = dateTimeTag.printable;
              final formattedStr = dateTimeStr.replaceFirst(':', '-').replaceFirst(':', '-');
              captureDateTime = DateTime.parse(formattedStr);
            } catch (e) {
              print('⚠️ 解析拍摄时间失败: $e');
            }
          }

          // GPS信息
          final gpsLat = exifData['GPS GPSLatitude'];
          final gpsLatRef = exifData['GPS GPSLatitudeRef'];
          final gpsLon = exifData['GPS GPSLongitude'];
          final gpsLonRef = exifData['GPS GPSLongitudeRef'];
          final gpsAlt = exifData['GPS GPSAltitude'];

          if (gpsLat != null && gpsLon != null) {
            try {
              latitude = _parseGPSCoordinate(gpsLat.printable, gpsLatRef?.printable);
              longitude = _parseGPSCoordinate(gpsLon.printable, gpsLonRef?.printable);

              if (gpsAlt != null) {
                altitude = double.tryParse(gpsAlt.printable.split(' ')[0]);
              }
            } catch (e) {
              print('⚠️ 解析GPS信息失败: $e');
            }
          }

          // 打印所有EXIF标签以便调试
          print('=== EXIF信息详细日志 ===');
          exifData.forEach((key, value) {
            print('$key: ${value.printable} (类型: ${value.tagType})');
          });
          print('=====================');
        } else {
          print('ℹ️ 原图没有EXIF信息');
        }
      } catch (e) {
        print('⚠️ 读取原图EXIF信息失败: $e');
      }

      final info = ImageInfo(
        name: path.basename(image.path),
        size: _formatFileSize(stat.size),
        format: path.extension(image.path).toUpperCase().replaceFirst('.', ''),
        dateTime: captureDateTime ?? stat.modified,
        isLive: false,
        width: imageSize.width,
        height: imageSize.height,
        cameraMake: cameraMake,
        cameraModel: cameraModel,
        iso: iso,
        aperture: aperture,
        shutterSpeed: shutterSpeed,
        focalLength: focalLength,
        flash: flash,
        whiteBalance: whiteBalance,
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
        orientation: orientation,
        location: latitude != null && longitude != null
            ? '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}'
            : null,
      );

      _imageInfos[index] = info;

      // 更新UI显示新的图片信息
      if (mounted) {
        setState(() {});
      }

      print('✅ 原图信息加载完成: ${info.name}');
      print('📷 相机: ${info.cameraMake} ${info.cameraModel}');
      print('⚙️ 参数: ${info.aperture} ${info.shutterSpeed} ISO${info.iso} ${info.focalLength}');
    } catch (e) {
      print('❌ 加载原图信息失败: $e');
    }
  }

  /// 解析GPS坐标
  double? _parseGPSCoordinate(String coordinate, String? reference) {
    try {
      // GPS坐标格式通常是 "[度, 分, 秒]"
      final parts = coordinate.replaceAll('[', '').replaceAll(']', '').split(', ');
      if (parts.length >= 3) {
        final degrees = double.parse(parts[0]);
        final minutes = double.parse(parts[1]);
        final seconds = double.parse(parts[2]);

        double result = degrees + (minutes / 60) + (seconds / 3600);

        // 根据参考方向调整符号
        if (reference == 'S' || reference == 'W') {
          result = -result;
        }

        return result;
      }
    } catch (e) {
      print('解析GPS坐标失败: $e');
    }
    return null;
  }

  /// 格式化文件大小
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '未知时间';

    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日（第${_getWeekOfYear(dateTime)}周）';
  }

  /// 获取一年中的第几周
  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil();
  }

  /// 进入全屏预览模式
  void _enterFullScreenMode() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => _FullScreenImageViewer(
          images: widget.images,
          initialIndex: _currentIndex,
          imageInfos: _imageInfos,
        ),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  /// 页面切换处理
  void _onPageChanged(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    // 触发触觉反馈
    HapticFeedback.selectionClick();

    // 通知外部
    widget.onPageChanged?.call(index);

    // 预加载相邻图片
    _preloadImages(index);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top; // 获取顶部安全区域高度

    // 按指定规则计算图片尺寸
    final imagePreviewHeight = screenHeight * 0.618; // 图片高度为屏幕55%

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: Column(
        children: [
          // 图片预览模块
          SizedBox(
            height: imagePreviewHeight,
            child: Stack(
              children: [
                // 添加顶部安全区域间距
                Positioned(
                  top: safeAreaTop - 32,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: widget.images.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(left: 8, right: 8, top: 32),
                        child: AnimatedScale(
                          scale: 1.0, // 所有图片保持相同大小
                          duration: const Duration(milliseconds: 300),
                          child: AnimatedOpacity(
                            opacity: 1.0, // 所有图片保持相同透明度
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x555F5F5F),
                                    blurRadius: 16,
                                    offset: Offset(0, 0),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: GestureDetector(
                                  onTap: () {
                                    // 如果不是当前图片，切换到该图片
                                    if (index != _currentIndex) {
                                      HapticFeedback.selectionClick();
                                      _pageController.animateToPage(
                                        index,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      // 图片 - 不压缩比例，铺满显示
                                      Image.file(
                                        File(widget.images[index].path),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  AppIcon(
                                                    assetName: 'x-02',
                                                    size: 48,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text(
                                                    '图片加载失败',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 底部渐变色区域（覆盖整个图片展示区域）
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: const [0.0, 0.4, 1.0],
                          colors: [
                            const Color(0xFFF4F4F4), // 底部100%不透明
                            const Color(0xFFF4F4F4), // 60%位置仍然100%不透明
                            const Color(0xFFF4F4F4).withOpacity(0.0), // 顶部100%透明
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // 图片基础信息区域（位于渐变区域内）
                Positioned(
                  bottom: 0,
                  left: 16,
                  right: 16,
                  child: IgnorePointer(
                    child: _buildOverlayBasicInfo(),
                  ),
                ),
              ],
            ),
          ),

          // 信息区域
          Expanded(
            child: Container(
              width: double.infinity,
              color: AppColors.appBackground,
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 固定的标签行
                  _buildFixedTagsRow(),

                  const SizedBox(height: 24),

                  // 图片详细信息区域（可滑动）
                  Expanded(
                    child: _buildScrollableDetailInfo(),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  /// 构建固定的标签行
  Widget _buildFixedTagsRow() {
    final imageInfo = _imageInfos[_currentIndex];

    if (imageInfo == null) return const SizedBox.shrink();

    // 构建标签列表
    List<Widget> tags = [];

    // 格式标签（必有）
    tags.add(_buildTag(imageInfo.format, AppColors.primary));

    // 实况标签
    if (imageInfo.isLive) {
      tags.add(_buildTag('实况', AppColors.primary));
    }

    // 拍摄参数标签（按优先级排序）
    if (imageInfo.aperture != null && imageInfo.aperture!.isNotEmpty) {
      tags.add(_buildTag(imageInfo.aperture!, AppColors.primary));
    }
    if (imageInfo.shutterSpeed != null && imageInfo.shutterSpeed!.isNotEmpty) {
      tags.add(_buildTag(imageInfo.shutterSpeed!, AppColors.primary));
    }
    if (imageInfo.iso != null && imageInfo.iso!.isNotEmpty) {
      tags.add(_buildTag('ISO${imageInfo.iso}', AppColors.primary));
    }
    if (imageInfo.focalLength != null && imageInfo.focalLength!.isNotEmpty) {
      tags.add(_buildTag(imageInfo.focalLength!, AppColors.primary));
    }

    // 如果有GPS信息，显示位置标签
    if (imageInfo.location != null) {
      tags.add(_buildTag('GPS', AppColors.primary));
    }

    // 白平衡标签（如果有具体信息）
    if (imageInfo.whiteBalance != null && imageInfo.whiteBalance!.isNotEmpty && imageInfo.whiteBalance != 'Unknown') {
      tags.add(_buildTag('WB', AppColors.primary));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags,
    );
  }

  /// 构建单个标签
  Widget _buildTag(String text, Color color) {
    return Container(
      height: 20,
      padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          fontFamily: 'MiSans',
          height: 1,
        ),
      ),
    );
  }

  /// 构建可滑动的详细信息区域
  Widget _buildScrollableDetailInfo() {
    final imageInfo = _imageInfos[_currentIndex];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 详细信息内容
          if (imageInfo != null) ...[
            _buildInfoRow('文件大小', imageInfo.size),
            const SizedBox(height: 12),
            _buildInfoRow('图片尺寸', '${imageInfo.width} × ${imageInfo.height}'),
            const SizedBox(height: 12),
            _buildInfoRow('文件格式', imageInfo.format),

            // 相机信息
            if (imageInfo.cameraMake != null || imageInfo.cameraModel != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow('拍摄设备', '${imageInfo.cameraMake ?? ''} ${imageInfo.cameraModel ?? ''}'.trim()),
            ],

            // 拍摄参数
            if (imageInfo.iso != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow('ISO感光度', imageInfo.iso!),
            ],
            if (imageInfo.aperture != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow('光圈值', imageInfo.aperture!),
            ],
            if (imageInfo.shutterSpeed != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow('快门速度', imageInfo.shutterSpeed!),
            ],
            if (imageInfo.focalLength != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow('焦距', imageInfo.focalLength!),
            ],
            if (imageInfo.flash != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow('闪光灯', imageInfo.flash!),
            ],
            if (imageInfo.whiteBalance != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow('白平衡', imageInfo.whiteBalance!),
            ],
            if (imageInfo.orientation != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow('方向', imageInfo.orientation!),
            ],

            // GPS信息
            if (imageInfo.location != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow('拍摄位置', imageInfo.location!),
            ],
            if (imageInfo.altitude != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow('海拔高度', '${imageInfo.altitude!.toStringAsFixed(1)}m'),
            ],
          ] else ...[
            const Center(
              child: Text(
                '正在加载图片信息...',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 14,
                  fontFamily: 'MiSans',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 14,
              fontFamily: 'MiSans',
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'MiSans',
            ),
          ),
        ),
      ],
    );
  }

  /// 构建覆盖在渐变区域上的基础信息区域
  Widget _buildOverlayBasicInfo() {
    final imageInfo = _imageInfos[_currentIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // IMAGE NAME
        Text(
          imageInfo?.name ?? 'IMAGE NAME',
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'MiSans',
          ),
        ),

        const SizedBox(height: 8),

        // 拍摄时间
        Text(
          '拍摄于 ${_formatDateTime(imageInfo?.dateTime)}',
          style: const TextStyle(
            color: AppColors.secondary,
            fontSize: 14,
            fontFamily: 'MiSans',
          ),
        ),
      ],
    );
  }

  /// 构建底部操作栏
  Widget _buildBottomBar() {
    return Container(
      height: 68 + MediaQuery.of(context).padding.bottom, // 手动添加底部安全区域
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom, // 手动添加底部安全区域
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 返回按钮
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                widget.onClose?.call();
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 60,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const AppIcon(
                  assetName: 'arrow-left',
                  size: 24,
                  color: AppColors.cardBackground,
                ),
              ),
            ),
          ),
          // 页面指示器
          Expanded(
            child: Container(
              height: 68, // 与底部操作栏高度一致
              padding: const EdgeInsets.only(bottom: 16),
              alignment: Alignment.center,
              child: Text(
                '${_currentIndex + 1} / ${widget.images.length}',
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontSize: 14,
                  fontFamily: 'MiSans',
                ),
              ),
            ),
          ),

          // 放大按钮
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                _enterFullScreenMode();
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const AppIcon(
                  assetName: 'arrow-expand-04',
                  size: 24,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 全屏图片查看器
class _FullScreenImageViewer extends StatefulWidget {
  final List<XFile> images;
  final int initialIndex;
  final Map<int, ImageInfo> imageInfos;

  const _FullScreenImageViewer({
    required this.images,
    required this.initialIndex,
    required this.imageInfos,
  });

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  late int _currentIndex;
  late PageController _pageController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    // 设置全屏状态栏
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    // 恢复状态栏样式
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    super.dispose();
  }

  void _onPlayStateChanged() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentImageInfo = widget.imageInfos[_currentIndex];
    final isLivePhoto = currentImageInfo?.isLive == true;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 全屏图片浏览
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              final isCurrentLive = widget.imageInfos[index]?.isLive == true;

              if (isCurrentLive) {
                return PhotoViewGalleryPageOptions.customChild(
                  child: LivePhotoPlayer(
                    imageFile: widget.images[index],
                    onPlayStateChanged: _onPlayStateChanged,
                  ),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2.0,
                  initialScale: PhotoViewComputedScale.contained,
                  heroAttributes: PhotoViewHeroAttributes(tag: widget.images[index].path),
                );
              }

              return PhotoViewGalleryPageOptions(
                imageProvider: FileImage(File(widget.images[index].path)),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2.0,
                heroAttributes: PhotoViewHeroAttributes(tag: widget.images[index].path),
              );
            },
            itemCount: widget.images.length,
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageController: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _isPlaying = false;
              });
              HapticFeedback.selectionClick();
            },
          ),

          // 页面指示器（顶部中间）
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_currentIndex + 1} / ${widget.images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'MiSans',
                      ),
                    ),
                    if (isLivePhoto) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '实况',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'MiSans',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // 关闭按钮（右下角）
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: AppIcon(
                      assetName: 'x-02',
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
