/// 时间格式化工具类
class TimeFormatter {
  /// 格式化记录时间
  /// 根据时间差显示不同的格式：今天、昨天、周几、具体日期
  static String formatRecordTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      // 今天
      return '今天 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      // 昨天
      return '昨天 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      // 一周内
      final weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
      return '${weekdays[dateTime.weekday % 7]} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      // 超过一周
      return '${dateTime.month}月${dateTime.day}日 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
  
  /// 格式化周范围显示
  static String formatWeekRange(int week, int year) {
    // 计算该周的开始和结束日期
    final firstDayOfYear = DateTime(year, 1, 1);
    final firstWeekday = firstDayOfYear.weekday;
    final daysToFirstMonday = (8 - firstWeekday) % 7;
    final firstMonday = firstDayOfYear.add(Duration(days: daysToFirstMonday));
    
    final weekStartDate = firstMonday.add(Duration(days: (week - 1) * 7));
    final weekEndDate = weekStartDate.add(const Duration(days: 6));
    
    return '${weekStartDate.month}月${weekStartDate.day}日 - ${weekEndDate.month}月${weekEndDate.day}日';
  }
  
  /// 格式化简短时间显示
  static String formatShortTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
} 