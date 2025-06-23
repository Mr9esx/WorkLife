import 'package:WeekLife/core/utils/index.dart';

/// 周份工具类
class WeekUtils {
  /// 判断是否是未来的周份
  static bool isFutureWeek(int week, int year) {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentWeek = DateUtil.getWeekOfYear(now);

    if (year > currentYear) {
      return true; // 未来年份
    } else if (year == currentYear && week > currentWeek) {
      return true; // 当前年份的未来周
    }
    return false;
  }

  /// 判断是否是当前周
  static bool isCurrentWeek(int week, int year) {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentWeek = DateUtil.getWeekOfYear(now);

    return year == currentYear && week == currentWeek;
  }

  /// 判断是否是过去的周份
  static bool isPastWeek(int week, int year) {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentWeek = DateUtil.getWeekOfYear(now);

    if (year < currentYear) {
      return true; // 过去年份
    } else if (year == currentYear && week < currentWeek) {
      return true; // 当前年份的过去周
    }
    return false;
  }

  /// 获取周显示文本
  static String getWeekDisplayText(int week, int year) {
    if (isFutureWeek(week, year)) {
      return '第$week周 (未来)';
    } else if (isCurrentWeek(week, year)) {
      return '第$week周 (本周)';
    } else {
      return '第$week周';
    }
  }

  /// 获取周状态描述
  static String getWeekStatusDescription(int week, int year) {
    if (isFutureWeek(week, year)) {
      return '第$week周的计划和待办事项';
    } else if (isCurrentWeek(week, year)) {
      return '本周的任务和完成情况';
    } else {
      return '第$week周的记录和回顾';
    }
  }

  /// 计算两个周之间的差值
  static int getWeekDifference(int week1, int year1, int week2, int year2) {
    // 简化计算，假设每年52周
    final totalWeeks1 = year1 * 52 + week1;
    final totalWeeks2 = year2 * 52 + week2;
    return totalWeeks2 - totalWeeks1;
  }
}
