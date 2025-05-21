import 'package:WeekLife/data/models/journal_writer/journal_writer_data.dart';

/// Writer 数据访问对象接口
/// 定义所有业务级别的数据操作方法
abstract class IJournalWriterDao {
  /// 创建新的 Writer
  /// 
  /// [username] 用户名（必填）
  /// [gender] 性别（必填，1:男，2:女）
  /// [birthDay] 生日（必填，格式：YYYYMMDD）
  /// [avatar] 头像（可选）
  /// [birthPlace] 出生地（可选）
  /// 
  /// 返回新创建的 Writer 的 ID
  Future<int> createWriter({
    required String username,
    required int gender,
    required DateTime birthDay,
    String? avatar,
    String? birthPlace,
  });

  /// 批量创建 Writer
  /// 
  /// [writerMaps] Writer 数据列表
  /// 返回新创建的 Writer 的 ID 列表
  Future<List<int>> createWriters(List<Map<String, dynamic>> writerMaps);

  /// 根据 ID 获取 Writer
  /// 
  /// [id] Writer 的 ID
  /// 返回 Writer 对象，如果不存在则返回 null
  Future<JournalWriterData?> getWriterById(int id);

  /// 根据用户名获取 Writer
  /// 
  /// [username] 用户名
  /// 返回 Writer 对象，如果不存在则返回 null
  Future<JournalWriterData?> getWriterByUsername(String username);

  /// 获取所有 Writer
  /// 
  /// [limit] 限制返回数量（可选）
  /// [offset] 偏移量（可选）
  /// [orderBy] 排序方式（可选，默认按创建时间倒序）
  /// 返回 Writer 列表
  Future<List<JournalWriterData>> getAllWriters({
    int? limit,
    int? offset,
    String? orderBy,
    bool? orderDesc,
  });

  /// 更新 Writer
  /// 
  /// [id] Writer 的 ID
  /// [updates] 要更新的字段
  /// 返回是否更新成功
  Future<bool> updateWriter(
    int id,
    Map<String, dynamic> updates,
  );

  /// 删除 Writer
  /// 
  /// [id] Writer 的 ID
  /// 返回是否删除成功
  Future<bool> deleteWriter(int id);
} 