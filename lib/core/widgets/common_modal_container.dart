import 'package:flutter/material.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';

/// 通用的模态弹窗容器
class CommonModalContainer extends StatelessWidget {
  final Widget child;
  final double? topMargin;
  final double borderRadius;

  const CommonModalContainer({
    super.key,
    required this.child,
    this.topMargin,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: topMargin != null ? EdgeInsets.only(top: topMargin!) : null,
      constraints: topMargin == null 
          ? BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8)
          : null,
      decoration: BoxDecoration(
        color: AppColors.appBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 拖拽指示器
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
} 