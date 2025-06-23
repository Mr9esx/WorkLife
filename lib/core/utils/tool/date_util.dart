/// 日期工具类
/// 提供日期相关的通用方法
class DateUtil {
  DateUtil._();

  /// 获取指定日期是一年中的第几周
  /// 从1月1日开始计算，每7天为一周
  static int getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysDifference = date.difference(firstDayOfYear).inDays;
    
    // 计算是第几周（从第1周开始）
    final weekNumber = (daysDifference / 7).floor() + 1;
    
    // 确保不超过该年的实际周数
    final maxWeeks = getWeeksInYear(date.year);
    return weekNumber.clamp(1, maxWeeks);
  }

  /// 获取当前年份的周数信息
  /// 返回包含周数和年份的记录
  static ({int week, int year}) getCurrentWeekOfYear() {
    final now = DateTime.now();
    return (week: getWeekOfYear(now), year: now.year);
  }

  /// 获取当前年份的周数（仅返回周数）
  /// 用于兼容只需要周数的场景
  static int getCurrentWeekNumber() {
    return getWeekOfYear(DateTime.now());
  }

  /// 获取指定年份的总周数
  /// 基于实际情况计算，从1月1日到12月31日
  static int getWeeksInYear(int year) {
    final firstDayOfYear = DateTime(year, 1, 1);
    final lastDayOfYear = DateTime(year, 12, 31);
    
    // 计算从1月1日到12月31日的天数
    final totalDays = lastDayOfYear.difference(firstDayOfYear).inDays + 1;
    
    // 计算总周数（向上取整，确保包含最后一周）
    final totalWeeks = (totalDays / 7).ceil();
    
    return totalWeeks;
  }

  /// 获取周的日期范围显示文本
  /// 返回格式：MM/dd-MM/dd
  static String getWeekDateRange(int week, int year) {
    // 一年按54周计算，每周7天，从1月1日开始
    final firstDayOfYear = DateTime(year, 1, 1);
    
    // 计算该周的开始日期
    final weekStart = firstDayOfYear.add(Duration(days: (week - 1) * 7));
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    // 确保不超出年份范围
    final lastDayOfYear = DateTime(year, 12, 31);
    final actualWeekEnd = weekEnd.isAfter(lastDayOfYear) ? lastDayOfYear : weekEnd;
    
    return '${weekStart.month}/${weekStart.day}-${actualWeekEnd.month}/${actualWeekEnd.day}';
  }
} 