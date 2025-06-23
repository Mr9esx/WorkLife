import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/text_styles.dart';
import 'package:WeekLife/common/constants/ui_constants.dart';

/// 通用操作按钮组件
class ActionButton extends StatelessWidget {
  /// 按钮文本
  final String text;

  /// 按钮图标
  final IconData? icon;

  /// 点击回调
  final VoidCallback? onTap;

  /// 背景色
  final Color? backgroundColor;

  /// 文本颜色
  final Color? textColor;

  /// 边框颜色
  final Color? borderColor;

  /// 按钮类型
  final ActionButtonType type;

  /// 按钮尺寸
  final ActionButtonSize size;

  /// 是否启用
  final bool enabled;

  /// 是否显示加载状态
  final bool loading;

  /// 自定义宽度
  final double? width;

  /// 自定义高度
  final double? height;

  const ActionButton({
    super.key,
    required this.text,
    this.icon,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.type = ActionButtonType.primary,
    this.size = ActionButtonSize.medium,
    this.enabled = true,
    this.loading = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? _getButtonHeight();
    final isEnabled = enabled && !loading;

    return GestureDetector(
      onTap: isEnabled
          ? () {
              HapticFeedback.selectionClick();
              onTap?.call();
            }
          : null,
      child: Container(
        width: width,
        height: buttonHeight,
        padding: _getButtonPadding(),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(UIConstants.buttonBorderRadius),
          border: _getBorder(),
          boxShadow: _getBoxShadow(),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (loading) {
      return Center(
        child: SizedBox(
          width: _getIconSize(),
          height: _getIconSize(),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: _getIconSize(),
            color: _getTextColor(),
          ),
          if (text.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              text,
              style: _getTextStyle(),
            ),
          ],
        ],
      );
    }

    return Center(
      child: Text(
        text,
        style: _getTextStyle(),
      ),
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case ActionButtonSize.small:
        return 32;
      case ActionButtonSize.medium:
        return UIConstants.buttonHeight;
      case ActionButtonSize.large:
        return 56;
    }
  }

  EdgeInsets _getButtonPadding() {
    switch (size) {
      case ActionButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case ActionButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ActionButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    }
  }

  double _getIconSize() {
    switch (size) {
      case ActionButtonSize.small:
        return 16;
      case ActionButtonSize.medium:
        return UIConstants.smallIconSize;
      case ActionButtonSize.large:
        return UIConstants.iconSize;
    }
  }

  Color _getBackgroundColor() {
    if (!enabled) {
      return AppColors.borderColor.withOpacity(0.3);
    }

    if (backgroundColor != null) {
      return backgroundColor!;
    }

    switch (type) {
      case ActionButtonType.primary:
        return AppColors.primary;
      case ActionButtonType.secondary:
        return AppColors.cardBackground;
      case ActionButtonType.danger:
        return Colors.red;
      case ActionButtonType.success:
        return Colors.green;
      case ActionButtonType.ghost:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    if (!enabled) {
      return AppColors.secondary;
    }

    if (textColor != null) {
      return textColor!;
    }

    switch (type) {
      case ActionButtonType.primary:
        return Colors.white;
      case ActionButtonType.secondary:
        return AppColors.primary;
      case ActionButtonType.danger:
        return Colors.white;
      case ActionButtonType.success:
        return Colors.white;
      case ActionButtonType.ghost:
        return AppColors.primary;
    }
  }

  Border? _getBorder() {
    if (type == ActionButtonType.secondary || type == ActionButtonType.ghost) {
      return Border.all(
        color: borderColor ?? AppColors.borderColor,
        width: UIConstants.borderWidth,
      );
    }
    return null;
  }

  List<BoxShadow>? _getBoxShadow() {
    if (type == ActionButtonType.primary && enabled) {
      return [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    }
    return null;
  }

  TextStyle _getTextStyle() {
    final baseStyle = size == ActionButtonSize.small
        ? AppTextStyles.buttonSecondary.copyWith(fontSize: 12)
        : AppTextStyles.buttonPrimary;

    return baseStyle.copyWith(color: _getTextColor());
  }
}

/// 按钮类型枚举
enum ActionButtonType {
  primary,
  secondary,
  danger,
  success,
  ghost,
}

/// 按钮尺寸枚举
enum ActionButtonSize {
  small,
  medium,
  large,
}
