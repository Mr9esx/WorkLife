import 'package:flutter/material.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/text_styles.dart';
import 'package:WeekLife/common/ui/size_styles.dart';
import 'package:WeekLife/common/constants/ui_constants.dart';
import 'package:WeekLife/common/constants/default_config.dart';
import 'package:WeekLife/common/ui/icon/app_emoji.dart';
import 'package:WeekLife/common/ui/icon/app_icon.dart';
import 'package:WeekLife/common/utils/mood_utils.dart';

import '../widgets/common/common_widgets.dart';
import '../widgets/selectors/mood_selector.dart';

/// 心情选择组件
/// 负责显示和管理心情选择功能
class MoodSection extends StatelessWidget {
  /// 当前选中的心情
  final String selectedMood;
  
  /// 当前选中的心情表情
  final String selectedMoodEmoji;
  
  /// 是否处于编辑状态
  final bool isEditing;
  
  /// 心情变化回调
  final Function(String mood, String emoji) onMoodChanged;
  
  /// 心情选项列表
  final List<MoodOption>? moodOptions;

  const MoodSection({
    super.key,
    required this.selectedMood,
    required this.selectedMoodEmoji,
    required this.isEditing,
    required this.onMoodChanged,
    this.moodOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题部分
        Text(
          '本周心情',
          style: AppTextStyles.editorTitle,
        ),
        
        const SizedBox(height: 8),
        
        // 内容容器
        _buildMoodContent(context),
      ],
    );
  }

  /// 构建心情内容（移除多余容器）
  Widget _buildMoodContent(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: 48, // 固定高度
        decoration: BoxDecoration(
          color: AppColors.appBackground.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderColor,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: isEditing ? () => _showMoodSelector(context) : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildMoodEmoji(),
                UIConstants.smallHorizontalSpacing,
                Expanded(
                  child: Text(
                    selectedMood,
                    style: AppTextStyles.moodDisplay,
                  ),
                ),
                _buildMoodColorIndicator(),
                UIConstants.smallHorizontalSpacing,
                if (isEditing) _buildDropdownIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建心情表情
  Widget _buildMoodEmoji() {
    return Container(
      width: UIConstants.moodEmojiSize,
      height: UIConstants.moodEmojiSize,
      alignment: Alignment.center,
      child: AppEmoji(
        assetName: selectedMoodEmoji, // 假设selectedMoodEmoji存储的是资源名称
        size: 24,
      ),
    );
  }

  /// 构建心情颜色指示器
  Widget _buildMoodColorIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GlobalSize.secondaryPadding, 
        vertical: 4
      ),
      decoration: BoxDecoration(
        color: _getMoodColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getMoodColorText(),
        style: AppTextStyles.journalExtraSmallText,
      ),
    );
  }

  /// 构建下拉箭头图标
  Widget _buildDropdownIcon() {
    return AppIcon(
      assetName: 'chevron-down',
      size: 24,
      color: AppColors.secondary,
    );
  }

  /// 获取心情对应的颜色
  Color _getMoodColor() {
    return MoodUtils.getMoodColor(selectedMood);
  }

  /// 获取心情颜色对应的文本
  String _getMoodColorText() {
    return MoodUtils.getMoodColorText(selectedMood);
  }

  /// 显示心情选择器
  void _showMoodSelector(BuildContext context) {
    final options = moodOptions ?? DefaultConfig.defaultMoodOptions;
    
    print('🎭 显示心情选择器');
    print('  当前选中的心情: $selectedMood');
    print('  当前选中的emoji: $selectedMoodEmoji');
    print('  可选心情选项:');
    for (final option in options) {
      print('    ${option.emoji} ${option.name}');
    }
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MoodSelector(
        selectedMood: selectedMood,
        selectedMoodEmoji: selectedMoodEmoji,
        onMoodSelected: (mood, emoji) {
          print('🎭 用户选择了心情: $mood ($emoji)');
          onMoodChanged(mood, emoji);
        },
        moodOptions: options,
      ),
    );
  }
}

 