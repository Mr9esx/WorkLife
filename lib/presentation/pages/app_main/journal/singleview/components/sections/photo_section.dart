import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/text_styles.dart';
import 'package:WeekLife/common/constants/ui_constants.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../widgets/media/optimized_image_widget.dart';
import 'package:WeekLife/common/ui/icon/app_icon.dart';

/// 照片管理组件
/// 负责显示和管理照片列表，支持添加、删除、拖拽排序等功能
class PhotoSection extends StatefulWidget {
  /// 选中的图片列表
  final List<XFile> images;

  /// 是否处于编辑状态
  final bool isEditing;

  /// 图片变化回调
  final Function(List<XFile>) onImagesChanged;

  /// 添加照片回调
  final VoidCallback? onAddPhoto;

  /// 图片点击回调
  final Function(int)? onImageTap;

  /// 移除照片回调
  final Function(int)? onRemovePhoto;

  /// 删除模式变化回调
  final Function(bool)? onDeleteModeChanged;

  /// 外部控制的删除模式状态
  final bool? externalDeleteMode;

  const PhotoSection({
    super.key,
    required this.images,
    required this.isEditing,
    required this.onImagesChanged,
    this.onAddPhoto,
    this.onImageTap,
    this.onRemovePhoto,
    this.onDeleteModeChanged,
    this.externalDeleteMode,
  });

  @override
  State<PhotoSection> createState() => _PhotoSectionState();
}

class _PhotoSectionState extends State<PhotoSection> with TickerProviderStateMixin {
  /// 是否处于删除模式
  bool _isDeleteMode = false;

  @override
  void didUpdateWidget(PhotoSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果外部删除模式状态发生变化，更新内部状态
    if (widget.externalDeleteMode != null && widget.externalDeleteMode != _isDeleteMode) {
      setState(() {
        _isDeleteMode = widget.externalDeleteMode!;
      });
    }
  }

  @override
  void dispose() {
    if (_isDeleteMode) {
      widget.onDeleteModeChanged?.call(false);
    }
    super.dispose();
  }

  /// 构建照片项
  Widget _buildPhotoItem(int index) {
    return Container(
      key: ValueKey(widget.images[index].path),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 照片
          Positioned.fill(
            child: GestureDetector(
              onTap: () => widget.onImageTap?.call(index),
              onDoubleTap: widget.isEditing
                  ? () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _isDeleteMode = !_isDeleteMode;
                      });
                      widget.onDeleteModeChanged?.call(_isDeleteMode);
                    }
                  : null,
              child: OptimizedImageWidget(
                imageFile: widget.images[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 删除按钮
          if (_isDeleteMode)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  // 删除照片
                  setState(() {
                    final List<XFile> newImages = List.from(widget.images);
                    newImages.removeAt(index);
                    widget.onImagesChanged(newImages);
                    widget.onRemovePhoto?.call(index);

                    // 如果没有更多照片，退出删除模式
                    if (newImages.isEmpty) {
                      _isDeleteMode = false;
                      widget.onDeleteModeChanged?.call(false);
                    }
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 构建添加按钮
  Widget _buildAddButton() {
    return GestureDetector(
      key: const ValueKey('add_photo_button'),
      onTap: widget.onAddPhoto,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.grey,
            size: 28, // 稍微增大图标尺寸，让视觉效果更好
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 检查是否达到图片数量上限
    final hasReachedLimit = widget.images.length >= 9;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 内容容器
        GestureDetector(
          onTap: () {
            if (_isDeleteMode) {
              setState(() {
                _isDeleteMode = false;
              });
              widget.onDeleteModeChanged?.call(false);
            }
          },
          child: Container(
            width: double.infinity,
            color: Colors.transparent,
            child: ReorderableGridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              padding: EdgeInsets.zero,
              itemCount: widget.images.length + (widget.isEditing && !hasReachedLimit ? 1 : 0),
              onReorder: (oldIndex, newIndex) {
                // 如果是添加按钮，不允许排序
                if (!hasReachedLimit && (oldIndex == widget.images.length || newIndex == widget.images.length)) {
                  return;
                }

                // 调整newIndex，因为ReorderableGridView在计算时会考虑移动方向
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }

                // 更新顺序
                setState(() {
                  final List<XFile> newImages = List.from(widget.images);
                  final XFile item = newImages.removeAt(oldIndex);
                  newImages.insert(newIndex, item);
                  widget.onImagesChanged(newImages);
                });
              },
              dragWidgetBuilder: (index, child) {
                // 如果是添加按钮，不显示拖拽效果
                if (!hasReachedLimit && index == widget.images.length) {
                  return child;
                }
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              itemBuilder: (context, index) {
                if (!hasReachedLimit && index == widget.images.length && widget.isEditing) {
                  return _buildAddButton();
                }
                return _buildPhotoItem(index);
              },
            ),
          ),
        ),
      ],
    );
  }
}
