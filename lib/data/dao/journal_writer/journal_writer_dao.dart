import 'package:WeekLife/data/models/journal_writer/journal_writer_data.dart';
import 'package:WeekLife/common/validators/writer_validator.dart';
import 'package:WeekLife/common/exceptions/writer_exceptions.dart';
import 'package:WeekLife/data/dao/journal_writer/interfaces/journal_writer_dao_interface.dart';
import 'package:WeekLife/data/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

/// Writer 数据访问对象
/// 提供 Writer 表的所有数据库操作方法
class JournalWriterDao implements IJournalWriterDao {
  final AppDatabase _db;

  JournalWriterDao(AppDatabase db) : _db = db;

  /// 创建新的 Writer
  @override
  Future<int> createWriter({
    required String username,
    required int currentWriter,
    required int gender,
    required DateTime birthDay,
    String? avatar,
    String? birthPlace,
  }) async {
    try {
      // 验证数据
      _validateWriterData(
        username: username,
        gender: gender,
        birthDay: birthDay,
      );

      // 检查用户名是否已存在
      if (await _checkUsernameExists(username)) {
        throw WriterValidationException('用户名已存在');
      }

      // 创建 Writer 记录
      final now = DateTime.now();
      final id = await _db.into(_db.journalWriterTable).insert(
            JournalWriterTableCompanion.insert(
              username: username,
              currentWriter: currentWriter,
              gender: gender,
              birthDay: birthDay,
              avatar: Value(avatar),
              birthPlace: Value(birthPlace),
              createdAt: Value(now),
            ),
          );
      return id;
    } on WriterValidationException {
      rethrow;
    } catch (e) {
      throw WriterDatabaseException('创建作家失败: $e');
    }
  }

  /// 设置当前 Writer
  @override
  Future<Error> setCurrentWriter(int id) async {
    try {
      // 检查目标用户是否存在
      final targetWriter = await getWriterById(id);
      if (targetWriter == null) {
        throw WriterValidationException('作家不存在');
      }

      // 如果目标用户已经是当前用户，直接返回
      if (targetWriter.currentWriter == 1) {
        return Error();
      }

      // 先找到当前用户并将其设置为 0
      try {
        final currentWriter = await getCurrentWriter();
        if (currentWriter.id != null) {
          await updateWriter(currentWriter.id!, {'currentWriter': 0});
        }
      } catch (e) {
        // 如果没有找到当前用户，忽略错误继续执行
      }

      // 设置指定用户为当前用户
      await updateWriter(id, {'currentWriter': 1});
      return Error();
    } catch (e) {
      throw WriterDatabaseException('设置当前作家失败: $e');
    }
  }

  /// 获取当前 Writer
  @override
  Future<JournalWriterData> getCurrentWriter() async {
    try {
      final writers = await (_db.select(_db.journalWriterTable)..where((t) => t.currentWriter.equals(1))).get();

      if (writers.isEmpty) {
        // 检查数据库是否为空
        final writerCount = await getWriterCount();
        if (writerCount > 0) {
          // 数据库不为空但没有当前作家，创建默认作家
          print('⚠️ 数据库中有 $writerCount 个作家，但未找到当前作家，正在创建默认作家...');
          return await _createDefaultWriter();
        } else {
          // 数据库为空，也尝试创建默认作家
          print('⚠️ 数据库为空，正在创建默认作家...');
          return await _createDefaultWriter();
        }
      }
      return _convertToJournalWriterData(writers.first);
    } catch (e) {
      if (e is WriterDatabaseException) {
        rethrow;
      }
      throw WriterDatabaseException('获取当前作家失败: $e');
    }
  }

  /// 在开发模式下创建默认作家
  ///
  /// 仅在开发模式下可用，用于重试时创建默认作家
  /// 返回创建的默认作家数据
  Future<JournalWriterData> createDefaultWriterInDevMode() async {
    if (!kDebugMode) {
      throw WriterDatabaseException('此方法仅在开发模式下可用');
    }

    try {
      // 检查是否已存在当前作家
      try {
        final currentWriter = await getCurrentWriter();
        return currentWriter;
      } catch (e) {
        // 如果没有找到当前作家，继续创建
      }

      // 创建默认作家
      final defaultWriter = await createWriter(
        username: '默认作家',
        currentWriter: 1,
        gender: 0,
        birthDay: DateTime(2000, 1, 1),
        avatar: null,
        birthPlace: '未知',
      );

      final newWriter = await getWriterById(defaultWriter);
      if (newWriter == null) {
        throw WriterDatabaseException('创建默认作家失败');
      }

      return newWriter;
    } catch (e) {
      throw WriterDatabaseException('创建默认作家失败: $e');
    }
  }

  /// 根据 ID 获取 Writer
  @override
  Future<JournalWriterData?> getWriterById(int id) async {
    try {
      final writers = await (_db.select(_db.journalWriterTable)..where((t) => t.id.equals(id))).get();
      return writers.isEmpty ? null : _convertToJournalWriterData(writers.first);
    } catch (e) {
      throw WriterDatabaseException('获取作家信息失败: $e');
    }
  }

  /// 获取所有 Writer
  @override
  Future<List<JournalWriterData>> getAllWriters({
    int? limit,
    int? offset,
    String? orderBy,
    bool? orderDesc,
  }) async {
    try {
      var query = _db.select(_db.journalWriterTable);

      // 应用排序
      if (orderBy != null) {
        Expression<Object> Function($JournalWriterTableTable) getOrderColumn() {
          switch (orderBy) {
            case 'id':
              return (t) => t.id;
            case 'username':
              return (t) => t.username;
            case 'currentWriter':
              return (t) => t.currentWriter;
            case 'createdAt':
              return (t) => t.createdAt;
            case 'updatedAt':
              return (t) => t.updatedAt;
            default:
              return (t) => t.createdAt;
          }
        }

        final orderColumn = getOrderColumn();
        final orderMode = orderDesc == true ? OrderingMode.desc : OrderingMode.asc;
        query = query
          ..orderBy([
            (t) => orderMode == OrderingMode.desc ? OrderingTerm.desc(orderColumn(t)) : OrderingTerm.asc(orderColumn(t))
          ]);
      }

      // 应用分页
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final writers = await query.get();
      return writers.map(_convertToJournalWriterData).toList();
    } catch (e) {
      throw WriterDatabaseException('获取作家列表失败: $e');
    }
  }

  /// 更新 Writer
  @override
  Future<bool> updateWriter(int id, Map<String, dynamic> updates) async {
    try {
      // 检查 Writer 是否存在
      final writer = await getWriterById(id);
      if (writer == null) {
        throw WriterValidationException('作家不存在');
      }

      // 验证数据
      if (updates.containsKey('username')) {
        final username = updates['username'] as String;
        _validateUsername(username);
        // 检查新用户名是否与其他作家重复
        final existingWriters =
            await (_db.select(_db.journalWriterTable)..where((t) => t.username.equals(username))).get();
        if (existingWriters.isNotEmpty && existingWriters.first.id != id) {
          throw WriterValidationException('用户名已存在');
        }
      }
      if (updates.containsKey('gender')) {
        _validateGender(updates['gender'] as int);
      }
      if (updates.containsKey('birthDay')) {
        _validateBirthDay(updates['birthDay'] as DateTime);
      }

      // 构建更新数据
      final companion = JournalWriterTableCompanion(
        username: updates.containsKey('username') ? Value(updates['username'] as String) : const Value.absent(),
        currentWriter:
            updates.containsKey('currentWriter') ? Value(updates['currentWriter'] as int) : const Value.absent(),
        gender: updates.containsKey('gender') ? Value(updates['gender'] as int) : const Value.absent(),
        birthDay: updates.containsKey('birthDay') ? Value(updates['birthDay'] as DateTime) : const Value.absent(),
        avatar: updates.containsKey('avatar') ? Value(updates['avatar'] as String?) : const Value.absent(),
        birthPlace: updates.containsKey('birthPlace') ? Value(updates['birthPlace'] as String?) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      );

      final result = await (_db.update(_db.journalWriterTable)..where((t) => t.id.equals(id))).write(companion);
      return result > 0;
    } on WriterValidationException {
      rethrow;
    } catch (e) {
      throw WriterDatabaseException('更新作家失败: $e');
    }
  }

  /// 删除 Writer
  @override
  Future<bool> deleteWriter(int id) async {
    try {
      // 检查 Writer 是否存在
      final writer = await getWriterById(id);
      if (writer == null) {
        throw WriterValidationException('作家不存在');
      }

      final result = await (_db.delete(_db.journalWriterTable)..where((t) => t.id.equals(id))).go();
      return result > 0;
    } on WriterValidationException {
      rethrow;
    } catch (e) {
      throw WriterDatabaseException('删除作家失败: $e');
    }
  }

  /// 获取 Writer 数量
  @override
  Future<int> getWriterCount() async {
    try {
      final query = _db.selectOnly(_db.journalWriterTable)..addColumns([_db.journalWriterTable.id.count()]);
      final result = await query.getSingle();
      return result.read(_db.journalWriterTable.id.count()) ?? 0;
    } catch (e) {
      throw WriterDatabaseException('获取作家数量失败: $e');
    }
  }

  // 私有方法：转换数据库实体到数据模型
  JournalWriterData _convertToJournalWriterData(JournalWriter dbWriter) {
    return JournalWriterData(
      id: dbWriter.id,
      username: dbWriter.username,
      currentWriter: dbWriter.currentWriter,
      gender: dbWriter.gender,
      birthDay: dbWriter.birthDay,
      avatar: dbWriter.avatar,
      birthPlace: dbWriter.birthPlace,
      createdAt: dbWriter.createdAt,
      updatedAt: dbWriter.updatedAt,
    );
  }

  // 私有验证方法
  void _validateWriterData({
    required String username,
    required int gender,
    required DateTime birthDay,
  }) {
    _validateUsername(username);
    _validateGender(gender);
    _validateBirthDay(birthDay);
  }

  void _validateUsername(String username) {
    WriterValidator.validateUsername(username);
  }

  void _validateGender(int gender) {
    WriterValidator.validateGender(gender);
  }

  void _validateBirthDay(DateTime birthDay) {
    WriterValidator.validateBirthDay(birthDay);
  }

  /// 检查用户名是否已存在
  Future<bool> _checkUsernameExists(String username) async {
    final existingWriters = await (_db.select(_db.journalWriterTable)..where((t) => t.username.equals(username))).get();
    return existingWriters.isNotEmpty;
  }

  /// 创建默认作家（私有方法）
  ///
  /// 当数据库不为空但未找到当前作家时，自动创建一个默认作家
  /// 返回创建的默认作家数据
  Future<JournalWriterData> _createDefaultWriter() async {
    try {
      print('📝 开始创建默认作家...');

      // 创建默认作家
      final defaultWriterId = await createWriter(
        username: '默认作家',
        currentWriter: 1,
        gender: 1, // 1表示男性（符合验证规则）
        birthDay: DateTime(2000, 1, 1),
        avatar: null,
        birthPlace: '未知',
      );

      // 获取创建的作家信息
      final newWriter = await getWriterById(defaultWriterId);
      if (newWriter == null) {
        throw WriterDatabaseException('创建默认作家失败：无法获取新创建的作家信息');
      }

      print('✅ 默认作家创建成功，ID: $defaultWriterId, 用户名: ${newWriter.username}');
      return newWriter;
    } catch (e) {
      print('❌ 创建默认作家失败: $e');
      throw WriterDatabaseException('创建默认作家失败: $e');
    }
  }
}
