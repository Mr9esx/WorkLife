import 'package:flutter/material.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';

/// 单周视角页面的骨架加载组件
class SingleViewSkeletonLoading extends StatefulWidget {
  const SingleViewSkeletonLoading({super.key});

  @override
  State<SingleViewSkeletonLoading> createState() => _SingleViewSkeletonLoadingState();
}

class _SingleViewSkeletonLoadingState extends State<SingleViewSkeletonLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            // 周选择器骨架
            _buildWeekSelectorSkeleton(),
            
            const SizedBox(height: 16),
            
            // 内容区域骨架
            Expanded(
              child: _buildContentSkeleton(),
            ),
          ],
        );
      },
    );
  }

  /// 构建周选择器骨架
  Widget _buildWeekSelectorSkeleton() {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return _buildSkeletonBox(
            width: 50,
            height: 64,
            borderRadius: 8,
          );
        },
      ),
    );
  }

  /// 构建内容区域骨架
  Widget _buildContentSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题骨架
          _buildSkeletonBox(
            width: 120,
            height: 20,
            borderRadius: 4,
          ),
          
          const SizedBox(height: 16),
          
          // 内容卡片骨架
          Expanded(
            child: _buildSkeletonBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 12,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 底部按钮骨架
          Row(
            children: [
              Expanded(
                child: _buildSkeletonBox(
                  width: double.infinity,
                  height: 48,
                  borderRadius: 8,
                ),
              ),
              const SizedBox(width: 12),
              _buildSkeletonBox(
                width: 48,
                height: 48,
                borderRadius: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建骨架盒子
  Widget _buildSkeletonBox({
    required double width,
    required double height,
    double borderRadius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.unselectedBgColor.withValues(alpha: _animation.value),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// 周选择器骨架加载组件
class WeekSelectorSkeletonLoading extends StatefulWidget {
  const WeekSelectorSkeletonLoading({super.key});

  @override
  State<WeekSelectorSkeletonLoading> createState() => _WeekSelectorSkeletonLoadingState();
}

class _WeekSelectorSkeletonLoadingState extends State<WeekSelectorSkeletonLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 10,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return Container(
                width: 50,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.unselectedBgColor.withValues(alpha: _animation.value),
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// 周记内容骨架加载组件
class JournalContentSkeletonLoading extends StatefulWidget {
  const JournalContentSkeletonLoading({super.key});

  @override
  State<JournalContentSkeletonLoading> createState() => _JournalContentSkeletonLoadingState();
}

class _JournalContentSkeletonLoadingState extends State<JournalContentSkeletonLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.2,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 周记标题骨架
              Container(
                width: 150,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.unselectedBgColor.withValues(alpha: _animation.value),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 周记内容卡片骨架
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground.withValues(alpha: _animation.value),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.borderColor.withValues(alpha: _animation.value * 0.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 文本行骨架
                        ...List.generate(8, (index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              width: index == 7 ? 120 : double.infinity,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.unselectedBgColor.withValues(alpha: _animation.value * 0.6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }),
                        
                        const Spacer(),
                        
                        // 底部操作按钮骨架
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: _animation.value * 0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.unselectedBgColor.withValues(alpha: _animation.value),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 