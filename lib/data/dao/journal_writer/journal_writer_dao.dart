import 'package:WeekLife/data/models/journal_writer/journal_writer_data.dart';
import 'package:WeekLife/common/validators/writer_validator.dart';
import 'package:WeekLife/common/exceptions/writer_exceptions.dart';
import 'package:WeekLife/data/dao/journal_writer/interfaces/journal_writer_dao_interface.dart';
import 'package:WeekLife/data/repositories/journal_writer/journal_writer_repo.dart';

/// Writer 数据访问对象
/// 提供 Writer 表的所有数据库操作方法
class JournalWriterDao implements IJournalWriterDao {
  final JournalWriterRepo _db;

  JournalWriterDao(JournalWriterRepo db) : _db = db;

  /// 创建新的 Writer
  /// 
  /// [username] 用户名（必填）
  /// [gender] 性别（必填，1:男，2:女）
  /// [birthDay] 生日（必填，格式：YYYYMMDD）
  /// [avatar] 头像（可选）
  /// [birthPlace] 出生地（可选）
  /// 
  /// 返回新创建的 Writer 的 ID
  /// 
  /// 可能抛出的异常：
  /// - [WriterValidationException] 数据验证失败
  /// - [WriterDatabaseException] 数据库操作失败
  @override
  Future<int> createWriter({
    required String username,
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
      final writer = await _db.createWriter(
        JournalWriterData(
          username: username,
          gender: gender,
          birthDay: birthDay,
          avatar: avatar,
          birthPlace: birthPlace,
          createdAt: DateTime.now(),
        ),
      );
      return writer.id!;
    } on WriterValidationException {
      rethrow;
    } catch (e) {
      throw WriterDatabaseException('创建作家失败: $e');
    }
  }

  /// 批量创建 Writer
  /// 
  /// [writerMaps] Writer 数据列表
  /// 返回新创建的 Writer 的 ID 列表
  /// 
  /// 可能抛出的异常：
  /// - [WriterValidationException] 数据验证失败
  /// - [WriterDatabaseException] 数据库操作失败
  @override
  Future<List<int>> createWriters(List<Map<String, dynamic>> writerMaps) async {
    return await _db.transaction(() async {
      // 使用 Future.wait 并行处理验证
      await Future.wait(
        writerMaps.map((w) => _validateWriterDataAsync(w))
      );
      
      // 批量插入
      final writers = writerMaps.map(_toWriterData).toList();
      return (await _db.createWriters(writers)).map((w) => w.id!).toList();
    });
  }

  /// 根据 ID 获取 Writer
  /// 
  /// [id] Writer 的 ID
  /// 返回 Writer 对象，如果不存在则返回 null
  /// 
  /// 可能抛出的异常：
  /// - [WriterDatabaseException] 数据库操作失败
  @override
  Future<JournalWriterData?> getWriterById(int id) async {
    try {
      final writers = await _db.queryWriters(JournalWriterQuery(id: id));
      return writers.isEmpty ? null : writers.first;
    } catch (e) {
      throw WriterDatabaseException('获取作家信息失败: $e');
    }
  }

  /// 根据用户名获取 Writer
  /// 
  /// [username] 用户名
  /// 返回 Writer 对象，如果不存在则返回 null
  /// 
  /// 可能抛出的异常：
  /// - [WriterValidationException] 用户名格式无效
  /// - [WriterDatabaseException] 数据库操作失败
  @override
  Future<JournalWriterData?> getWriterByUsername(String username) async {
    try {
      _validateUsername(username);
      final writers = await _db.queryWriters(JournalWriterQuery(username: username));
      return writers.isEmpty ? null : writers.first;
    } on WriterValidationException {
      rethrow;
    } catch (e) {
      throw WriterDatabaseException('获取作家信息失败: $e');
    }
  }

  /// 获取所有 Writer
  /// 
  /// [limit] 限制返回数量（可选）
  /// [offset] 偏移量（可选）
  /// [orderBy] 排序方式（可选，默认按创建时间倒序）
  /// 返回 Writer 列表
  /// 
  /// 可能抛出的异常：
  /// - [WriterDatabaseException] 数据库操作失败
  @override
  Future<List<JournalWriterData>> getAllWriters({
    int? limit,
    int? offset,
    String? orderBy,
    bool? orderDesc,
  }) async {
    try {
      return await _db.queryWriters(JournalWriterQuery(
        limit: limit,
        offset: offset,
        orderBy: orderBy,
        orderDesc: orderDesc,
      ));
    } catch (e) {
      throw WriterDatabaseException('获取作家列表失败: $e');
    }
  }

  /// 更新 Writer
  /// 
  /// [id] Writer 的 ID
  /// [updates] 要更新的字段
  /// 返回是否更新成功
  /// 
  /// 可能抛出的异常：
  /// - [WriterValidationException] 数据验证失败
  /// - [WriterDatabaseException] 数据库操作失败
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
        final existingWriters = await _db.queryWriters(JournalWriterQuery(username: username));
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

      // 更新数据
      final updatedData = JournalWriterData(
        id: id,
        username: updates['username'] as String? ?? writer.username,
        gender: updates.containsKey('gender') 
          ? (updates['gender'] as int)
          : writer.gender,
        birthDay: updates.containsKey('birthDay')
          ? updates['birthDay'] as DateTime
          : writer.birthDay,
        avatar: updates['avatar'] as String? ?? writer.avatar,
        birthPlace: updates['birthPlace'] as String? ?? writer.birthPlace,
        createdAt: writer.createdAt,
        updatedAt: DateTime.now(),
      );

      final result = await _db.updateWriter(id, updatedData);
      return result > 0;
    } on WriterValidationException {
      rethrow;
    } catch (e) {
      throw WriterDatabaseException('更新作家信息失败: $e');
    }
  }

  /// 删除 Writer
  /// 
  /// [id] Writer 的 ID
  /// 返回是否删除成功
  /// 
  /// 可能抛出的异常：
  /// - [WriterValidationException] 作家不存在
  /// - [WriterDatabaseException] 数据库操作失败
  @override
  Future<bool> deleteWriter(int id) async {
    try {
      // 检查 Writer 是否存在
      final writer = await getWriterById(id);
      if (writer == null) {
        throw WriterValidationException('作家不存在');
      }

      final result = await _db.deleteWriter(id);
      return result > 0;
    } on WriterValidationException {
      rethrow;
    } catch (e) {
      throw WriterDatabaseException('删除作家失败: $e');
    }
  }

  /// 验证 Writer 数据
  void _validateWriterData({
    required String username,
    required int gender,
    required DateTime birthDay,
  }) {
    WriterValidator.validateUsername(username);
    WriterValidator.validateGender(gender);
    WriterValidator.validateBirthDay(birthDay);
  }

  /// 验证用户名
  void _validateUsername(String username) {
    WriterValidator.validateUsername(username);
  }

  /// 验证性别
  void _validateGender(int gender) {
    WriterValidator.validateGender(gender);
  }

  /// 验证生日
  void _validateBirthDay(DateTime birthDay) {
    WriterValidator.validateBirthDay(birthDay);
  }

  Future<void> _validateWriterDataAsync(Map<String, dynamic> writerMap) async {
    await Future.wait([
      Future(() => WriterValidator.validateUsername(writerMap['username'] as String)),
      Future(() => WriterValidator.validateGender(writerMap['gender'] as int)),
      Future(() => WriterValidator.validateBirthDay(
        DateTime(
          (writerMap['birthDay'] as int) ~/ 10000,
          ((writerMap['birthDay'] as int) % 10000) ~/ 100,
          (writerMap['birthDay'] as int) % 100,
        ),
      )),
    ]);
  }

  JournalWriterData _toWriterData(Map<String, dynamic> writerMap) {
    return JournalWriterData(
      username: writerMap['username'] as String,
      gender: writerMap['gender'] as int,
      birthDay: DateTime(
        (writerMap['birthDay'] as int) ~/ 10000,
        ((writerMap['birthDay'] as int) % 10000) ~/ 100,
        (writerMap['birthDay'] as int) % 100,
      ),
      avatar: writerMap['avatar'] as String?,
      birthPlace: writerMap['birthPlace'] as String?,
      createdAt: DateTime.now(),
    );
  }

  /// 检查用户名是否已存在
  Future<bool> _checkUsernameExists(String username) async {
    final existingWriters = await _db.queryWriters(JournalWriterQuery(username: username));
    return existingWriters.isNotEmpty;
  }
}

/// 排序方式枚举
enum OrderBy {
  createdAtDesc,  // 创建时间倒序
  createdAtAsc,   // 创建时间正序
  usernameAsc,    // 用户名正序
  usernameDesc,   // 用户名倒序
}

abstract class IWriterRepository {
  Future<JournalWriterData> createWriter(JournalWriterData writer);
  Future<List<JournalWriterData>> queryWriters(JournalWriterQuery query);
  // ...
} 