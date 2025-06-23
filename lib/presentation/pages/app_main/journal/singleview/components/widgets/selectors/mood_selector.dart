import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/icon/app_emoji.dart';
import 'package:WeekLife/common/utils/mood_utils.dart';
import '../common/common_widgets.dart';

/// 心情选择器组件 - 左右滑动卡片布局
class MoodSelector extends StatefulWidget {
  final String selectedMood;
  final String selectedMoodEmoji;
  final Function(String mood, String emoji) onMoodSelected;
  final List<MoodOption> moodOptions;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.selectedMoodEmoji,
    required this.onMoodSelected,
    required this.moodOptions,
  });

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  late String _currentSelectedMood;
  late String _currentSelectedMoodEmoji;
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentSelectedMood = widget.selectedMood;
    _currentSelectedMoodEmoji = widget.selectedMoodEmoji;

    // 找到当前选中心情的索引
    _currentIndex = widget.moodOptions.indexWhere(
      (mood) => mood.name == widget.selectedMood,
    );
    if (_currentIndex == -1) _currentIndex = 0;

    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.3, // 减小卡片宽度，让相邻的卡片更多可见
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonModalContainer(
      borderRadius: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // // 标题
          // Padding(
          //   padding: const EdgeInsets.all(GlobalSize.primaryPadding),
          //   child: Text(
          //     '选择心情',
          //     style: AppTextStyles.editorTitle.copyWith(fontSize: 16),
          //   ),
          // ),

          // 心情卡片滑动区域
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _currentSelectedMood = widget.moodOptions[index].name;
                  _currentSelectedMoodEmoji = widget.moodOptions[index].emoji;
                });

                // 触发轻微震动反馈
                HapticFeedback.selectionClick();

                // 暂时不回调，等用户确认后再保存
              },
              itemCount: widget.moodOptions.length,
              itemBuilder: (context, index) {
                return _buildMoodCard(widget.moodOptions[index], index);
              },
            ),
          ),

          const SizedBox(height: 16),

          // 指示器
          _buildPageIndicator(),

          const SizedBox(height: 32),

          // 底部按钮
          CommonBottomButtons(
            onCancel: () => Navigator.pop(context),
            onConfirm: () {
              // 确认时才回调选择结果并保存
              widget.onMoodSelected(
                _currentSelectedMood,
                _currentSelectedMoodEmoji,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  /// 构建心情卡片
  Widget _buildMoodCard(MoodOption mood, int index) {
    final isSelected = index == _currentIndex;
    final moodColor = MoodUtils.getMoodColor(mood.name);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: isSelected
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 16)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // 选中时表情更大
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.borderColor.withOpacity(0),
          width: isSelected ? 2 : 2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 表情
          AnimatedScale(
            scale: isSelected ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              child: AppEmoji(
                assetName: mood.emoji,
                size: isSelected ? 48 : 40, // 选中时表情更大
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 心情名称
          Text(
            mood.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.cardBackground : AppColors.secondary,
            ),
          ),

          const SizedBox(height: 8),

          // 主题色指示器
          Container(
            width: 16,
            height: 3,
            decoration: BoxDecoration(
              color: moodColor,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建页面指示器
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.moodOptions.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentIndex == index ? AppColors.primary : AppColors.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  /// 显示心情选择器
  static void show({
    required BuildContext context,
    required String selectedMood,
    required String selectedMoodEmoji,
    required Function(String mood, String emoji) onMoodSelected,
    required List<MoodOption> moodOptions,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MoodSelector(
        selectedMood: selectedMood,
        selectedMoodEmoji: selectedMoodEmoji,
        onMoodSelected: onMoodSelected,
        moodOptions: moodOptions,
      ),
    );
  }
}
