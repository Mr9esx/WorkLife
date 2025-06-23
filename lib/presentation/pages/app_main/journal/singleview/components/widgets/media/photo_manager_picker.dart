import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:cross_file/cross_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:exif/exif.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import '../common/common_widgets.dart';

/// 选中图片信息
class SelectedImageInfo {
  final XFile xFile;
  String? assetId;

  SelectedImageInfo({
    required this.xFile,
    this.assetId,
  });

  String get name => xFile.name;
  String get path => xFile.path;
  String get id => assetId ?? path;
}

/// 基于 photo_manager 的自定义图片选择器
/// 支持显示已选中的图片状态
class PhotoManagerPicker extends StatefulWidget {
  final List<XFile> selectedImages;
  final int maxCount;
  final double? height; // 可选的高度参数
  final double? topMargin; // 可选的顶部边距参数

  const PhotoManagerPicker({
    super.key,
    required this.selectedImages,
    this.maxCount = 9,
    this.height, // 可以指定具体高度，如果不指定则使用默认的85%屏幕高度
    this.topMargin, // 可以指定距离顶部的距离，如果不指定则紧贴底部
  });

  @override
  State<PhotoManagerPicker> createState() => _PhotoManagerPickerState();
}

class _PhotoManagerPickerState extends State<PhotoManagerPicker> {
  List<AssetEntity> _assets = [];
  List<SelectedImageInfo> _selectedImageInfos = [];
  bool _isLoading = true;
  bool _isMatching = false;
  bool _isLoadingMore = false;
  bool _hasMoreAssets = true;
  String? _errorMessage;

  // 懒加载相关
  AssetPathEntity? _currentAlbum;
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 50; // 每页加载50张图片

  @override
  void initState() {
    super.initState();
    _initializeSelectedImages();
    _loadAssets();
    _setupScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 设置滚动控制器监听
  void _setupScrollController() {
    _scrollController.addListener(() {
      // 当滚动到底部80%时，开始加载更多
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
        _loadMoreAssets();
      }
    });
  }

  /// 初始化已选中的图片
  void _initializeSelectedImages() {
    print('📸 初始化已选中的图片');
    print('  已选中图片数量: ${widget.selectedImages.length}');

    _selectedImageInfos = widget.selectedImages.map((xFile) {
      print('  处理图片: ${xFile.path}');
      return SelectedImageInfo(xFile: xFile);
    }).toList();
  }

  /// 获取当前选中的XFile列表（用于返回给调用方）
  List<XFile> get _selectedImages => _selectedImageInfos.map((info) => info.xFile).toList();

  /// 获取当前选中的asset ID集合
  Set<String> get _selectedAssetIds =>
      _selectedImageInfos.where((info) => info.assetId != null).map((info) => info.assetId!).toSet();

  /// 加载相册资源（初始加载）
  Future<void> _loadAssets() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // 请求权限
      final PermissionState permission = await PhotoManager.requestPermissionExtend();
      if (!permission.isAuth && !permission.hasAccess) {
        setState(() {
          _errorMessage = '需要相册访问权限才能选择图片';
          _isLoading = false;
        });
        return;
      }

      // 获取相册列表
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );

      if (albums.isEmpty) {
        setState(() {
          _errorMessage = '没有找到相册';
          _isLoading = false;
        });
        return;
      }

      // 保存当前相册引用
      _currentAlbum = albums.first;

      // 获取第一页图片（减少初始加载数量）
      final List<AssetEntity> assets = await _currentAlbum!.getAssetListRange(
        start: 0,
        end: 20, // 减少初始加载数量到20张
      );

      if (mounted) {
        setState(() {
          _assets = assets;
          _isLoading = false;
          _hasMoreAssets = assets.length == 20; // 如果返回的数量等于页面大小，说明可能还有更多
        });

        // 只有在有已选中图片时才执行匹配
        if (_selectedImageInfos.isNotEmpty) {
          print('🔍 开始匹配已选中的图片');
          // 延迟执行匹配，让UI先显示出来
          Future.microtask(() => _matchSelectedImages());
        }

        // 如果有更多图片，延迟加载下一页
        if (_hasMoreAssets) {
          Future.microtask(() => _loadMoreAssets());
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '加载图片失败: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// 加载更多资源（懒加载）
  Future<void> _loadMoreAssets() async {
    if (_isLoadingMore || !_hasMoreAssets || _currentAlbum == null) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final int currentCount = _assets.length;
      final List<AssetEntity> moreAssets = await _currentAlbum!.getAssetListRange(
        start: currentCount,
        end: currentCount + 30, // 每次加载30张
      );

      if (mounted) {
        setState(() {
          _assets.addAll(moreAssets);
          _isLoadingMore = false;
          _hasMoreAssets = moreAssets.length == 30; // 如果返回的数量少于页面大小，说明没有更多了
        });

        print('懒加载完成，当前共有 ${_assets.length} 张图片');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
      print('懒加载失败: $e');
    }
  }

  /// 匹配已选中的图片
  Future<void> _matchSelectedImages() async {
    if (_selectedImageInfos.isEmpty || _assets.isEmpty) return;

    print('🔍 开始匹配已选中的图片');
    print('  已选中图片数量: ${_selectedImageInfos.length}');
    print('  相册资源数量: ${_assets.length}');

    setState(() {
      _isMatching = true;
    });

    try {
      // 创建一个已使用的asset ID集合
      Set<String> usedAssetIds = <String>{};

      // 为每个图片寻找匹配
      for (final imageInfo in _selectedImageInfos) {
        print('  匹配图片: ${imageInfo.path}');

        // 寻找第一个未被使用的asset
        for (final asset in _assets) {
          if (usedAssetIds.contains(asset.id)) continue;

          try {
            final file = await asset.file;
            if (file != null) {
              final assetPath = file.path;
              final imageInfoPath = imageInfo.path;

              print('    比较路径:');
              print('      Asset: $assetPath');
              print('      Selected: $imageInfoPath');

              if (assetPath == imageInfoPath || await _areImagesSame(file, File(imageInfoPath))) {
                imageInfo.assetId = asset.id;
                usedAssetIds.add(asset.id);
                print('    ✅ 找到匹配！Asset ID: ${asset.id}');
                break;
              }
            }
          } catch (e) {
            print('    ⚠️ 比较失败: $e');
            continue;
          }
        }
      }

      print('🎯 匹配完成:');
      print('  成功匹配: ${_selectedImageInfos.where((info) => info.assetId != null).length}');
      print('  未匹配: ${_selectedImageInfos.where((info) => info.assetId == null).length}');
    } catch (e) {
      print('❌ 匹配过程出错: $e');
    }

    if (mounted) {
      setState(() {
        _isMatching = false;
      });
    }
  }

  /// 比较两个图片文件是否相同
  Future<bool> _areImagesSame(File file1, File file2) async {
    try {
      if (file1.path == file2.path) return true;

      final size1 = await file1.length();
      final size2 = await file2.length();
      if (size1 != size2) return false;

      final bytes1 = await file1.readAsBytes();
      final bytes2 = await file2.readAsBytes();
      if (bytes1.length != bytes2.length) return false;

      for (var i = 0; i < bytes1.length; i++) {
        if (bytes1[i] != bytes2[i]) return false;
      }

      return true;
    } catch (e) {
      print('比较图片失败: $e');
      return false;
    }
  }

  /// 检查图片是否已选中
  bool _isImageSelected(AssetEntity asset) {
    return _selectedImageInfos.any((info) => info.assetId == asset.id);
  }

  /// 获取图片在选中列表中的索引
  int _getImageIndex(AssetEntity asset) {
    return _selectedImageInfos.indexWhere((info) => info.assetId == asset.id);
  }

  /// 切换图片选择状态
  Future<void> _toggleImageSelection(AssetEntity asset) async {
    final isCurrentlySelected = _isImageSelected(asset);

    if (isCurrentlySelected) {
      // 取消选择
      setState(() {
        _selectedImageInfos.removeWhere((info) => info.assetId == asset.id);
      });
    } else {
      // 检查是否超过最大数量
      if (_selectedImageInfos.length >= widget.maxCount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('最多只能选择${widget.maxCount}张图片')),
        );
        return;
      }

      // 添加选择
      try {
        final file = await asset.originFile; // 使用 originFile 获取原始文件
        if (file != null) {
          // 读取原始文件的字节流以保留EXIF信息
          final bytes = await file.readAsBytes();

          // 获取应用文档目录
          final appDocDir = await getApplicationDocumentsDirectory();
          final imagesDir = Directory(path.join(appDocDir.path, 'images'));
          if (!await imagesDir.exists()) {
            await imagesDir.create(recursive: true);
          }

          // 生成新的文件名和路径
          final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          final String extension = path.extension(file.path);
          final String newPath = path.join(imagesDir.path, 'IMG_$timestamp$extension');

          // 使用字节流复制以保留所有元数据
          await File(newPath).writeAsBytes(bytes);

          // 验证EXIF信息
          final originalExif = await readExifFromBytes(bytes);
          final copiedBytes = await File(newPath).readAsBytes();
          final copiedExif = await readExifFromBytes(copiedBytes);

          print('📊 EXIF信息验证:');
          print('✅ 原始EXIF标签数: ${originalExif.length}');
          print('✅ 复制后EXIF标签数: ${copiedExif.length}');

          // 检查关键EXIF标签
          final importantTags = [
            'Make',
            'Model',
            'FNumber',
            'ExposureTime',
            'ISOSpeedRatings',
            'FocalLength',
            'Flash',
            'WhiteBalance'
          ];

          print('📸 关键EXIF标签验证:');
          for (final tag in importantTags) {
            final originalValue = originalExif[tag]?.printable ?? originalExif['EXIF $tag']?.printable;
            final copiedValue = copiedExif[tag]?.printable ?? copiedExif['EXIF $tag']?.printable;
            print('  $tag: ${originalValue ?? '无'} -> ${copiedValue ?? '无'}');
          }

          final xFile = XFile(newPath);
          final imageInfo = SelectedImageInfo(
            xFile: xFile,
            assetId: asset.id,
          );

          setState(() {
            _selectedImageInfos.add(imageInfo);
          });
        }
      } catch (e) {
        print('❌ 选择图片失败: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('选择图片失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _isMatching) {
      return CommonModalContainer(
        topMargin: widget.topMargin,
        child: const SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return CommonModalContainer(
        topMargin: widget.topMargin,
        child: SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadAssets,
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_assets.isEmpty) {
      return CommonModalContainer(
        topMargin: widget.topMargin,
        child: const SizedBox(
          height: 200,
          child: Center(
            child: Text(
              '没有找到图片',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    return CommonModalContainer(
      // topMargin: widget.topMargin,
      child: Column(
        children: [
          // 图片网格
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: _assets.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                // 如果是最后一个item且正在加载更多，显示加载指示器
                if (index == _assets.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }

                final asset = _assets[index];
                final isSelected = _isImageSelected(asset);

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _toggleImageSelection(asset);
                  },
                  child: Stack(
                    children: [
                      // 图片
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: AssetEntityImage(
                              asset,
                              isOriginal: false,
                              thumbnailSize: const ThumbnailSize.square(300),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      // 选中状态覆盖层
                      if (isSelected)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                        ),

                      // 选中标记
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : AppColors.borderColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : Container(),
                        ),
                      ),

                      // 选中序号
                      if (isSelected)
                        Positioned(
                          bottom: 6,
                          right: 6,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${_getImageIndex(asset) + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // 底部按钮
          CommonBottomButtons(
            confirmText: '确定 (${_selectedImageInfos.length}/${widget.maxCount})',
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: _selectedImageInfos.isNotEmpty ? () => Navigator.of(context).pop(_selectedImages) : null,
          ),
        ],
      ),
    );
  }
}
