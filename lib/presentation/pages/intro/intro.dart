import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 添加HapticFeedback支持
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/routes/route_name.dart';
import 'dart:math' as math;

import 'package:flutter_animate/flutter_animate.dart';

import 'package:WeekLife/theme/button_style.dart';
import 'package:forui/forui.dart';
import 'package:WeekLife/presentation/widgets/animate/animated_grid_pattern_optimized.dart';
import 'package:WeekLife/presentation/widgets/animate/typing_animation.dart';

class Intro extends StatefulWidget {
  final Map<String, dynamic>? params;

  const Intro({super.key, this.params});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4), // APP-背景色
        body: Stack(
          children: <Widget>[
            // 背景网格动画
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(0, -screenHeight * 0.1),
                child: AnimatedGridPatternOptimized(
                  squares: generateRandomSquares(screenWidth, screenHeight), // 生成随机方格
                  gridSize: screenWidth * 0.1, // 响应式网格大小
                  blinkFrequency: 2.0, // 闪动频率：2秒一个周期
                  blinkRange: 0.8, // 闪动范围：从0.1到0.9的透明度
                  minOpacity: 0.1, // 最小透明度
                  maxOpacity: 0.9, // 最大透明度
                  enableTapInteraction: true, // 启用点击交互
                  gridLineColor: AppColors.secondary.withAlpha((0.5 * 255).round()), // 网格线条颜色
                  squareColor: AppColors.secondary, // 方块颜色
                  tapSquareColor: AppColors.secondary, // 点击方块颜色
                ),
              ),
            ),

            // 底部渐变效果
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.15, // 渐变高度
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color(0xFFF4F4F4).withAlpha((0.8 * 255).round()),
                      const Color(0xFFF4F4F4).withAlpha((0.6 * 255).round()),
                      const Color(0xFFF4F4F4).withAlpha((0.4 * 255).round()),
                      const Color(0xFFF4F4F4).withAlpha((0.2 * 255).round()),
                      const Color(0xFFF4F4F4).withAlpha((0 * 255).round()),
                    ],
                    stops: const [0, 0.4, 0.6, 0.8, 1],
                  ),
                ),
              ),
            ),

            // 主要内容
            SafeArea(
              child: Column(
                children: [
                  // 顶部空间
                  SizedBox(height: screenHeight * 0.05),

                  // 主要内容区域
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // 标语文本
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                            child: TypingAnimation(
                              text: '记录人生之趣，回忆路程之遥。',
                              duration: const Duration(milliseconds: 80), // 每个字符150ms，让效果更明显
                              delay: const Duration(milliseconds: 200), // 延时800ms开始动画
                              animate: true,
                              style: TextStyle(
                                color: AppColors.primary, // 重点色
                                fontSize: 16,
                                fontFamily: 'SourceHanSerif',
                                fontWeight: FontWeight.w500,
                                height: 1,
                              ),
                              onAnimationStart: () {
                                // 动画开始时的回调
                                HapticFeedback.selectionClick();
                              },
                              onCharacterTyped: () {
                                // 每次打印字符时触发轻微震动
                                HapticFeedback.selectionClick();
                              },
                              onAnimationComplete: () {
                                // 动画完成时触发稍强的震动
                                HapticFeedback.selectionClick();
                              },
                            ),
                          ),

                          const SizedBox(height: 16), // 固定16px间距

                          // FButton(onPress: onPress, child: child)
                          SizedBox(
                            height: 60,
                            child: FButton(
                              onPress: () {
                                HapticFeedback.selectionClick();
                                Navigator.pushReplacementNamed(
                                  context,
                                  RouteName.appMain,
                                  arguments: {'pageId': 1}, // 1 对应周记 tab
                                );
                              },
                              style: buttonStyle(
                                colors: context.theme.colors,
                                typography: context.theme.typography,
                                style: context.theme.style,
                                color: AppColors.primary,
                                foregroundColor: AppColors.cardBackground,
                              ),
                              child: Text(
                                '开始记录',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'SourceHanSerif',
                                  fontVariations: [
                                    FontVariation('wght', 700), // 字重：700 (bold)
                                    // 如果字体支持其他轴，可以继续添加
                                    // FontVariation('wdth', 100), // 宽度
                                    // FontVariation('slnt', 0),   // 倾斜度
                                  ],
                                  height: 1,
                                ),
                              ),
                            ),
                          )
                              .animate(onPlay: (controller) => controller.repeat())
                              .shimmer(duration: 1500.ms, color: AppColors.secondary.withOpacity(0.3), size: 3)
                              .animate() // this wraps the previous Animate in another Animate
                              .fadeIn(duration: 300.ms, curve: Curves.easeOutQuad)
                              .slide(),

                          SizedBox(height: 16),

                          // 用户协议提示
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                            child: Text(
                              '点击「开始记录」，即代表您同意用户协议。',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primary.withOpacity(0.7), // 次要色
                                fontSize: 14, // 响应式字体大小
                                fontFamily: 'SourceHanSerif',
                                fontWeight: FontWeight.w300,
                                height: 1,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04), // 底部安全距离
                        ],
                      ),
                    ),
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

List<List<int>> generateRandomSquares(double screenWidth, double screenHeight, {double gridSizeRatio = 0.1}) {
  final random = math.Random();
  final squares = <List<int>>[];
  final gridSize = screenWidth * gridSizeRatio;

  final maxGridX = (screenWidth * 1.5 / gridSize).floor();
  final maxGridY = (screenHeight * 1.5 / gridSize).floor();

  final squareCount = 20 + random.nextInt(11);

  for (int i = 0; i < squareCount; i++) {
    squares.add([
      random.nextInt(maxGridX),
      random.nextInt(maxGridY),
    ]);
  }

  return squares;
}
