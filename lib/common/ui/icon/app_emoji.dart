import 'package:flutter/material.dart';
import 'package:WeekLife/common/ui/size_styles.dart';

class AppEmoji extends StatelessWidget {
  final String assetName;
  final Color? color;
  final double? size;
  final bool isSelected;
  final bool isDarkMode;
  final Gradient? gradient;
  final double borderRadius;

  const AppEmoji({
    super.key,
    required this.assetName,
    this.color,
    this.size,
    this.isSelected = false,
    this.isDarkMode = false,
    this.gradient,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    // 特殊处理未记录状态 - 使用中性表情PNG
    if (assetName == '-') {
      final assetPath = 'asset/images/emoji/1.0x/neutral-face.png';
      return Container(
        width: size ?? IconSize.size,
        height: size ?? IconSize.size,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Image.asset(
          assetPath,
          width: size ?? IconSize.size,
          height: size ?? IconSize.size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // 如果PNG加载失败，显示问号作为后备
            return Container(
              width: size ?? IconSize.size,
              height: size ?? IconSize.size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Text(
                '?',
                style: TextStyle(
                  fontSize: (size ?? IconSize.size) * 0.6,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      );
    }

    final assetPath = 'asset/images/emoji/1.0x/$assetName.png';

    return Container(
      width: size ?? IconSize.size,
      height: size ?? IconSize.size,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Image.asset(
        assetPath,
        width: size ?? IconSize.size,
        height: size ?? IconSize.size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size ?? IconSize.size,
            height: size ?? IconSize.size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Text(
              '?',
              style: TextStyle(
                fontSize: (size ?? IconSize.size) * 0.6,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
