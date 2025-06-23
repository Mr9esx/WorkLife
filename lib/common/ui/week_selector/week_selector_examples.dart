import 'package:flutter/material.dart';
import 'package:WeekLife/common/ui/week_selector/week_selector.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/core/utils/index.dart';

/// WeekSelector 使用示例
/// 展示不同场景下的配置方式
class WeekSelectorExamples {
  
  /// 示例1：当前年份的周选择器（默认配置）
  /// 适用于当前年份，未来周份会显示为灰色不可选
  static Widget currentYearWeekSelector({
    required int currentWeek,
    required Function(int week) onWeekSelected,
  }) {
    return WeekSelector(
      currentWeek: currentWeek,
      onWeekSelected: onWeekSelected,
    );
  }

  /// 示例2：历史年份的周选择器
  /// 适用于查看历史年份，所有周份都可选择
  static Widget historicalYearWeekSelector({
    required int year,
    required int currentWeek,
    required Function(int week) onWeekSelected,
  }) {
    return WeekSelector(
      currentWeek: currentWeek,
      onWeekSelected: onWeekSelected,
      year: year,
      isYearCompleted: true, // 历史年份已完成
    );
  }

  /// 示例3：自定义样式的周选择器
  /// 自定义颜色和尺寸
  static Widget customStyledWeekSelector({
    required int currentWeek,
    required Function(int week) onWeekSelected,
  }) {
    return WeekSelector(
      currentWeek: currentWeek,
      onWeekSelected: onWeekSelected,
      height: 70,
      itemWidth: 60,
      spacing: 12,
      selectedColor: Colors.blue[100],
      unselectedColor: Colors.grey[100],
      disabledColor: Colors.grey[50],
      selectedTextColor: Colors.blue[800],
      unselectedTextColor: Colors.grey[600],
      disabledTextColor: Colors.grey[400],
    );
  }

  /// 示例4：紧凑型周选择器
  /// 适用于空间有限的场景
  static Widget compactWeekSelector({
    required int currentWeek,
    required Function(int week) onWeekSelected,
  }) {
    return WeekSelector(
      currentWeek: currentWeek,
      onWeekSelected: onWeekSelected,
      height: 35,
      itemWidth: 35,
    );
  }

  /// 示例5：完整的页面示例
  /// 展示如何在实际页面中使用周选择器
  static Widget fullPageExample() {
    return _WeekSelectorDemoPage();
  }
}

/// 周选择器演示页面
class _WeekSelectorDemoPage extends StatefulWidget {
  @override
  State<_WeekSelectorDemoPage> createState() => _WeekSelectorDemoPageState();
}

class _WeekSelectorDemoPageState extends State<_WeekSelectorDemoPage> {
  int _selectedWeek = 1;
  int _selectedYear = DateTime.now().year;
  
  @override
  void initState() {
    super.initState();
    // 初始化为当前周
    _selectedWeek = DateUtil.getCurrentWeekNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('周选择器示例'),
        backgroundColor: AppColors.appBackground,
      ),
      backgroundColor: AppColors.appBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 年份选择
            Card(
              color: AppColors.cardBackground,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '选择年份',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        for (int year = DateTime.now().year - 2; 
                             year <= DateTime.now().year + 1; 
                             year++)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text('$year'),
                              selected: _selectedYear == year,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedYear = year;
                                    _selectedWeek = 1; // 重置为第1周
                                  });
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 当前选择信息
            Card(
              color: AppColors.cardBackground,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '当前选择',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_selectedYear年 第$_selectedWeek周',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 周选择器
            const Text(
              '选择周份',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            WeekSelector(
              currentWeek: _selectedWeek,
              year: _selectedYear,
              isYearCompleted: _selectedYear < DateTime.now().year,
              onWeekSelected: (week) {
                setState(() {
                  _selectedWeek = week;
                });
                
                // 显示选择反馈
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('已选择 $_selectedYear年 第$week周'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // 使用说明
            Card(
              color: AppColors.cardBackground,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '使用说明',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('• 一年固定显示54周（从1月1日开始计算）'),
                    const Text('• 左右滑动可以浏览所有周份'),
                    const Text('• 当前周会自动居中显示'),
                    const Text('• 未来周份显示为灰色且不可选择'),
                    const Text('• 历史年份的所有周份都可选择'),
                    const Text('• 点击周份可以进行选择'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 