// lib/core/theme/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2F3036);
  static const Color secondary = Color(0xFFAFAFAF);
  static const Color borderColor = Color(0xFFEDEDED);
  static const Color cardBackground = Color(0xFFFCFCFC);
  static const Color appBackground = Color(0xFFF4F4F4);

  static const Color selectedBgColor = appBackground; // 选中背景色
  static const Color unselectedBgColor = cardBackground; // 未选中背景色
  static const Color selectedTextColor = primary; // 选中文字颜色
  static const Color unselectedTextColor = secondary; // 未选中文字颜色

  // TODO状态颜色
  static const Color todoInProgress = Color(0xFFFFB931); // 进行中 #FFB931
  static const Color todoCompleted = Color(0xFF2ED653); // 已完成 #2ED653

  // shadow 颜色
  static const Color _shadowColor = Color(0x165F5F5F);
  static const Color _softShadowColor = Color(0x085F5F5F);
}

class JournalThemeColors {
  // 规范主题色定义
  static const Color red = Color(0xFFFF4B3E); // 红色 #FF4B3E
  static const Color orange = Color(0xFFFF9900); // 橙色 #FF9900
  static const Color yellow = Color(0xFFFFD600); // 黄色 #FFD600
  static const Color green = Color(0xFF1FC47A); // 绿色 #1FC47A
  static const Color cyan = Color(0xFF00C2C7); // 青色 #00C2C7
  static const Color blue = Color(0xFF3A7DFF); // 蓝色 #3A7DFF
  static const Color purple = Color(0xFFA259F7); // 紫色 #A259F7

  // 通用白色文字色（用于主题色背景上的文字）
  static const Color textOnTheme = Color(0xFFFCFCFC); // 252,252,252

  // 主题色十六进制字符串映射（通过颜色值获取）
  static String getColorHex(Color color) {
    if (color == red) return '#FF4B3E';
    if (color == orange) return '#FF9900';
    if (color == yellow) return '#FFD600';
    if (color == green) return '#1FC47A';
    if (color == cyan) return '#00C2C7';
    if (color == blue) return '#3A7DFF';
    if (color == purple) return '#A259F7';
    return '#FFFFFF'; // 默认白色
  }

  // 颜色名称映射（通过颜色值获取）
  static String getColorName(Color color) {
    if (color == red) return '红';
    if (color == orange) return '橙';
    if (color == yellow) return '黄';
    if (color == green) return '绿';
    if (color == cyan) return '青';
    if (color == blue) return '蓝';
    if (color == purple) return '紫';
    return '未知'; // 默认值
  }
}

class Shadows {
  static const BoxShadow defaultShadow = BoxShadow(
    color: AppColors._shadowColor,
    blurRadius: 4,
    offset: Offset(0, 0),
    spreadRadius: 0,
  );

  static const BoxShadow softShadow = BoxShadow(
    color: AppColors._softShadowColor,
    blurRadius: 16,
    offset: Offset(0, 0),
    spreadRadius: 0,
  );
}
