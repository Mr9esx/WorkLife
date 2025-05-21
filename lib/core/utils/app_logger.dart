import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// 应用日志管理类
/// 使用单例模式确保全局只有一个日志实例
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  late final Logger _logger;

  factory AppLogger() {
    return _instance;
  }

  AppLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // 显示调用栈的方法数量
        errorMethodCount: 8, // 错误时显示调用栈的方法数量
        lineLength: 120, // 每行最大长度
        colors: true, // 彩色输出
        printEmojis: true, // 打印表情
        printTime: true, // 打印时间
      ),
      // 在发布模式下禁用日志
      level: kDebugMode ? Level.debug : Level.off,
    );
  }

  /// 调试日志
  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// 信息日志
  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// 警告日志
  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// 错误日志
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// 严重错误日志
  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

/// 全局日志实例
final appLogger = AppLogger(); 