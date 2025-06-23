import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:WeekLife/core/utils/database/database_manager.dart';
import 'package:WeekLife/core/utils/app_logger.dart';

/// 数据库调试助手
/// 专门用于诊断数据库配置和连接问题
class DatabaseDebugHelper {
  static final _logger = AppLogger();

  /// 完整的数据库诊断
  static Future<void> runFullDiagnosis() async {
    _logger.d('🔍 开始数据库完整诊断...');

    await _checkDirectories();
    await _checkDatabaseFile();
    await _checkDatabaseManager();
    await _testDatabaseOperations();

    _logger.d('✅ 数据库诊断完成');
  }

  /// 检查目录结构
  static Future<void> _checkDirectories() async {
    _logger.d('📁 检查目录结构:');

    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      _logger.d('  - 文档目录: ${documentsDir.path}');
      _logger.d('  - 文档目录存在: ${await documentsDir.exists()}');

      final supportDir = await getApplicationSupportDirectory();
      _logger.d('  - 支持目录: ${supportDir.path}');
      _logger.d('  - 支持目录存在: ${await supportDir.exists()}');

      // 列出文档目录中的所有文件
      if (await documentsDir.exists()) {
        final files = await documentsDir.list().toList();
        _logger.d('  - 文档目录文件数量: ${files.length}');
        for (final file in files) {
          if (file is File) {
            final stat = await file.stat();
            _logger.d('    * ${path.basename(file.path)} (${stat.size} bytes)');
          } else if (file is Directory) {
            _logger.d('    * ${path.basename(file.path)}/ (目录)');
          }
        }
      }
    } catch (e) {
      _logger.e('检查目录结构失败: $e');
    }
  }

  /// 检查数据库文件
  static Future<void> _checkDatabaseFile() async {
    _logger.d('🗄️ 检查数据库文件:');

    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final dbPath = path.join(documentsDir.path, 'worklife.db');
      final dbFile = File(dbPath);

      _logger.d('  - 预期数据库路径: $dbPath');
      _logger.d('  - 数据库文件存在: ${await dbFile.exists()}');

      if (await dbFile.exists()) {
        final stat = await dbFile.stat();
        _logger.d('  - 文件大小: ${stat.size} bytes');
        _logger.d('  - 创建时间: ${stat.changed}');
        _logger.d('  - 修改时间: ${stat.modified}');
        _logger.d('  - 访问时间: ${stat.accessed}');
        _logger.d('  - 文件权限: ${stat.mode.toRadixString(8)}');
      } else {
        _logger.d('  - 数据库文件不存在，这可能是正常的（首次运行）');

        // 尝试创建一个测试文件来验证目录权限
        try {
          final testFile = File(path.join(documentsDir.path, 'test_write.tmp'));
          await testFile.writeAsString('test');
          await testFile.delete();
          _logger.d('  - 目录写入权限: 正常');
        } catch (e) {
          _logger.e('  - 目录写入权限: 异常 ($e)');
        }
      }
    } catch (e) {
      _logger.e('检查数据库文件失败: $e');
    }
  }

  /// 检查数据库管理器
  static Future<void> _checkDatabaseManager() async {
    _logger.d('⚙️ 检查数据库管理器:');

    try {
      _logger.d('  - 初始化状态: ${DatabaseManager.isInitialized}');

      if (!DatabaseManager.isInitialized) {
        _logger.d('  - 尝试初始化数据库管理器...');
        await DatabaseManager.initialize();
        _logger.d('  - 初始化后状态: ${DatabaseManager.isInitialized}');
      }

      if (DatabaseManager.isInitialized) {
        final dbManager = DatabaseManager.instance;
        _logger.d('  - 数据库管理器实例: 已创建');

        try {
          final database = dbManager.database;
          _logger.d('  - Database 实例: 已创建');
          _logger.d('  - Schema 版本: ${database.schemaVersion}');
        } catch (e) {
          _logger.e('  - 获取 Database 失败: $e');
        }
      }
    } catch (e) {
      _logger.e('检查数据库管理器失败: $e');
    }
  }

  /// 测试数据库操作
  static Future<void> _testDatabaseOperations() async {
    _logger.d('🧪 测试数据库操作:');

    try {
      if (!DatabaseManager.isInitialized) {
        _logger.d('  - 数据库未初始化，跳过操作测试');
        return;
      }

      final dbManager = DatabaseManager.instance;
      final database = dbManager.database;

      // 测试查询操作
      try {
        final writers = await database.select(database.journalWriterTable).get();
        final count = writers.length;
        _logger.d('  - Writer 记录数查询: 成功 ($count 条记录)');
      } catch (e) {
        _logger.e('  - Writer 记录数查询: 失败 ($e)');
      }

      // 测试获取所有记录
      try {
        final writers = await database.select(database.journalWriterTable).get();
        _logger.d('  - 获取所有 Writer: 成功 (${writers.length} 条记录)');

        for (int i = 0; i < writers.length && i < 3; i++) {
          final writer = writers[i];
          _logger.d('    * Writer ${i + 1}: ${writer.username} (ID: ${writer.id})');
        }

        if (writers.length > 3) {
          _logger.d('    * ... 还有 ${writers.length - 3} 条记录');
        }
      } catch (e) {
        _logger.e('  - 获取所有 Writer: 失败 ($e)');
      }
    } catch (e) {
      _logger.e('测试数据库操作失败: $e');
    }
  }

  /// 强制创建数据库文件
  static Future<void> forceCreateDatabase() async {
    _logger.d('🔨 强制创建数据库文件...');

    try {
      // 确保数据库管理器已初始化
      if (!DatabaseManager.isInitialized) {
        await DatabaseManager.initialize();
      }

      final dbManager = DatabaseManager.instance;
      final database = dbManager.database;

      // 执行一个简单的查询来触发数据库文件创建
      try {
        await database.select(database.journalWriterTable).get();
        _logger.d('  - 数据库文件创建: 成功');
      } catch (e) {
        _logger.e('  - 数据库文件创建: 失败 ($e)');
      }

      // 再次检查文件是否存在
      final documentsDir = await getApplicationDocumentsDirectory();
      final dbPath = path.join(documentsDir.path, 'worklife.db');
      final dbFile = File(dbPath);

      _logger.d('  - 创建后文件存在: ${await dbFile.exists()}');
    } catch (e) {
      _logger.e('强制创建数据库失败: $e');
    }
  }

  /// 清理数据库文件（用于测试）
  static Future<void> cleanDatabase() async {
    _logger.d('🧹 清理数据库文件...');

    try {
      // 先关闭数据库连接
      final dbManager = DatabaseManager.instance;
      await dbManager.close();

      // 删除数据库文件
      final documentsDir = await getApplicationDocumentsDirectory();
      final dbPath = path.join(documentsDir.path, 'worklife.db');
      final dbFile = File(dbPath);

      if (await dbFile.exists()) {
        await dbFile.delete();
        _logger.d('  - 数据库文件已删除');
      } else {
        _logger.d('  - 数据库文件不存在，无需删除');
      }
    } catch (e) {
      _logger.e('清理数据库失败: $e');
    }
  }

  /// 重建数据库
  static Future<void> rebuildDatabase() async {
    _logger.d('🔄 重建数据库...');

    await cleanDatabase();
    await DatabaseManager.initialize();
    await forceCreateDatabase();

    _logger.d('✅ 数据库重建完成');
  }
}
