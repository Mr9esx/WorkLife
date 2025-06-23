import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

extension BuildContextExtension on BuildContext {
  /// 获取 Forui 主题数据
  FThemeData get theme => FTheme.of(this);
  
  /// 获取 Forui 颜色
  FColors get colors => FTheme.of(this).colors;
  
  /// 获取 Forui 字体样式
  FTypography get typography => FTheme.of(this).typography;
  
  /// 获取 Forui 样式
  FStyle get style => FTheme.of(this).style;
} 