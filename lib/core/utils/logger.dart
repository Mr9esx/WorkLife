import 'package:flutter/foundation.dart';

/// 日志级别枚举
enum LogLevel {
  debug,
  info,
  warning,
  error,
  none,
}

/// 统一的日志管理器
/// 在生产环境中自动减少日志输出，在开发环境中提供详细日志
class AppLogger {
  static LogLevel _currentLevel = kDebugMode ? LogLevel.debug : LogLevel.error;
  static bool _enableConsoleOutput = kDebugMode;
  static bool _enableFileLogging = false;
  
  /// 设置日志级别
  static void setLevel(LogLevel level) {
    _currentLevel = level;
  }
  
  /// 设置是否启用控制台输出
  static void setConsoleOutput(bool enabled) {
    _enableConsoleOutput = enabled;
  }
  
  /// 设置是否启用文件日志
  static void setFileLogging(bool enabled) {
    _enableFileLogging = enabled;
  }
  
  /// 调试日志
  static void debug(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag, emoji: '🔍');
  }
  
  /// 信息日志
  static void info(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag, emoji: 'ℹ️');
  }
  
  /// 警告日志
  static void warning(String message, {String? tag}) {
    _log(LogLevel.warning, message, tag: tag, emoji: '⚠️');
  }
  
  /// 错误日志
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, emoji: '❌', error: error, stackTrace: stackTrace);
  }
  
  /// 成功日志
  static void success(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag, emoji: '✅');
  }
  
  /// 加载日志
  static void loading(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag, emoji: '🔄');
  }
  
  /// 数据库相关日志
  static void database(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag ?? 'Database', emoji: '🗄️');
  }
  
  /// 网络相关日志
  static void network(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag ?? 'Network', emoji: '🌐');
  }
  
  /// 性能相关日志
  static void performance(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag ?? 'Performance', emoji: '⚡');
  }
  
  /// 用户操作日志
  static void userAction(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag ?? 'UserAction', emoji: '👆');
  }
  
  /// 内部日志方法
  static void _log(
    LogLevel level, 
    String message, {
    String? tag,
    String? emoji,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // 检查日志级别
    if (!_shouldLog(level)) return;
    
    // 构建日志消息
    final timestamp = DateTime.now().toIso8601String();
    final levelName = level.name.toUpperCase();
    final tagStr = tag != null ? '[$tag] ' : '';
    final emojiStr = emoji != null ? '$emoji ' : '';
    
    final logMessage = '$timestamp [$levelName] $tagStr$emojiStr$message';
    
    // 输出到控制台
    if (_enableConsoleOutput) {
      if (kDebugMode) {
        debugPrint(logMessage);
      } else {
        print(logMessage);
      }
      
      // 如果有错误信息，也输出错误和堆栈
      if (error != null) {
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }
    
    // TODO: 实现文件日志功能
    if (_enableFileLogging) {
      _writeToFile(logMessage, error, stackTrace);
    }
  }
  
  /// 检查是否应该输出日志
  static bool _shouldLog(LogLevel level) {
    if (_currentLevel == LogLevel.none) return false;
    return level.index >= _currentLevel.index;
  }
  
  /// 写入文件（待实现）
  static void _writeToFile(String message, Object? error, StackTrace? stackTrace) {
    // TODO: 实现文件日志功能
    // 可以使用 path_provider 和 dart:io 来实现文件写入
  }
  
  /// 获取当前日志级别
  static LogLevel getCurrentLevel() => _currentLevel;
  
  /// 检查是否启用了特定级别的日志
  static bool isLevelEnabled(LogLevel level) => _shouldLog(level);
  
  /// 临时禁用日志（用于性能敏感的操作）
  static void temporaryDisable() {
    _enableConsoleOutput = false;
  }
  
  /// 重新启用日志
  static void reEnable() {
    _enableConsoleOutput = kDebugMode;
  }
}

/// 日志工具扩展方法
extension LoggerExtension on String {
  /// 快速调试日志
  void logDebug({String? tag}) => AppLogger.debug(this, tag: tag);
  
  /// 快速信息日志
  void logInfo({String? tag}) => AppLogger.info(this, tag: tag);
  
  /// 快速警告日志
  void logWarning({String? tag}) => AppLogger.warning(this, tag: tag);
  
  /// 快速错误日志
  void logError({String? tag, Object? error, StackTrace? stackTrace}) => 
      AppLogger.error(this, tag: tag, error: error, stackTrace: stackTrace);
  
  /// 快速成功日志
  void logSuccess({String? tag}) => AppLogger.success(this, tag: tag);
} 