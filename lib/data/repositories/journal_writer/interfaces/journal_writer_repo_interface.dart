import 'package:WeekLife/data/models/journal_writer/journal_writer_data.dart';

/// Writer 仓库接口
/// 定义所有数据库操作的基本方法
abstract class IJournalWriterRepository {
  /// 创建单个 Writer
  /// 返回创建后的 Writer 数据（包含 ID）
  Future<JournalWriterData> createWriter(JournalWriterData writer);

  /// 批量创建 Writer
  /// 返回创建后的 Writer 数据列表（包含 ID）
  Future<List<JournalWriterData>> createWriters(List<JournalWriterData> writers);

  /// 查询 Writer
  /// [query] 查询条件
  /// 返回符合条件的 Writer 列表
  Future<List<JournalWriterData>> queryWriters(JournalWriterQuery query);

  /// 更新 Writer
  /// [id] Writer ID
  /// [writer] 更新后的数据
  /// 返回更新的记录数
  Future<int> updateWriter(int id, JournalWriterData writer);

  /// 删除 Writer
  /// [id] Writer ID
  /// 返回删除的记录数
  Future<int> deleteWriter(int id);

  /// 获取 Writer 数量
  /// 返回 Writer 数量
  Future<int> getWriterCount();

  /// 开始事务
  /// [action] 事务中执行的操作
  /// [requireNew] 是否要求新的事务
  /// 返回事务执行结果
  Future<T> transaction<T>(Future<T> Function() action, {bool requireNew = false});
} 