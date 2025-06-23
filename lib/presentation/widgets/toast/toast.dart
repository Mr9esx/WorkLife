import 'dart:async';

import 'package:flutter/material.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/size_styles.dart';
import 'package:WeekLife/common/ui/icon/app_icon.dart';

enum ToastType {
  warning,  // 警告样式
  success,  // 成功样式
  error,    // 错误样式
  info,     // 信息样式
}

/// Toast 显示位置
enum ToastPosition {
  top,    // 顶部
  bottom, // 底部
}

class Toast extends StatefulWidget {
  final String title;
  final String? message;
  final ToastType type;
  final VoidCallback? onClose;
  final Offset? offset;
  final bool? showIcon;

  const Toast({
    super.key,
    required this.title,
    this.message,
    this.type = ToastType.warning,
    this.onClose,
    this.offset,
    this.showIcon = true,
  });

  @override
  State<Toast> createState() => _ToastState();
}

class _ToastState extends State<Toast> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> dismiss() async {
    await _controller.reverse();
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    final safeWidth = GlobalSize().getFullWidth(context);

    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        width: safeWidth,
        padding: EdgeInsets.all(GlobalSize.primaryPadding),
        decoration: ShapeDecoration(
          color: _getBackgroundColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: [Shadows.softShadow, Shadows.defaultShadow],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIcon(),
            if (widget.showIcon == true) const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (widget.message != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.message!,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                        letterSpacing: 0.12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (widget.onClose != null) ...[
              const SizedBox(width: 16),
              GestureDetector(
                onTap: dismiss,
                child: AppIcon(
                  assetName: 'close_副本',
                  color: AppColors.primary,
                  size: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.showIcon == false) {
      return const SizedBox.shrink();
    }

    switch (widget.type) {
      case ToastType.warning:
        return AppIcon(assetName: 'triangle', color: _getIconColor());
      case ToastType.success:
        return AppIcon(assetName: 'circle', color: _getIconColor());
      case ToastType.error:
        return AppIcon(assetName: 'octagon', color: _getIconColor());
      case ToastType.info:
        return AppIcon(assetName: 'hexagon', color: _getIconColor());
    }
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case ToastType.warning:
        return const Color(0xFFFFF4E4);
      case ToastType.success:
        return const Color(0xFFE4F7E4);
      case ToastType.error:
        return const Color(0xFFFFE4E4);
      case ToastType.info:
        return const Color(0xFFE4F4FF);
    }
  }

  Color _getIconColor() {
    switch (widget.type) {
      case ToastType.warning:
        return const Color(0xFFFFB37C);
      case ToastType.success:
        return const Color(0xFF4CAF50);
      case ToastType.error:
        return const Color(0xFFFF4D4F);
      case ToastType.info:
        return const Color(0xFF1890FF);
    }
  }
}

/// Toast 工具类，用于显示和隐藏 Toast
class ToastManager {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;
  static Timer? _timer;

  /// 显示 Toast
  /// [context] 上下文
  /// [title] 标题
  /// [message] 消息内容（可选）
  /// [type] Toast 类型
  /// [position] 显示位置，默认为顶部
  /// [offset] 自定义偏移量，例如 Offset(0, 100) 表示距离顶部 100 像素
  /// [duration] 显示时长，Duration.zero 表示不自动消失
  /// [onClose] 关闭回调
  static void show(
    BuildContext context, {
    required String title,
    String? message,
    ToastType type = ToastType.warning,
    ToastPosition position = ToastPosition.top,
    Offset? offset,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onClose,
    bool showIcon = true,
  }) {
    // 如果已经显示，先隐藏
    if (_isVisible) {
      hide();
    }

    // 取消之前的定时器
    _timer?.cancel();
    _timer = null;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned(
            top: position == ToastPosition.top 
                ? (offset?.dy ?? getToastTopOffset(context))
                : null,
            bottom: position == ToastPosition.bottom 
                ? (offset?.dy ?? getToastBottomOffset(context))
                : null,
            left: offset?.dx ?? 16,
            child: Material(
              color: Colors.transparent,
              child: Toast(
                title: title,
                message: message,
                type: type,
                offset: offset,
                showIcon: showIcon,
                onClose: () {
                  hide();
                  onClose?.call();
                },
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isVisible = true;

    // 设置新的定时器
    if (duration != Duration.zero) {
      _timer = Timer(duration, () {
        hide();
      });
    }
  }

  static double getToastTopOffset(BuildContext context) {
    return BottomBarSize().getBottomBarHeight(context);
  }

  static double getToastBottomOffset(BuildContext context) {
    return BottomBarSize().getBottomBarHeight(context);
  }

  /// 隐藏 Toast
  static void hide() {
    _timer?.cancel();
    _timer = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isVisible = false;
  }
}
