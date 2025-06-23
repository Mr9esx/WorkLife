import 'package:flutter/material.dart';

/// UI常量配置
class UIConstants {
  // 照片网格配置
  static const int maxPhotoCount = 9;
  static const double photoGridSpacing = 8.0;
  static const int photoGridMinColumns = 2;
  static const int photoGridMaxColumns = 4;
  static const int photoGridMinItemWidth = 80;
  
  // 动画配置
  static const Duration fadeAnimationDuration = Duration(milliseconds: 400);
  static const Duration deleteAnimationDuration = Duration(milliseconds: 300);
  static const Duration slideAnimationDuration = Duration(milliseconds: 250);
  
  // 尺寸配置
  static const double sectionSpacing = 16.0;
  static const double buttonHeight = 48.0;
  static const double inputHeight = 44.0;
  static const double iconSize = 24.0;
  static const double smallIconSize = 18.0;
  static const double largeIconSize = 32.0;
  
  // 圆角配置
  static const double cardBorderRadius = 8.0;
  static const double buttonBorderRadius = 8.0;
  static const double containerBorderRadius = 16.0;
  
  // 边距配置
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets smallPadding = EdgeInsets.all(8.0);
  static const EdgeInsets largePadding = EdgeInsets.all(24.0);
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets verticalPadding = EdgeInsets.symmetric(vertical: 16.0);
  
  // 间距配置
  static const SizedBox smallVerticalSpacing = SizedBox(height: 8.0);
  static const SizedBox mediumVerticalSpacing = SizedBox(height: 16.0);
  static const SizedBox largeVerticalSpacing = SizedBox(height: 24.0);
  static const SizedBox smallHorizontalSpacing = SizedBox(width: 8.0);
  static const SizedBox mediumHorizontalSpacing = SizedBox(width: 16.0);
  
  // 阴影配置
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
  
  // 边框配置
  static const double borderWidth = 1.0;
  static const double thickBorderWidth = 2.0;
  
  // 响应式断点
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  // TODO相关配置
  static const double todoItemHeight = 56.0;
  static const double todoCheckboxSize = 20.0;
  static const int maxTodoPriority = 3;
  static const int minTodoPriority = 1;
  
  // 心情选择器配置
  static const double moodItemSize = 60.0;
  static const double moodEmojiSize = 32.0;
  
  // 周选择器配置
  static const double weekSelectorHeight = 56.0;
  static const double weekItemWidth = 45.0;
  static const double weekItemSpacing = 6.0;
} 