import 'package:flutter/material.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/icon/app_icon.dart';

/// 自定义通用 AppBar 组件
/// 支持自定义左侧内容、右侧内容、背景色等属性
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.leftWidget,
    this.rightWidget,
    this.backgroundColor,
    this.showLogo = false,
    this.logoAssetName = 'logo',
    this.logoSize = 24,
    this.logoColor,
    this.height = 56,
    this.padding = const EdgeInsets.only(top: 16, left: 32, right: 16, bottom: 16),
    this.extendBodyBehindAppBar = true,
    this.elevation = 0,
    this.scrolledUnderElevation = 0,
    this.automaticallyImplyLeading = false,
  });

  /// 左侧自定义组件
  final Widget? leftWidget;

  /// 右侧自定义组件
  final Widget? rightWidget;

  /// 背景颜色
  final Color? backgroundColor;

  /// 是否显示默认 logo
  final bool showLogo;

  /// logo 资源名称
  final String logoAssetName;

  /// logo 尺寸
  final double logoSize;

  /// logo 颜色
  final Color? logoColor;

  /// AppBar 高度
  final double height;

  /// 内边距
  final EdgeInsetsGeometry padding;

  /// 是否扩展到状态栏后面
  final bool extendBodyBehindAppBar;

  /// 阴影高度
  final double elevation;

  /// 滚动时的阴影高度
  final double scrolledUnderElevation;

  /// 是否自动显示返回按钮
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      flexibleSpace: Container(
        decoration: BoxDecoration(color: backgroundColor ?? AppColors.appBackground),
        child: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: height),
            padding: padding,
            decoration: const BoxDecoration(),
            clipBehavior: Clip.antiAlias,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 左侧内容
                _buildLeftContent(),

                // 右侧内容
                _buildRightContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建左侧内容
  Widget _buildLeftContent() {
    if (leftWidget != null) {
      return leftWidget!;
    }

    if (showLogo) {
      return AppIcon(
        assetName: logoAssetName,
        size: logoSize,
        color: logoColor ?? AppColors.primary,
      );
    }

    return const SizedBox.shrink();
  }

  /// 构建右侧内容
  Widget _buildRightContent() {
    if (rightWidget != null) {
      return rightWidget!;
    }

    return const Spacer();
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

/// 预设的 Home 页面 AppBar
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomAppBar(
      showLogo: true,
      logoSize: 40,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
