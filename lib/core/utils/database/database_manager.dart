// 导入必要的包
import 'dart:io';  // Dart 标准库，提供文件操作功能
import 'package:drift/drift.dart';  // Drift 数据库核心包
import 'package:drift/native.dart';  // Drift 的本地数据库实现
import 'package:path_provider/path_provider.dart';  // 获取应用目录路径
import 'package:WeekLife/data/repositories/journal_writer/journal_writer_repo.dart';  // 自定义的数据库仓库类

/// 数据库管理类
/// 用于统一管理数据库连接
class DatabaseManager {
  // 静态变量，用于存储单例实例
  static DatabaseManager? _instance;  // ? 表示可空类型，Dart 的空安全特性
  static JournalWriterRepo? _writerRepo;     // 存储数据库仓库实例
  static bool _isInitialized = false;  // 添加初始化状态标志

  /// 私有构造函数，防止外部直接创建类的实例，确保整个应用中只有一个 DatabaseManager 实例， 通过 instance getter 统一管理实例的创建和访问
  // _ 开头的构造函数表示私有，只能在类内部使用
  DatabaseManager._();

  /// 获取单例实例
  static DatabaseManager get instance {
    _instance ??= DatabaseManager._();
    return _instance!;
  }

  /// 初始化数据库
  /// 这个方法应该在应用启动时调用
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // 获取应用文档目录
      final dbPath = await getApplicationDocumentsDirectory();
      // 创建数据库文件
      final file = File('${dbPath.path}/worklife.db');
      // 创建数据库连接
      final db = LazyDatabase(() async => NativeDatabase(file));
      // 初始化 WriterRepo
      _writerRepo = JournalWriterRepo(db);
      _isInitialized = true;
    } catch (e) {
      print('数据库初始化失败: $e');
      rethrow;
    }
  }

  /// 获取数据库连接
  static LazyDatabase openConnection() {
    return LazyDatabase(() async {
      final dbPath = await getApplicationDocumentsDirectory();
      final file = File('${dbPath.path}/worklife.db');
      return NativeDatabase(file);
    });
  }

  /// 获取 WriterRepo 实例
  JournalWriterRepo get writerRepo {
    if (!_isInitialized) {
      throw StateError('数据库未初始化，请先调用 DatabaseManager.initialize()');
    }
    return _writerRepo!;
  }

  /// 关闭数据库连接
  Future<void> close() async {
    await _writerRepo?.close();
    _writerRepo = null;
    _isInitialized = false;
  }
}