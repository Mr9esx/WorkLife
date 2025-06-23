import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/core/utils/index.dart';

/// 周选择器组件
/// 一年固定显示54周（从1月1日开始，每7天为一周）
/// 支持滑动选择年份中的每一周，当前周高亮，未来周灰色显示
class WeekSelector extends StatefulWidget {
  const WeekSelector({
    super.key,
    required this.currentWeek,
    required this.onWeekSelected,
    this.year,
    this.isYearCompleted = false,
    this.height = 64,
    this.itemWidth = 50,
    this.spacing = 8,
    this.selectedColor,
    this.unselectedColor,
    this.disabledColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.disabledTextColor,
  });

  /// 当前选中的周数
  final int currentWeek;
  
  /// 周选择回调
  final Function(int week) onWeekSelected;
  
  /// 年份，默认为当前年份
  final int? year;
  
  /// 该年份是否已经过完
  final bool isYearCompleted;
  
  /// 组件高度
  final double height;
  
  /// 每个周项的宽度
  final double itemWidth;
  
  /// 周项之间的间距
  final double spacing;
  
  /// 选中状态的背景色
  final Color? selectedColor;
  
  /// 未选中状态的背景色
  final Color? unselectedColor;
  
  /// 禁用状态的背景色
  final Color? disabledColor;
  
  /// 选中状态的文字颜色
  final Color? selectedTextColor;
  
  /// 未选中状态的文字颜色
  final Color? unselectedTextColor;
  
  /// 禁用状态的文字颜色
  final Color? disabledTextColor;

  @override
  State<WeekSelector> createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<WeekSelector> {
  late ScrollController _scrollController;
  late int _currentYear;
  late int _currentWeekOfYear;
  late int _totalWeeksInYear;
  bool _showBackToCurrentButton = false;
  
  @override
  void initState() {
    super.initState();
    _currentYear = widget.year ?? DateTime.now().year;
    _currentWeekOfYear = _getCurrentWeekOfYear();
    _totalWeeksInYear = DateUtil.getWeeksInYear(_currentYear);
    
    _scrollController = ScrollController();
    
    // 监听滚动位置变化
    _scrollController.addListener(_onScrollChanged);
    
    // 延迟滚动到当前周
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentWeek();
    });
  }
  
  @override
  void didUpdateWidget(WeekSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    
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
    const horizontalPadding = 16.0;
    
    // 计算可视区域的范围（考虑padding）
    final visibleStartPosition = _scrollController.offset;
    final visibleEndPosition = _scrollController.offset + screenWidth - (horizontalPadding * 2);
    
    // 计算当前周的位置
    final currentWeekStartPosition = (widget.currentWeek - 1) * (widget.itemWidth + widget.spacing);
    final currentWeekEndPosition = currentWeekStartPosition + widget.itemWidth;
    
    // 判断当前周是否在可视范围内
    return currentWeekEndPosition > visibleStartPosition && 
           currentWeekStartPosition < visibleEndPosition;
  }
  
  /// 获取当前年份的周数（用于判断哪些周可以选择）
  int _getCurrentWeekOfYear() {
    final now = DateTime.now();
    final currentYear = now.year;
    
    if (widget.year == null || widget.year == currentYear) {
      // 当前年份，返回当前周数
      return DateUtil.getWeekOfYear(now);
    } else if (widget.year! < currentYear) {
      // 过去的年份，返回该年的最大周数（所有周都可选择）
      return DateUtil.getWeeksInYear(widget.year!);
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
    const horizontalPadding = 16.0;
    
    // 计算目标周在ListView中的起始位置（相对于ListView内容区域）
    // 考虑到ListView.separated的布局：item + spacing + item + spacing...
    final targetItemStartPosition = (week - 1) * (widget.itemWidth + widget.spacing);
    
    // 计算目标项的中心点位置（相对于ListView内容区域）
    final targetItemCenterPosition = targetItemStartPosition + widget.itemWidth / 2;
    
    // 计算屏幕中心点位置（相对于整个屏幕）
    final screenCenterPosition = screenWidth / 2;
    
    // 计算ListView内容区域的中心点位置（考虑padding）
    final listViewCenterPosition = screenCenterPosition - horizontalPadding;
    
    // 计算需要滚动的距离，使目标项的中心点对齐到ListView内容区域的中心点
    final scrollPosition = targetItemCenterPosition - listViewCenterPosition;
    
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
    return week <= _currentWeekOfYear; // 只有当前周及之前的周可选择
  }
  
  /// 获取周项的背景色
  Color _getWeekBackgroundColor(int week) {
    if (week == widget.currentWeek) {
      return widget.selectedColor ?? AppColors.cardBackground;
    } else if (!_isWeekSelectable(week)) {
      return widget.disabledColor ?? AppColors.unselectedBgColor.withValues(alpha: 0.5);
    } else {
      return widget.unselectedColor ?? AppColors.unselectedBgColor;
    }
  }
  
  /// 获取周项的文字颜色
  Color _getWeekTextColor(int week) {
    if (week == widget.currentWeek) {
      return widget.selectedTextColor ?? AppColors.selectedTextColor;
    } else if (!_isWeekSelectable(week)) {
      return widget.disabledTextColor ?? AppColors.unselectedTextColor.withValues(alpha: 0.5);
    } else {
      return widget.unselectedTextColor ?? AppColors.unselectedTextColor;
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
              
              return GestureDetector(
                onTap: isSelectable ? () {
                  // 触发轻微震动
                  HapticFeedback.selectionClick();
                  widget.onWeekSelected(week);
                  _scrollToWeek(week);
                } : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: widget.itemWidth,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: _getWeekBackgroundColor(week),
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected 
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                    boxShadow: isSelected 
                        ? [Shadows.softShadow]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '第$week周',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: _getWeekTextColor(week),
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Text(
                      //   _getWeekDateRange(week),
                      //   style: TextStyle(
                      //     fontSize: 10,
                      //     color: _getWeekTextColor(week),
                      //   ),
                      // ),
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
      left: isCurrentWeekOnLeft ? 16 : null,
      right: isCurrentWeekOnLeft ? null : 16,
      child: Center(
        child: GestureDetector(
          onTap: () {
            // 触发轻微震动
            HapticFeedback.selectionClick();
            widget.onWeekSelected(widget.currentWeek);
            _scrollToWeek(widget.currentWeek);
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