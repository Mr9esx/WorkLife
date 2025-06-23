import 'package:flutter/material.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/text_styles.dart';
import 'package:WeekLife/common/constants/ui_constants.dart';

/// 通用章节容器组件
/// 用于包装各个功能模块，提供统一的标题和容器样式
class SectionContainer extends StatelessWidget {
  /// 章节标题
  final String title;

  /// 章节内容
  final Widget child;

  /// 是否显示边框
  final bool showBorder;

  /// 自定义内边距
  final EdgeInsets? padding;

  /// 自定义背景色
  final Color? backgroundColor;

  /// 标题右侧的操作组件
  final Widget? titleAction;

  /// 是否显示标题
  final bool showTitle;

  /// 自定义标题样式
  final TextStyle? titleStyle;

  /// 标题和内容之间的间距
  final double titleSpacing;

  const SectionContainer({
    super.key,
    required this.title,
    required this.child,
    this.showBorder = true,
    this.padding,
    this.backgroundColor,
    this.titleAction,
    this.showTitle = true,
    this.titleStyle,
    this.titleSpacing = UIConstants.sectionSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题部分
        if (showTitle) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: titleStyle ?? AppTextStyles.editorTitle,
                ),
              ),
              if (titleAction != null) titleAction!,
            ],
          ),
          SizedBox(height: titleSpacing),
        ],

        // 内容容器
        SizedBox(
          width: double.infinity,
          child: child,
        ),
      ],
    );
  }
}

/// 简化的章节容器，只包含内容，不包含标题
class SimpleContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool showBorder;
  final double borderRadius;

  const SimpleContainer({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.showBorder = true,
    this.borderRadius = UIConstants.cardBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? UIConstants.defaultPadding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(
                color: AppColors.borderColor,
                width: UIConstants.borderWidth,
              )
            : null,
      ),
      child: child,
    );
  }
}
