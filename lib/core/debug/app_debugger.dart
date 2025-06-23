import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:WeekLife/core/utils/database/database_manager.dart';
import 'package:WeekLife/core/utils/app_logger.dart';

/// 应用调试器
/// 提供各种调试信息的输出和收集功能
class AppDebugger {
  static const String _tag = 'AppDebugger';
  static final _logger = AppLogger();

  /// 私有构造函数，确保单例
  AppDebugger._();

  /// 单例实例
  static final AppDebugger _instance = AppDebugger._();
  static AppDebugger get instance => _instance;

  /// 输出所有调试信息
  static Future<void> printAllDebugInfo() async {
    _logger.d('=== 🐛 应用调试信息 ===');

    await _printSeparator('📱 设备信息');
    await printDeviceInfo();

    await _printSeparator('📦 应用信息');
    await printAppInfo();

    await _printSeparator('🗂️ 文件系统信息');
    await printFileSystemInfo();

    await _printSeparator('🗄️ 数据库信息');
    await printDatabaseInfo();

    await _printSeparator('💾 存储信息');
    await printStorageInfo();

    await _printSeparator('🔧 Flutter 环境信息');
    await printFlutterInfo();

    await _printSeparator('📊 内存信息');
    await printMemoryInfo();

    _logger.d('=== 🐛 调试信息输出完成 ===');
  }

  /// 输出设备信息
  static Future<void> printDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _logger.d('🤖 Android 设备信息:');
        _logger.d('  - 设备型号: ${androidInfo.model}');
        _logger.d('  - 制造商: ${androidInfo.manufacturer}');
        _logger.d('  - 品牌: ${androidInfo.brand}');
        _logger.d('  - Android 版本: ${androidInfo.version.release}');
        _logger.d('  - SDK 版本: ${androidInfo.version.sdkInt}');
        _logger.d('  - 设备 ID: ${androidInfo.id}');
        _logger.d('  - 硬件: ${androidInfo.hardware}');
        _logger.d('  - 支持的 ABI: ${androidInfo.supportedAbis}');
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _logger.d('🍎 iOS 设备信息:');
        _logger.d('  - 设备型号: ${iosInfo.model}');
        _logger.d('  - 设备名称: ${iosInfo.name}');
        _logger.d('  - 系统版本: ${iosInfo.systemVersion}');
        _logger.d('  - 设备 ID: ${iosInfo.identifierForVendor}');
        _logger.d('  - 是否物理设备: ${iosInfo.isPhysicalDevice}');
        _logger.d('  - 本地化标识: ${iosInfo.localizedModel}');
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        _logger.d('💻 macOS 设备信息:');
        _logger.d('  - 计算机名: ${macInfo.computerName}');
        _logger.d('  - 主机名: ${macInfo.hostName}');
        _logger.d('  - 系统版本: ${macInfo.osRelease}');
        _logger.d('  - 内核版本: ${macInfo.kernelVersion}');
        _logger.d('  - CPU 架构: ${macInfo.arch}');
        _logger.d('  - 内存大小: ${macInfo.memorySize} bytes');
      }
    } catch (e) {
      _logger.e('获取设备信息失败: $e');
    }
  }

  /// 输出应用信息
  static Future<void> printAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _logger.d('📱 应用信息:');
      _logger.d('  - 应用名称: ${packageInfo.appName}');
      _logger.d('  - 包名: ${packageInfo.packageName}');
      _logger.d('  - 版本号: ${packageInfo.version}');
      _logger.d('  - 构建号: ${packageInfo.buildNumber}');
      _logger.d('  - 构建签名: ${packageInfo.buildSignature}');
      _logger.d('  - 安装来源: ${packageInfo.installerStore ?? "未知"}');
    } catch (e) {
      _logger.e('获取应用信息失败: $e');
    }
  }

  /// 输出文件系统信息
  static Future<void> printFileSystemInfo() async {
    try {
      _logger.d('📁 文件系统路径:');

      // 应用文档目录
      final documentsDir = await getApplicationDocumentsDirectory();
      _logger.d('  - 文档目录: ${documentsDir.path}');

      // 应用支持目录
      final supportDir = await getApplicationSupportDirectory();
      _logger.d('  - 支持目录: ${supportDir.path}');

      // 临时目录
      final tempDir = await getTemporaryDirectory();
      _logger.d('  - 临时目录: ${tempDir.path}');

      // 缓存目录 (仅 Android)
      if (Platform.isAndroid) {
        final cacheDir = await getApplicationCacheDirectory();
        _logger.d('  - 缓存目录: ${cacheDir.path}');
      }

      // 外部存储目录 (仅 Android)
      if (Platform.isAndroid) {
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          _logger.d('  - 外部存储: ${externalDir.path}');
        }
      }

      // 下载目录 (仅 Android)
      if (Platform.isAndroid) {
        try {
          final downloadsDir = await getDownloadsDirectory();
          if (downloadsDir != null) {
            _logger.d('  - 下载目录: ${downloadsDir.path}');
          }
        } catch (e) {
          _logger.d('  - 下载目录: 不可用');
        }
      }
    } catch (e) {
      _logger.e('获取文件系统信息失败: $e');
    }
  }

  /// 输出数据库信息
  static Future<void> printDatabaseInfo() async {
    try {
      _logger.d('🗄️ 数据库信息:');

      // 获取数据库路径
      final dbPath = await _getDatabasePath();
      _logger.d('  - 数据库类型: SQLite (Drift)');
      _logger.d('  - 数据库路径: $dbPath');

      // 检查数据库文件是否存在
      final dbFile = File(dbPath);
      final exists = await dbFile.exists();
      _logger.d('  - 数据库文件存在: $exists');

      if (exists) {
        final stat = await dbFile.stat();
        _logger.d('  - 数据库文件大小: ${_formatBytes(stat.size)}');
        _logger.d('  - 最后修改时间: ${stat.modified}');
      } else {
        _logger.d('  - 数据库文件不存在，可能尚未初始化');
      }

      // 数据库管理器信息
      try {
        _logger.d('  - 数据库管理器初始化状态: ${DatabaseManager.isInitialized}');
      } catch (e) {
        _logger.d('  - 无法获取数据库管理器状态');
      }

      // 数据库版本和记录信息
      try {
        // 先检查数据库是否已初始化
        if (!exists) {
          _logger.d('  - 尝试初始化数据库...');
          await DatabaseManager.initialize();

          // 重新检查文件是否存在
          final newExists = await dbFile.exists();
          _logger.d('  - 初始化后数据库文件存在: $newExists');
        }

        final dbManager = DatabaseManager.instance;
        final database = dbManager.database;
        _logger.d('  - 数据库版本: ${database.schemaVersion}');

        // 获取表中的记录数
        final writerCount = await database.select(database.journalWriterTable).get();
        _logger.d('  - Writer 记录数: ${writerCount.length}');
      } catch (e) {
        _logger.d('  - 数据库查询失败: $e');
        _logger.d('  - 提示: 请确保在应用启动时调用了 DatabaseManager.initialize()');
      }
    } catch (e) {
      _logger.e('获取数据库信息失败: $e');
    }
  }

  /// 获取数据库路径
  static Future<String> _getDatabasePath() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      return path.join(documentsDir.path, 'worklife.db');
    } catch (e) {
      return '无法获取数据库路径: $e';
    }
  }

  /// 输出存储信息
  static Future<void> printStorageInfo() async {
    try {
      _logger.d('💾 存储空间信息:');

      // 获取各个目录的大小
      final documentsDir = await getApplicationDocumentsDirectory();
      final supportDir = await getApplicationSupportDirectory();
      final tempDir = await getTemporaryDirectory();

      final docsSize = await _getDirectorySize(documentsDir);
      final supportSize = await _getDirectorySize(supportDir);
      final tempSize = await _getDirectorySize(tempDir);

      _logger.d('  - 文档目录大小: ${_formatBytes(docsSize)}');
      _logger.d('  - 支持目录大小: ${_formatBytes(supportSize)}');
      _logger.d('  - 临时目录大小: ${_formatBytes(tempSize)}');

      final totalSize = docsSize + supportSize + tempSize;
      _logger.d('  - 应用总占用: ${_formatBytes(totalSize)}');
    } catch (e) {
      _logger.e('获取存储信息失败: $e');
    }
  }

  /// 输出 Flutter 环境信息
  static Future<void> printFlutterInfo() async {
    _logger.d('🔧 Flutter 环境信息:');
    _logger.d('  - 调试模式: $kDebugMode');
    _logger.d('  - 发布模式: $kReleaseMode');
    _logger.d('  - Profile 模式: $kProfileMode');
    _logger.d('  - Web 平台: $kIsWeb');
    _logger.d('  - 平台: ${Platform.operatingSystem}');
    _logger.d('  - 平台版本: ${Platform.operatingSystemVersion}');
    _logger.d('  - Dart 版本: ${Platform.version}');
    _logger.d('  - 处理器数量: ${Platform.numberOfProcessors}');
    _logger.d('  - 本地主机名: ${Platform.localHostname}');
    _logger.d('  - 环境变量 PATH: ${Platform.environment['PATH']?.substring(0, 100) ?? "未设置"}...');
  }

  /// 输出内存信息
  static Future<void> printMemoryInfo() async {
    try {
      _logger.d('📊 内存信息:');

      // 获取系统内存信息 (仅限部分平台)
      if (Platform.isLinux || Platform.isMacOS) {
        final result = await Process.run('free', ['-h']);
        if (result.exitCode == 0) {
          _logger.d('  - 系统内存信息:\n${result.stdout}');
        }
      }

      // Dart VM 内存信息
      _logger.d('  - Dart VM 信息:');
      _logger.d('    - 当前 RSS: ${ProcessInfo.currentRss ~/ 1024 ~/ 1024} MB');
      _logger.d('    - 最大 RSS: ${ProcessInfo.maxRss ~/ 1024 ~/ 1024} MB');
    } catch (e) {
      _logger.e('获取内存信息失败: $e');
    }
  }

  /// 输出网络信息
  static Future<void> printNetworkInfo() async {
    try {
      _logger.d('🌐 网络信息:');

      // 检查网络连接
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _logger.d('  - 网络连接: 正常');
        _logger.d('  - DNS 解析: 正常');
      }
    } catch (e) {
      _logger.d('  - 网络连接: 异常 ($e)');
    }
  }

  /// 清理调试数据
  static Future<void> clearDebugData() async {
    try {
      _logger.d('🧹 清理调试数据...');

      // 清理临时目录
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
        await tempDir.create();
        _logger.d('  - 已清理临时目录');
      }

      // 清理缓存目录 (仅 Android)
      if (Platform.isAndroid) {
        final cacheDir = await getApplicationCacheDirectory();
        if (await cacheDir.exists()) {
          await cacheDir.delete(recursive: true);
          await cacheDir.create();
          _logger.d('  - 已清理缓存目录');
        }
      }

      _logger.d('✅ 调试数据清理完成');
    } catch (e) {
      _logger.e('清理调试数据失败: $e');
    }
  }

  /// 导出调试日志
  static Future<String?> exportDebugLog() async {
    try {
      _logger.d('📤 导出调试日志...');

      final documentsDir = await getApplicationDocumentsDirectory();
      final logFile = File(path.join(documentsDir.path, 'debug_log_${DateTime.now().millisecondsSinceEpoch}.txt'));

      final buffer = StringBuffer();
      buffer.writeln('=== WeekLife 调试日志 ===');
      buffer.writeln('导出时间: ${DateTime.now()}');
      buffer.writeln('');

      // 这里可以添加更多的日志内容
      buffer.writeln('调试信息已导出到此文件');

      await logFile.writeAsString(buffer.toString());

      _logger.d('✅ 调试日志已导出: ${logFile.path}');
      return logFile.path;
    } catch (e) {
      _logger.e('导出调试日志失败: $e');
      return null;
    }
  }

  /// 复制调试信息到剪贴板
  static Future<void> copyDebugInfoToClipboard() async {
    try {
      final buffer = StringBuffer();
      buffer.writeln('=== WeekLife 调试信息 ===');
      buffer.writeln('时间: ${DateTime.now()}');
      buffer.writeln('平台: ${Platform.operatingSystem}');
      buffer.writeln('调试模式: $kDebugMode');

      // 获取数据库路径
      final dbPath = await _getDatabasePath();
      buffer.writeln('数据库路径: $dbPath');

      await Clipboard.setData(ClipboardData(text: buffer.toString()));
      _logger.d('✅ 调试信息已复制到剪贴板');
    } catch (e) {
      _logger.e('复制调试信息失败: $e');
    }
  }

  /// 获取目录大小
  static Future<int> _getDirectorySize(Directory directory) async {
    int size = 0;
    try {
      if (await directory.exists()) {
        await for (final entity in directory.list(recursive: true)) {
          if (entity is File) {
            final stat = await entity.stat();
            size += stat.size;
          }
        }
      }
    } catch (e) {
      _logger.e('计算目录大小失败: $e');
    }
    return size;
  }

  /// 格式化字节大小
  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// 输出分隔符
  static Future<void> _printSeparator(String title) async {
    _logger.d('');
    _logger.d('─── $title ───');
  }
}
