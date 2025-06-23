import 'package:flutter/material.dart';

/// 尺寸常量类
/// 集中管理所有UI组件的尺寸常量
/// 
class GlobalSize {
  static const double primaryPadding = 16.0;      // 一级宽度
  static const double secondaryPadding = 8.0;      // 二级宽度
  static const double thirdPadding = 4.0;

  static const double safeBottomMargin = 86;

  /// 获取安全区域内的可用宽度
  /// 考虑了设备安全区域（如刘海屏）和自定义边距
  /// 横竖屏都会正确处理
  double getFullWidth(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final orientation = MediaQuery.of(context).orientation;
    
    // 横屏时使用高度作为宽度，竖屏时使用宽度
    final screenWidth = orientation == Orientation.portrait ? size.width : size.height;
    // 横屏时使用垂直方向的安全区域，竖屏时使用水平方向的安全区域
    final safePadding = orientation == Orientation.portrait 
        ? padding.horizontal 
        : padding.vertical;
    
    // 屏幕宽度减去设备安全区域和自定义边距
    return screenWidth - safePadding - (primaryPadding * 2);
  }

  /// 获取 MediaQuery 信息
  Map<String, dynamic> getMediaQueryInfo(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final horizontalPadding = padding.horizontal;
    final fullWidth = getFullWidth(context);
    
    return {
      'padding': padding.toString(),
      'left': padding.left,
      'right': padding.right,
      'top': padding.top,
      'bottom': padding.bottom,
      'fullWidth': fullWidth,
      'horizontalPadding': horizontalPadding,
    };
  }
}

/// 底部导航栏相关尺寸
class BottomBarSize {
  static const double height = 52.0;     // 底部栏高度
  static const double leftButtonWidth = 60.0;  // 左侧按钮宽度

  static const double bottomBarHeight = 52.0;     // 底部栏高度

  /// 计算底部栏容器的内边距
  static EdgeInsets get containerPadding => EdgeInsets.all(GlobalSize.primaryPadding);

  /// 计算左侧按钮的内边距
  static EdgeInsets get bottomBarPadding => const EdgeInsets.symmetric(horizontal: 11, vertical: 14);

  /// 计算右侧容器的内边距
  static EdgeInsets get rightContainerPadding => EdgeInsets.all(MenuSize.itemSpacing);

  double getBottomBarHeight(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return padding.bottom + height + (GlobalSize.primaryPadding + GlobalSize.secondaryPadding);
  }
}

/// 菜单相关尺寸
class MenuSize {
  static const double itemHeight = 44.0;        // 菜单项高度
  static const double itemPadding = 12.0;       // 菜单项内边距
  static const double itemSpacing = 4.0;        // 菜单项间距
  static const double cornerRadius = 8.0;       // 圆角半径
  static const double bottomOffset = 56.0;      // 菜单底部偏移量
  static const double itemExtraPadding = 4.0;   // 菜单项额外内边距

  /// 计算菜单项的内边距
  static EdgeInsets get menuItemPadding => EdgeInsets.symmetric(
    horizontal: itemPadding,
    vertical: 14,
  );

  /// 计算菜单容器的内边距
  static EdgeInsets get containerPadding => EdgeInsets.all(itemSpacing);

  /// 计算菜单项之间的间距
  static EdgeInsets getItemBottomPadding(bool isLastItem) => EdgeInsets.only(
    bottom: isLastItem ? 0 : itemSpacing,
  );

  /// 计算菜单的圆角
  static BorderRadius get borderRadius => BorderRadius.circular(cornerRadius);

  /// 计算菜单的宽度
  /// [buttonWidth] 按钮宽度
  static double getMenuWidth(double buttonWidth) => buttonWidth + (itemExtraPadding * 2);

  /// 计算菜单的水平位置
  /// [buttonPosition] 按钮位置
  static double getMenuLeft(double buttonPosition) => buttonPosition - itemExtraPadding;

  /// 计算菜单的垂直位置
  /// [screenHeight] 屏幕高度
  /// [buttonPosition] 按钮位置
  /// [buttonHeight] 按钮高度
  static double getMenuBottom(double screenHeight, double buttonPosition, double buttonHeight) =>
      screenHeight - buttonPosition - buttonHeight + bottomOffset;
}

/// 图标相关尺寸
class IconSize {
  static const double size = 24.0;              // 图标尺寸
  static const double checkBoxSize = 16.0;      // 复选框尺寸

  /// 获取AI图标的尺寸（比普通图标大4）
  static double get aiIconSize => size + 4;

  /// 获取复选框内部圆点的位置和尺寸
  static const double checkBoxDotSize = 6.0;
  static const double checkBoxDotPosition = 5.0;
} 