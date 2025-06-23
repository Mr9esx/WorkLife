// lib/core/theme/text_styles.dart
import 'package:flutter/material.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/font/dimens.dart';

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: AppDimens.fontLarge,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
  static const TextStyle body = TextStyle(
    fontSize: AppDimens.fontNormal,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );
  // ... 其他样式

  // Journal 周标题样式
  static const TextStyle journalWeekHeaderYear = TextStyle(
    color: AppColors.primary,
    fontSize: 16,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle journalWeekHeaderNumber = TextStyle(
    fontSize: 13,
    color: AppColors.cardBackground,
    fontWeight: FontWeight.w900,
  );

  // Journal Content 相关样式

  // 通用文本样式
  static const TextStyle journalExtraSmallText = TextStyle(
    color: AppColors.cardBackground,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle journalSmallText = TextStyle(
    color: AppColors.secondary,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle journalBodyText = TextStyle(
    color: AppColors.primary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle journalLargeText = TextStyle(
    color: AppColors.primary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle journalExtraLargeText = TextStyle(
    color: AppColors.primary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  // 心情显示样式
  static const TextStyle moodDisplay = TextStyle(
    color: AppColors.primary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // 心情选择器样式
  static const TextStyle moodOption = TextStyle(
    color: AppColors.primary,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle moodOptionSelected = TextStyle(
    color: AppColors.primary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // 按钮样式
  static const TextStyle buttonPrimary = TextStyle(
    color: AppColors.cardBackground,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle buttonSecondary = TextStyle(
    color: AppColors.secondary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle buttonAccent = TextStyle(
    color: AppColors.primary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // 提示文本样式
  static const TextStyle hintText = TextStyle(
    color: AppColors.secondary,
    fontSize: 14,
    fontStyle: FontStyle.italic,
    height: 1.5,
  );

  static const TextStyle placeholderText = TextStyle(
    color: AppColors.secondary,
    fontSize: 14,
    fontWeight: FontWeight.w300,
    // height: 1,
  );

  // 编辑器相关样式
  static const TextStyle editorInput = TextStyle(
    color: AppColors.primary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle editorTitle = TextStyle(
    color: Color(0xFF2F3036), // 重点色
    fontSize: 14,
    fontFamily: 'MiSans',
    fontWeight: FontWeight.w600,
  );

  // Markdown 样式 - 针对iPhone阅读体验优化
  static const TextStyle markdownParagraph = TextStyle(
    color: AppColors.primary,
    fontSize: 15, // 增加到15px，iPhone上更易读
    fontWeight: FontWeight.w400,
    height: 1.6, // 适中的行距，不会太紧凑
    letterSpacing: 0.5, // 增加字间距，提升可读性
  );

  static const TextStyle markdownH1 = TextStyle(
    color: AppColors.primary,
    fontSize: 22, // 增加主标题大小
    fontWeight: FontWeight.w700,
    height: 1.4, // 标题行距稍紧凑
    letterSpacing: 0.5, // 标题字间距稍大
  );

  static const TextStyle markdownH2 = TextStyle(
    color: AppColors.primary,
    fontSize: 19, // 调整二级标题
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.4,
  );

  static const TextStyle markdownH3 = TextStyle(
    color: AppColors.primary,
    fontSize: 17, // 调整三级标题
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.3,
  );

  static const TextStyle markdownH4 = TextStyle(
    color: AppColors.primary,
    fontSize: 16, // 调整四级标题
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.2,
  );

  static const TextStyle markdownH5 = TextStyle(
    color: AppColors.primary,
    fontSize: 15, // 调整五级标题，与正文相同大小但加粗
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.2,
  );

  static const TextStyle markdownStrong = TextStyle(
    color: AppColors.primary,
    fontSize: 15, // 与正文保持一致
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2, // 加粗文字稍微增加字间距
  );

  static const TextStyle markdownEmphasis = TextStyle(
    color: AppColors.primary,
    fontSize: 15, // 与正文保持一致
    fontStyle: FontStyle.italic,
    letterSpacing: 0.3, // 斜体字间距与正文一致
  );

  static const TextStyle markdownCode = TextStyle(
    color: AppColors.primary,
    backgroundColor: AppColors.appBackground,
    fontFamily: 'monospace',
    fontSize: 14, // 代码字体稍小，更易辨识
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1, // 代码字间距稍小
  );

  static const TextStyle markdownBlockquote = TextStyle(
    color: AppColors.secondary,
    fontSize: 15, // 与正文保持一致
    fontStyle: FontStyle.italic,
    height: 1.6, // 与正文行距一致
    letterSpacing: 0.3,
  );

  static const TextStyle markdownListBullet = TextStyle(
    color: AppColors.primary,
    fontSize: 15, // 与正文保持一致
    height: 1.6, // 列表行距与正文一致
    letterSpacing: 0.3,
  );

  // 图片相关样式
  static const TextStyle imageOptionTitle = TextStyle(
    color: AppColors.primary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle imageOptionDescription = TextStyle(
    color: AppColors.secondary,
    fontSize: 12,
  );

  static const TextStyle imageCounter = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // 空状态样式
  static const TextStyle emptyState = TextStyle(
    color: AppColors.secondary,
    fontSize: 14,
    fontStyle: FontStyle.italic,
    height: 1.5,
  );
}
