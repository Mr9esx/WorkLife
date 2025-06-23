import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/size_styles.dart';

class AppIcon extends StatelessWidget {
  final String assetName;
  final Color? color;
  final double? size;
  final bool isSelected;
  final bool isDarkMode;
  final Gradient? gradient;
  final double borderRadius;
  final double? strokeWidth;

  const AppIcon({
    super.key,
    required this.assetName,
    this.color,
    this.size,
    this.isSelected = false,
    this.isDarkMode = false,
    this.gradient,
    this.borderRadius = 0,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? IconSize.size;
    final defaultSize = IconSize.size;
    final scaleFactor = iconSize / defaultSize;

    Widget icon = Transform.scale(
      scale: scaleFactor,
      child: _buildSvgWidget(defaultSize),
    );

    // 用容器包装以确保占用正确的空间
    icon = SizedBox(
      width: iconSize,
      height: iconSize,
      child: Center(child: icon),
    );

    if (gradient != null) {
      icon = Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(child: icon),
      );
    }
    return icon;
  }

  /// 构建 SVG Widget，支持自定义 stroke-width
  Widget _buildSvgWidget(double defaultSize) {
    if (strokeWidth != null) {
      // 如果设置了 strokeWidth，需要修改 SVG 内容
      return Builder(
        builder: (context) {
          return FutureBuilder<String>(
            future: _loadAndModifySvg(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SvgPicture.string(
                  snapshot.data!,
                  width: defaultSize,
                  height: defaultSize,
                  colorFilter: ColorFilter.mode(
                    color ?? (isSelected ? AppColors.primary : AppColors.secondary),
                    BlendMode.srcIn,
                  ),
                );
              }
              // 加载中或出错时显示原始 SVG
              return SvgPicture.asset(
                'asset/images/icon/1.0x/$assetName.svg',
                width: defaultSize,
                height: defaultSize,
                colorFilter: ColorFilter.mode(
                  color ?? (isSelected ? AppColors.primary : AppColors.secondary),
                  BlendMode.srcIn,
                ),
              );
            },
          );
        },
      );
    }

    // 没有设置 strokeWidth 时使用原始方法
    return SvgPicture.asset(
      'asset/images/icon/1.0x/$assetName.svg',
      width: defaultSize,
      height: defaultSize,
      colorFilter: ColorFilter.mode(
        color ?? (isSelected ? AppColors.primary : AppColors.secondary),
        BlendMode.srcIn,
      ),
    );
  }

  /// 加载并修改 SVG 文件的 stroke-width
  Future<String> _loadAndModifySvg(BuildContext context) async {
    try {
      final bundle = DefaultAssetBundle.of(context);
      final svgString = await bundle.loadString('asset/images/icon/1.0x/$assetName.svg');

      // 使用正则表达式替换 stroke-width 属性
      final modifiedSvg = svgString.replaceAllMapped(
        RegExp(r'stroke-width="[^"]*"'),
        (match) => 'stroke-width="$strokeWidth"',
      );

      return modifiedSvg;
    } catch (e) {
      print('加载 SVG 失败: $e');
      // 如果加载失败，返回一个简单的 SVG
      return '<svg width="24" height="24" viewBox="0 0 24 24"></svg>';
    }
  }
}
