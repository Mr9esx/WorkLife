// 导入必要的包
import 'dart:io'; // Dart 标准库，提供文件操作功能
import 'package:drift/drift.dart'; // Drift 数据库核心包
import 'package:drift/native.dart'; // Drift 的本地数据库实现
import 'package:path_provider/path_provider.dart'; // 获取应用目录路径
import 'package:WeekLife/data/database/app_database.dart'; // 统一数据库类

/// 数据库管理类
/// 用于统一管理数据库连接
class DatabaseManager {
  // 静态变量，用于存储单例实例
  static DatabaseManager? _instance; // ? 表示可空类型，Dart 的空安全特性
  static AppDatabase? _database; // 存储统一数据库实例
  static bool _isInitialized = false; // 添加初始化状态标志

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
      print('🚀 DatabaseManager: 开始初始化数据库...');

      // 获取应用文档目录
      final dbPath = await getApplicationDocumentsDirectory();
      print('📁 数据库路径: ${dbPath.path}/worklife.db');

      // 创建数据库文件
      final file = File('${dbPath.path}/worklife.db');
      print('📄 数据库文件存在: ${file.existsSync()}');

      // 创建数据库连接
      final db = LazyDatabase(() async => NativeDatabase(file));

      // 初始化统一数据库
      _database = AppDatabase(db);
      print('🗄️ AppDatabase 实例已创建，版本: ${_database!.schemaVersion}');

      // 触发数据库连接以确保表被创建
      await _database!.customSelect('SELECT 1').get();
      print('🔗 数据库连接已建立');

      _isInitialized = true;
      print('✅ DatabaseManager: 数据库初始化完成');
    } catch (e) {
      print('❌ 数据库初始化失败: $e');
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

  /// 获取数据库实例
  AppDatabase get database {
    if (!_isInitialized) {
      throw StateError('数据库未初始化，请先调用 DatabaseManager.initialize()');
    }
    return _database!;
  }

  /// 获取数据库初始化状态
  static bool get isInitialized => _isInitialized;

  /// 关闭数据库连接
  Future<void> close() async {
    await _database?.close();
    _database = null;
    _isInitialized = false;
  }
}
