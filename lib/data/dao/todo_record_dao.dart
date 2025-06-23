import 'package:drift/drift.dart';
import 'package:WeekLife/data/models/todo_record/todo_record_data.dart';
import 'package:WeekLife/data/database/app_database.dart';

/// TODO 记录数据访问对象
/// 负责处理 TODO 记录的数据库操作
class TodoRecordDao {
  final AppDatabase _database;

  TodoRecordDao(this._database);

  /// 获取表引用
  $TodoRecordTableTable get _todoRecordTable => _database.todoRecordTable;

  /// 创建新的 TODO 记录
  Future<TodoRecordData> createTodoRecord(TodoRecordData todoRecord) async {
    try {
      final id = await _database.into(_todoRecordTable).insert(
            TodoRecordTableCompanion(
              weeklyJournalId:
                  todoRecord.weeklyJournalId != null ? Value(todoRecord.weeklyJournalId!) : const Value.absent(),
              writerId: Value(todoRecord.writerId),
              weekNumber: todoRecord.weekNumber != null ? Value(todoRecord.weekNumber!) : const Value.absent(),
              year: todoRecord.year != null ? Value(todoRecord.year!) : const Value.absent(),
              content: Value(todoRecord.content),
              isCompleted: Value(todoRecord.isCompleted),
              priority: Value(todoRecord.priority),
              sortOrder: Value(todoRecord.sortOrder),
              reminderTime: todoRecord.reminderTime != null ? Value(todoRecord.reminderTime!) : const Value.absent(),
              createdAt: Value(todoRecord.createdAt),
              updatedAt: Value(todoRecord.updatedAt),
            ),
          );

      return todoRecord.copyWith(id: id);
    } catch (e) {
      throw Exception('创建 TODO 记录失败: $e');
    }
  }

  /// 根据 ID 获取 TODO 记录
  Future<TodoRecordData?> getTodoRecordById(int id) async {
    try {
      final query = _database.select(_todoRecordTable)..where((t) => t.id.equals(id));

      final result = await query.getSingleOrNull();
      if (result == null) return null;

      return _convertToTodoRecordData(result);
    } catch (e) {
      throw Exception('获取 TODO 记录失败: $e');
    }
  }

  /// 根据周记 ID 获取所有 TODO 记录
  Future<List<TodoRecordData>> getTodoRecordsByWeeklyJournalId(int weeklyJournalId) async {
    try {
      final query = _database.select(_todoRecordTable)
        ..where((t) => t.weeklyJournalId.equals(weeklyJournalId))
        ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])
        ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]);

      final results = await query.get();
      return results.map(_convertToTodoRecordData).toList();
    } catch (e) {
      throw Exception('获取 TODO 记录列表失败: $e');
    }
  }

  /// 根据周数和年份获取所有 TODO 记录（用于未来周份）
  Future<List<TodoRecordData>> getTodoRecordsByWeekAndYear(int writerId, int weekNumber, int year) async {
    try {
      final query = _database.select(_todoRecordTable)
        ..where((tbl) => tbl.writerId.equals(writerId) & tbl.weekNumber.equals(weekNumber) & tbl.year.equals(year))
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.sortOrder)])
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt)]);

      final results = await query.get();
      return results.map(_convertToTodoRecordData).toList();
    } catch (e) {
      throw Exception('获取 TODO 记录列表失败: $e');
    }
  }

  /// 根据作者 ID 获取所有 TODO 记录
  Future<List<TodoRecordData>> getTodoRecordsByWriterId(int writerId) async {
    try {
      final query = _database.select(_todoRecordTable)
        ..where((t) => t.writerId.equals(writerId))
        ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);

      final results = await query.get();
      return results.map(_convertToTodoRecordData).toList();
    } catch (e) {
      throw Exception('获取作者 TODO 记录失败: $e');
    }
  }

  /// 更新 TODO 记录
  Future<bool> updateTodoRecord(int id, Map<String, dynamic> updates) async {
    try {
      var companion = TodoRecordTableCompanion(
        updatedAt: Value(DateTime.now()),
      );

      // 动态添加需要更新的字段
      if (updates.containsKey('content')) {
        companion = companion.copyWith(content: Value(updates['content']));
      }
      if (updates.containsKey('isCompleted')) {
        companion = companion.copyWith(isCompleted: Value(updates['isCompleted']));
      }
      if (updates.containsKey('priority')) {
        companion = companion.copyWith(priority: Value(updates['priority']));
      }
      if (updates.containsKey('sortOrder')) {
        companion = companion.copyWith(sortOrder: Value(updates['sortOrder']));
      }
      if (updates.containsKey('reminder_time')) {
        final reminderTime = updates['reminder_time'];
        if (reminderTime is String) {
          companion = companion.copyWith(reminderTime: Value(DateTime.parse(reminderTime)));
        } else if (reminderTime == null) {
          companion = companion.copyWith(reminderTime: const Value(null));
        }
      }

      final query = _database.update(_todoRecordTable)..where((t) => t.id.equals(id));

      final affectedRows = await query.write(companion);
      return affectedRows > 0;
    } catch (e) {
      throw Exception('更新 TODO 记录失败: $e');
    }
  }

  /// 切换 TODO 记录完成状态
  Future<bool> toggleTodoRecordStatus(int id) async {
    try {
      // 先获取当前状态
      final todoRecord = await getTodoRecordById(id);
      if (todoRecord == null) return false;

      // 切换状态
      return await updateTodoRecord(id, {
        'isCompleted': !todoRecord.isCompleted,
      });
    } catch (e) {
      throw Exception('切换 TODO 状态失败: $e');
    }
  }

  /// 删除 TODO 记录
  Future<bool> deleteTodoRecord(int id) async {
    try {
      final query = _database.delete(_todoRecordTable)..where((t) => t.id.equals(id));

      final affectedRows = await query.go();
      return affectedRows > 0;
    } catch (e) {
      throw Exception('删除 TODO 记录失败: $e');
    }
  }

  /// 删除指定周记的所有 TODO 记录
  Future<int> deleteTodoRecordsByWeeklyJournalId(int weeklyJournalId) async {
    try {
      final query = _database.delete(_todoRecordTable)..where((t) => t.weeklyJournalId.equals(weeklyJournalId));

      return await query.go();
    } catch (e) {
      throw Exception('删除周记 TODO 记录失败: $e');
    }
  }

  /// 获取指定周记的 TODO 统计信息
  Future<Map<String, int>> getTodoStatsByWeeklyJournalId(int weeklyJournalId) async {
    try {
      final allTodos = await getTodoRecordsByWeeklyJournalId(weeklyJournalId);
      final completedTodos = allTodos.where((todo) => todo.isCompleted).length;
      final totalTodos = allTodos.length;

      return {
        'total': totalTodos,
        'completed': completedTodos,
        'pending': totalTodos - completedTodos,
      };
    } catch (e) {
      throw Exception('获取 TODO 统计失败: $e');
    }
  }

  /// 批量更新 TODO 记录排序
  Future<bool> updateTodoRecordsOrder(List<Map<String, dynamic>> updates) async {
    try {
      await _database.transaction(() async {
        for (final update in updates) {
          final id = update['id'] as int;
          final sortOrder = update['sortOrder'] as int;

          await updateTodoRecord(id, {'sortOrder': sortOrder});
        }
      });
      return true;
    } catch (e) {
      throw Exception('批量更新 TODO 排序失败: $e');
    }
  }

  /// 将数据库记录转换为 TodoRecordData
  TodoRecordData _convertToTodoRecordData(TodoRecord record) {
    // 使用 fromMap 来正确解码状态信息
    final map = {
      'id': record.id,
      'weekly_journal_id': record.weeklyJournalId,
      'writer_id': record.writerId,
      'week_number': record.weekNumber,
      'year': record.year,
      'content': record.content,
      'is_completed': record.isCompleted ? 1 : 0,
      'priority': record.priority,
      'sort_order': record.sortOrder,
      if (record.reminderTime != null) 'reminder_time': record.reminderTime!.toIso8601String(),
      'created_at': record.createdAt.toIso8601String(),
      if (record.updatedAt != null) 'updated_at': record.updatedAt!.toIso8601String(),
    };

    return TodoRecordData.fromMap(map);
  }
}
