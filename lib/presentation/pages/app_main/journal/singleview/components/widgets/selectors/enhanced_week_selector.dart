import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/icon/app_emoji.dart';
import 'package:WeekLife/common/utils/mood_utils.dart';
import 'package:WeekLife/core/utils/index.dart';
import 'package:WeekLife/data/models/weekly_journal/weekly_journal_data.dart';

/// 增强版周选择器组件
/// 显示每周的心情emoji和主题色，未记录的周显示"-"
class EnhancedWeekSelector extends StatefulWidget {
  const EnhancedWeekSelector({
    super.key,
    required this.currentWeek,
    required this.onWeekSelected,
    required this.year,
    required this.yearlyJournals,
    this.isYearCompleted = false,
    this.height = 64,
    this.itemWidth = 50,
    this.spacing = 8,
    this.isEditingMode = false,
  });

  /// 当前选中的周数
  final int currentWeek;

  /// 周选择回调
  final Function(int week) onWeekSelected;

  /// 年份
  final int year;

  /// 该年份的所有周记数据
  final List<WeeklyJournalData> yearlyJournals;

  /// 该年份是否已经过完
  final bool isYearCompleted;

  /// 组件高度
  final double height;

  /// 每个周项的宽度
  final double itemWidth;

  /// 周项之间的间距
  final double spacing;

  /// 是否处于编辑模式（编辑模式下禁用交互）
  final bool isEditingMode;

  @override
  State<EnhancedWeekSelector> createState() => _EnhancedWeekSelectorState();
}

class _EnhancedWeekSelectorState extends State<EnhancedWeekSelector> {
  late ScrollController _scrollController;
  late int _currentYear;
  late int _currentWeekOfYear;
  late int _totalWeeksInYear;
  bool _showBackToCurrentButton = false;

  // 周记数据映射，key为周数，value为周记数据
  final Map<int, WeeklyJournalData> _journalMap = {};

  @override
  void initState() {
    super.initState();
    _currentYear = widget.year;
    _currentWeekOfYear = _getCurrentWeekOfYear();
    _totalWeeksInYear = DateUtil.getWeeksInYear(_currentYear);

    _scrollController = ScrollController();

    // 监听滚动位置变化
    _scrollController.addListener(_onScrollChanged);

    // 构建周记数据映射
    _buildJournalMap();

    // 延迟滚动到当前周
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentWeek();
    });
  }

  @override
  void didUpdateWidget(EnhancedWeekSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 如果周记数据发生变化，重新构建映射
    // 使用长度和内容比较来确定是否需要重新构建
    bool needsRebuild = widget.yearlyJournals.length != oldWidget.yearlyJournals.length;
    if (!needsRebuild && widget.yearlyJournals.isNotEmpty) {
      // 检查内容是否有变化（比较前几个记录的关键字段）
      for (int i = 0; i < widget.yearlyJournals.length && i < oldWidget.yearlyJournals.length; i++) {
        final newJournal = widget.yearlyJournals[i];
        final oldJournal = oldWidget.yearlyJournals[i];
        if (newJournal.weekNumber != oldJournal.weekNumber ||
            newJournal.mood != oldJournal.mood ||
            newJournal.moodColor != oldJournal.moodColor) {
          needsRebuild = true;
          break;
        }
      }
    }

    if (needsRebuild) {
      print('🔄 检测到周记数据变化，重新构建映射');
      _buildJournalMap();
      // 强制重新渲染
      setState(() {});
    }

    // 如果选中的周发生变化，滚动到新的周
    if (widget.currentWeek != oldWidget.currentWeek) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToWeek(widget.currentWeek);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollChanged);
    _scrollController.dispose();
    super.dispose();
  }

  /// 构建周记数据映射
  void _buildJournalMap() {
    _journalMap.clear();
    for (final journal in widget.yearlyJournals) {
      _journalMap[journal.weekNumber] = journal;
    }
    print('📊 周选择器数据映射已构建: ${_journalMap.length} 条记录');
    // 打印前几条记录用于调试
    final firstFew = _journalMap.entries.take(3).toList();
    for (final entry in firstFew) {
      print('  周${entry.key}: mood=${entry.value.mood}, moodColor=${entry.value.moodColor}');
    }
  }

  /// 监听滚动位置变化，判断是否显示回到本周按钮
  void _onScrollChanged() {
    if (!mounted || !_scrollController.hasClients) return;

    final isCurrentWeekVisible = _isCurrentWeekVisible();
    if (isCurrentWeekVisible != !_showBackToCurrentButton) {
      setState(() {
        _showBackToCurrentButton = !isCurrentWeekVisible;
      });
    }
  }

  /// 判断当前周是否在可见范围内
  bool _isCurrentWeekVisible() {
    if (!_scrollController.hasClients) return true;

    final screenWidth = MediaQuery.of(context).size.width;
    const listViewHorizontalPadding = 16.0;
    const containerHorizontalPadding = 16.0; // GlobalSize.primaryPadding

    // 计算实际可视区域的宽度（减去所有padding）
    final totalHorizontalPadding = (listViewHorizontalPadding + containerHorizontalPadding) * 2;
    final viewportWidth = screenWidth - totalHorizontalPadding;

    // 计算可视区域的范围
    final visibleStartPosition = _scrollController.offset;
    final visibleEndPosition = _scrollController.offset + viewportWidth;

    // 计算当前周的位置
    final currentWeekStartPosition = (widget.currentWeek - 1) * (widget.itemWidth + widget.spacing);
    final currentWeekEndPosition = currentWeekStartPosition + widget.itemWidth;

    // 判断当前周是否在可视范围内
    return currentWeekEndPosition > visibleStartPosition && currentWeekStartPosition < visibleEndPosition;
  }

  /// 获取当前年份的周数（用于判断哪些周可以选择）
  int _getCurrentWeekOfYear() {
    final now = DateTime.now();
    final currentYear = now.year;

    if (widget.year == currentYear) {
      // 当前年份，返回当前周数
      return DateUtil.getWeekOfYear(now);
    } else if (widget.year < currentYear) {
      // 过去的年份，返回该年的最大周数（所有周都可选择）
      return DateUtil.getWeeksInYear(widget.year);
    } else {
      // 未来的年份，返回 0（没有周可选择）
      return 0;
    }
  }

  /// 滚动到当前周
  void _scrollToCurrentWeek() {
    _scrollToWeek(widget.currentWeek);
  }

  /// 滚动到指定周并完美居中显示
  void _scrollToWeek(int week) {
    if (!_scrollController.hasClients || !mounted) return;

    // 获取屏幕宽度
    final screenWidth = MediaQuery.of(context).size.width;

    // ListView的左右padding
    const listViewHorizontalPadding = 16.0;

    // 外层容器的左右padding（来自 journal_content.dart 中的 Container）
    const containerHorizontalPadding = 16.0; // GlobalSize.primaryPadding

    // 计算目标周在ListView中的起始位置（不包括任何padding）
    final targetItemStartPosition = (week - 1) * (widget.itemWidth + widget.spacing);

    // 计算目标项的中心点位置（不包括任何padding）
    final targetItemCenterPosition = targetItemStartPosition + widget.itemWidth / 2;

    // 计算实际可视区域的宽度（减去所有padding）
    final totalHorizontalPadding = (listViewHorizontalPadding + containerHorizontalPadding) * 2;
    final viewportWidth = screenWidth - totalHorizontalPadding;

    // 计算需要滚动的距离，使目标项居中
    // 目标项中心位置 - 可视区域中心位置 = 滚动距离
    final scrollPosition = targetItemCenterPosition - (viewportWidth / 2);

    // 获取滚动范围的边界
    final minScrollExtent = _scrollController.position.minScrollExtent;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;

    // 确保滚动位置在有效范围内
    final clampedScrollPosition = scrollPosition.clamp(minScrollExtent, maxScrollExtent);

    // 执行平滑滚动动画
    _scrollController.animateTo(
      clampedScrollPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// 判断周是否可选择
  bool _isWeekSelectable(int week) {
    if (widget.isYearCompleted) {
      return true; // 年份已过完，所有周都可选择
    }
    // 允许选择所有周份（包括未来的周份）
    return true;
  }

  /// 获取周的心情emoji资源名称
  String _getWeekMoodEmoji(int week) {
    final journal = _journalMap[week];
    if (journal == null) {
      // 检查是否是下一周（第一个未来周份）
      final now = DateTime.now();
      final currentYear = now.year;
      final currentWeek = DateUtil.getWeekOfYear(now);

      if (widget.year == currentYear && week == currentWeek + 1) {
        return '下周'; // 下一周显示"下周"
      }
      return '-'; // 其他未记录周份显示"-"
    }

    // 使用MoodUtils统一处理心情映射
    return MoodUtils.getMoodEmojiAsset(journal.mood);
  }

  /// 获取周的主题色
  Color _getWeekThemeColor(int week) {
    final journal = _journalMap[week];
    if (journal == null) {
      return AppColors.borderColor; // 未记录时的默认色
    }

    // 优先使用存储的颜色字符串
    try {
      final colorString = journal.moodColor;
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        return MoodUtils.parseColorFromHex(colorString);
      }
    } catch (e) {
      // 解析失败时使用默认颜色
    }

    // 使用MoodUtils统一处理心情颜色映射
    return MoodUtils.getMoodColorById(journal.mood);
  }

  /// 获取周项的背景色
  Color _getWeekBackgroundColor(int week) {
    if (week == widget.currentWeek) {
      return AppColors.primary; // 选中项使用primary色
    } else if (!_isWeekSelectable(week)) {
      return AppColors.unselectedBgColor.withValues(alpha: 0.5);
    } else {
      return AppColors.unselectedBgColor;
    }
  }

  /// 获取周项的文字颜色
  Color _getWeekTextColor(int week) {
    if (week == widget.currentWeek) {
      return AppColors.appBackground; // 选中项使用app背景色
    } else if (!_isWeekSelectable(week)) {
      return AppColors.unselectedTextColor.withValues(alpha: 0.5);
    } else {
      return AppColors.unselectedTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // 周选择器列表
          ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _totalWeeksInYear,
            separatorBuilder: (context, index) => SizedBox(width: widget.spacing),
            itemBuilder: (context, index) {
              final week = index + 1;
              final isSelectable = _isWeekSelectable(week);
              final isSelected = week == widget.currentWeek;
              final moodEmoji = _getWeekMoodEmoji(week);
              final themeColor = _getWeekThemeColor(week);

              return GestureDetector(
                onTap: (isSelectable && !widget.isEditingMode)
                    ? () {
                        // 触发轻微震动
                        HapticFeedback.selectionClick();
                        widget.onWeekSelected(week);
                        _scrollToWeek(week);
                      }
                    : widget.isEditingMode
                        ? () {
                            // 编辑模式下调用回调，但不滚动
                            widget.onWeekSelected(week);
                          }
                        : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: widget.itemWidth,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: _getWeekBackgroundColor(week),
                    borderRadius: BorderRadius.circular(8),
                    // border: isSelected
                    //     ? Border.all(color: AppColors.primary, width: 2)
                    //     : null,
                    boxShadow: isSelected ? [Shadows.softShadow] : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 心情emoji、"-"或"下周"
                      SizedBox(
                        width: double.infinity,
                        child: (moodEmoji == '-' || moodEmoji == '下周')
                            ? Text(
                                moodEmoji,
                                style: TextStyle(
                                  fontSize: moodEmoji == '下周' ? 10 : 16,
                                  color: _getWeekTextColor(week),
                                  height: 1.0,
                                  fontWeight: moodEmoji == '下周' ? FontWeight.w600 : FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : Center(
                                child: AppEmoji(
                                  assetName: moodEmoji,
                                  size: 16,
                                ),
                              ),
                      ),
                      const SizedBox(height: 4),
                      // 周数
                      Text(
                        '$week',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: _getWeekTextColor(week),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 主题色指示器
                      Container(
                        width: 16,
                        height: 3,
                        decoration: BoxDecoration(
                          color: (moodEmoji == '-' || moodEmoji == '下周')
                              ? AppColors.borderColor.withValues(alpha: 0.5)
                              : themeColor,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 回到本周按钮
          if (_showBackToCurrentButton) _buildBackToCurrentButton(),
        ],
      ),
    );
  }

  /// 构建回到本周按钮
  Widget _buildBackToCurrentButton() {
    // 判断当前周在左侧还是右侧
    final currentWeekPosition = (widget.currentWeek - 1) * (widget.itemWidth + widget.spacing);
    final isCurrentWeekOnLeft = currentWeekPosition < _scrollController.offset;

    return Positioned(
      top: 0,
      bottom: 0,
      left: isCurrentWeekOnLeft ? 0 : null,
      right: isCurrentWeekOnLeft ? null : 0,
      child: Center(
        child: GestureDetector(
          onTap: !widget.isEditingMode
              ? () {
                  // 触发轻微震动
                  HapticFeedback.selectionClick();
                  widget.onWeekSelected(widget.currentWeek);
                  _scrollToWeek(widget.currentWeek);
                }
              : () {
                  // 编辑模式下调用回调，但不滚动
                  widget.onWeekSelected(widget.currentWeek);
                },
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                isCurrentWeekOnLeft ? Icons.chevron_left : Icons.chevron_right,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
