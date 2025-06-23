import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/text_styles.dart';
import 'package:WeekLife/common/ui/size_styles.dart';

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
      constraints: topMargin == null ? BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8) : null,
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

/// 通用的底部按钮行
class CommonBottomButtons extends StatelessWidget {
  final String? cancelText;
  final String? confirmText;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final Widget? middleButton;
  final double bottomMargin;

  const CommonBottomButtons({
    super.key,
    this.cancelText = '取消',
    this.confirmText = '确定',
    this.onCancel,
    this.onConfirm,
    this.middleButton,
    this.bottomMargin = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, bottomMargin),
      child: Row(
        children: [
          // 取消按钮
          if (onCancel != null)
            Expanded(
              child: _buildSecondaryButton(cancelText!, onCancel!),
            ),

          // 中间按钮（如预览按钮）
          if (middleButton != null) ...[
            const SizedBox(width: 8),
            Expanded(child: middleButton!),
          ],

          // 确定按钮
          if (onConfirm != null) ...[
            const SizedBox(width: 8),
            Expanded(
              child: _buildPrimaryButton(confirmText!, onConfirm!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderColor,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.buttonSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check,
                size: 18,
                color: AppColors.cardBackground,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: AppTextStyles.buttonPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 通用的工具栏按钮
class ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const ToolbarButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(GlobalSize.secondaryPadding),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
        child: Tooltip(
          message: tooltip,
          child: Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

/// 通用的选项卡片
class OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(GlobalSize.primaryPadding),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.imageOptionTitle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.imageOptionDescription,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 心情选项模型
class MoodOption {
  final String emoji;
  final String name;

  MoodOption({required this.emoji, required this.name});
}
