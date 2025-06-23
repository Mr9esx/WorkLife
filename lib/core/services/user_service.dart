import 'package:drift/drift.dart';
import 'package:WeekLife/data/database/app_database.dart';
import 'package:WeekLife/core/utils/database/database_manager.dart';

/// 用户服务
/// 负责用户相关的业务逻辑
class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final AppDatabase _database = DatabaseManager.instance.database;

  /// 获取当前用户
  Future<JournalWriter?> getCurrentUser() async {
    try {
      final result = await (_database.select(_database.journalWriterTable)
            ..where((t) => t.currentWriter.equals(1))
            ..limit(1))
          .getSingleOrNull();

      return result;
    } catch (e) {
      print('❌ UserService: 获取当前用户失败 - $e');
      return null;
    }
  }

  /// 获取用户ID
  Future<int?> getCurrentUserId() async {
    final user = await getCurrentUser();
    return user?.id;
  }

  /// 设置当前用户
  Future<bool> setCurrentUser(int userId) async {
    try {
      await _database.transaction(() async {
        // 先将所有用户的 currentWriter 设为 0
        await (_database.update(_database.journalWriterTable)..where((t) => t.currentWriter.equals(1)))
            .write(JournalWriterTableCompanion(
          currentWriter: Value(0),
        ));

        // 再将指定用户的 currentWriter 设为 1
        await (_database.update(_database.journalWriterTable)..where((t) => t.id.equals(userId)))
            .write(JournalWriterTableCompanion(
          currentWriter: Value(1),
        ));
      });

      return true;
    } catch (e) {
      print('❌ UserService: 设置当前用户失败 - $e');
      return false;
    }
  }

  /// 创建新用户
  Future<JournalWriter?> createUser({
    required String username,
    int? gender,
    DateTime? birthDay,
    bool setAsCurrent = false,
  }) async {
    try {
      final now = DateTime.now();

      final companion = JournalWriterTableCompanion(
        username: Value(username),
        currentWriter: Value(setAsCurrent ? 1 : 0),
        gender: Value(gender ?? 1),
        birthDay: Value(birthDay ?? now),
        createdAt: Value(now),
      );

      final id = await _database.into(_database.journalWriterTable).insert(companion);

      // 如果设置为当前用户，需要更新其他用户的状态
      if (setAsCurrent) {
        await (_database.update(_database.journalWriterTable)..where((t) => t.id.isNotValue(id)))
            .write(JournalWriterTableCompanion(
          currentWriter: Value(0),
        ));
      }

      // 返回创建的用户
      return await (_database.select(_database.journalWriterTable)..where((t) => t.id.equals(id))).getSingle();
    } catch (e) {
      print('❌ UserService: 创建用户失败 - $e');
      return null;
    }
  }

  /// 获取所有用户
  Future<List<JournalWriter>> getAllUsers() async {
    try {
      return await _database.select(_database.journalWriterTable).get();
    } catch (e) {
      print('❌ UserService: 获取所有用户失败 - $e');
      return [];
    }
  }
}
