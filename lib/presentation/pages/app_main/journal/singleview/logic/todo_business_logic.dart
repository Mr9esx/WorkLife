import 'package:WeekLife/data/models/todo_record/todo_record_data.dart';
import 'package:WeekLife/data/dao/todo_record_dao.dart';
import 'package:WeekLife/data/dao/journal_writer/journal_writer_dao.dart';
import 'package:WeekLife/data/dao/weekly_journal/weekly_journal_dao.dart';
import 'package:WeekLife/common/constants/default_config.dart';
import 'package:WeekLife/common/utils/week_utils.dart';

/// TODO业务逻辑类
/// 负责处理TODO相关的所有业务逻辑和数据库操作
class TodoBusinessLogic {
  final TodoRecordDao _todoDao;
  final JournalWriterDao _writerDao;
  final WeeklyJournalDao _journalDao;

  TodoBusinessLogic({
    required TodoRecordDao todoDao,
    required JournalWriterDao writerDao,
    required WeeklyJournalDao journalDao,
  })  : _todoDao = todoDao,
        _writerDao = writerDao,
        _journalDao = journalDao;

  /// 加载指定周的 TODO 记录
  Future<List<TodoRecordData>> loadTodoRecords(int week, int year) async {
    try {
      // 获取当前作者
      final currentWriter = await _writerDao.getCurrentWriter();
      if (currentWriter.id == null) {
        return [];
      }

      // 判断是否是未来周份
      final isFutureWeek = WeekUtils.isFutureWeek(week, year);

      if (isFutureWeek) {
        // 未来周份：直接通过周数和年份查询TODO记录
        final todos = await _todoDao.getTodoRecordsByWeekAndYear(currentWriter.id!, week, year);

        print('📋 加载未来周份TODO记录: 周$week-$year, 数量=${todos.length}');
        for (final todo in todos) {
          print('  - ID=${todo.id}, 状态=${todo.status}, 优先级=${todo.priority}, 内容=${todo.content}');
        }

        return todos;
      } else {
        // 过去和当前周份：优先通过周数和年份查询，如果没有则通过周记ID查询
        // 首先尝试通过周数和年份查询（新的方式）
        final todosByWeek = await _todoDao.getTodoRecordsByWeekAndYear(currentWriter.id!, week, year);

        if (todosByWeek.isNotEmpty) {
          print('📋 通过周数年份加载TODO记录: 周$week-$year, 数量=${todosByWeek.length}');
          return todosByWeek;
        }

        // 如果通过周数年份没有找到，尝试通过周记ID查询（兼容旧数据）
        final weeklyJournal = await _journalDao.getWeeklyJournalByWeek(
          currentWriter.id!,
          week,
          year,
        );

        if (weeklyJournal != null) {
          final todosByJournal = await _todoDao.getTodoRecordsByWeeklyJournalId(weeklyJournal.id!);
          print('📋 通过周记ID加载TODO记录: 周$week-$year, 数量=${todosByJournal.length}');
          return todosByJournal;
        }

        // 如果都没有找到，返回空列表（不创建任何默认数据）
        print('📋 未找到TODO记录: 周$week-$year, 返回空列表');
        return [];
      }
    } catch (e) {
      print('加载 TODO 记录失败: $e');
      return [];
    }
  }

  /// 添加TODO记录
  Future<bool> addTodoRecord(String content, int week, int year, {int priority = 1, DateTime? reminderTime}) async {
    try {
      // 验证输入
      if (content.trim().isEmpty) {
        throw Exception('TODO内容不能为空');
      }

      // 获取当前作者
      final currentWriter = await _writerDao.getCurrentWriter();
      if (currentWriter.id == null) {
        throw Exception('无法获取当前作者');
      }

      // 获取现有的TODO记录来计算排序顺序
      final existingTodos = await _todoDao.getTodoRecordsByWeekAndYear(currentWriter.id!, week, year);

      final maxSortOrder =
          existingTodos.isEmpty ? 0 : existingTodos.map((t) => t.sortOrder).reduce((a, b) => a > b ? a : b);

      // 创建新的TODO记录（统一使用周数和年份，不依赖周记）
      final newTodo = TodoRecordData(
        weeklyJournalId: null, // 不再关联周记
        writerId: currentWriter.id!,
        weekNumber: week,
        year: year,
        content: content.trim(),
        isCompleted: DefaultConfig.defaultTodoCompleted,
        priority: priority.clamp(DefaultConfig.minTodoPriority, DefaultConfig.maxTodoPriority),
        sortOrder: maxSortOrder + 1,
        reminderTime: reminderTime,
        createdAt: DateTime.now(),
      );

      print('📋 添加TODO: 周$week-$year, 内容: $content, 优先级: $priority');

      await _todoDao.createTodoRecord(newTodo);
      return true;
    } catch (e) {
      print('添加TODO失败: $e');
      return false;
    }
  }

  /// 切换TODO状态（未开始 -> 进行中 -> 已完成，已完成后不再变化）
  Future<bool> toggleTodoStatus(int todoId) async {
    try {
      // 获取当前TODO
      final todo = await _todoDao.getTodoRecordById(todoId);
      if (todo == null) return false;

      print('🔄 切换TODO状态: ID=$todoId, 当前状态=${todo.status}, 优先级=${todo.priority}');

      // 如果已经是已完成状态，不再变化
      if (todo.status == TodoStatus.completed) {
        print('⏹️ TODO已完成，不再变化');
        return true;
      }

      // 计算下一个状态
      TodoStatus nextStatus;
      bool nextIsCompleted;
      int nextEncodedPriority;

      switch (todo.status) {
        case TodoStatus.notStarted:
          nextStatus = TodoStatus.inProgress;
          nextIsCompleted = false;
          nextEncodedPriority = todo.priority + 100; // 编码进行中状态
          break;
        case TodoStatus.inProgress:
          nextStatus = TodoStatus.completed;
          nextIsCompleted = true;
          nextEncodedPriority = todo.priority; // 恢复原始优先级
          break;
        case TodoStatus.completed:
          // 不应该到这里，但为了安全
          return true;
      }

      print('➡️ 下一个状态: $nextStatus, isCompleted=$nextIsCompleted, encodedPriority=$nextEncodedPriority');

      // 更新状态
      final success = await _todoDao.updateTodoRecord(todoId, {
        'isCompleted': nextIsCompleted,
        'priority': nextEncodedPriority,
      });

      print('✅ 更新结果: $success');
      return success;
    } catch (e) {
      print('❌ 切换TODO状态失败: $e');
      return false;
    }
  }

  /// 删除TODO记录
  Future<bool> deleteTodoRecord(int todoId) async {
    try {
      return await _todoDao.deleteTodoRecord(todoId);
    } catch (e) {
      print('删除TODO失败: $e');
      return false;
    }
  }

  /// 更新TODO内容
  Future<bool> updateTodoContent(int todoId, String newContent) async {
    try {
      if (newContent.trim().isEmpty) {
        throw Exception('TODO内容不能为空');
      }

      final todo = await _todoDao.getTodoRecordById(todoId);
      if (todo == null) {
        throw Exception('TODO记录不存在');
      }

      return await _todoDao.updateTodoRecord(todoId, {
        'content': newContent.trim(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('更新TODO内容失败: $e');
      return false;
    }
  }

  /// 更新TODO优先级
  Future<bool> updateTodoPriority(int todoId, int priority) async {
    try {
      final validPriority = priority.clamp(DefaultConfig.minTodoPriority, DefaultConfig.maxTodoPriority);

      final todo = await _todoDao.getTodoRecordById(todoId);
      if (todo == null) {
        throw Exception('TODO记录不存在');
      }

      return await _todoDao.updateTodoRecord(todoId, {
        'priority': validPriority,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('更新TODO优先级失败: $e');
      return false;
    }
  }

  /// 更新TODO提醒时间
  Future<bool> updateTodoReminderTime(int todoId, DateTime? reminderTime) async {
    try {
      final todo = await _todoDao.getTodoRecordById(todoId);
      if (todo == null) {
        throw Exception('TODO记录不存在');
      }

      return await _todoDao.updateTodoRecord(todoId, {
        'reminder_time': reminderTime?.toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('更新TODO提醒时间失败: $e');
      return false;
    }
  }

  /// 批量更新TODO排序
  Future<bool> updateTodoSortOrder(List<int> todoIds) async {
    try {
      for (int i = 0; i < todoIds.length; i++) {
        final todoId = todoIds[i];
        final todo = await _todoDao.getTodoRecordById(todoId);
        if (todo != null) {
          await _todoDao.updateTodoRecord(todoId, {
            'sortOrder': i,
            'updatedAt': DateTime.now().toIso8601String(),
          });
        }
      }
      return true;
    } catch (e) {
      print('更新TODO排序失败: $e');
      return false;
    }
  }

  /// 获取TODO统计信息
  Future<TodoStatistics> getTodoStatistics(int week, int year) async {
    try {
      final todos = await loadTodoRecords(week, year);

      final total = todos.length;
      final completed = todos.where((t) => t.isCompleted).length;
      final pending = total - completed;
      final completionRate = total > 0 ? (completed / total * 100).round() : 0;

      final priorityStats = <int, int>{};
      for (final todo in todos) {
        priorityStats[todo.priority] = (priorityStats[todo.priority] ?? 0) + 1;
      }

      return TodoStatistics(
        total: total,
        completed: completed,
        pending: pending,
        completionRate: completionRate,
        priorityStats: priorityStats,
      );
    } catch (e) {
      print('获取TODO统计信息失败: $e');
      return TodoStatistics.empty();
    }
  }

  /// 清理已完成的TODO（可选功能）
  Future<bool> clearCompletedTodos(int week, int year) async {
    try {
      final todos = await loadTodoRecords(week, year);
      final completedTodos = todos.where((t) => t.isCompleted).toList();

      for (final todo in completedTodos) {
        await _todoDao.deleteTodoRecord(todo.id!);
      }

      return true;
    } catch (e) {
      print('清理已完成TODO失败: $e');
      return false;
    }
  }

  /// 复制TODO到其他周
  Future<bool> copyTodosToWeek(int fromWeek, int fromYear, int toWeek, int toYear) async {
    try {
      final sourceTodos = await loadTodoRecords(fromWeek, fromYear);
      if (sourceTodos.isEmpty) return true;

      // 获取当前作者
      final currentWriter = await _writerDao.getCurrentWriter();
      if (currentWriter.id == null) return false;

      // 复制TODO（重置状态为未完成，使用统一的周数年份方式）
      for (final sourceTodo in sourceTodos) {
        final newTodo = TodoRecordData(
          weeklyJournalId: null, // 不再关联周记
          writerId: currentWriter.id!,
          weekNumber: toWeek,
          year: toYear,
          content: sourceTodo.content,
          isCompleted: false, // 重置为未完成
          priority: sourceTodo.priority,
          sortOrder: sourceTodo.sortOrder,
          createdAt: DateTime.now(),
        );

        await _todoDao.createTodoRecord(newTodo);
      }

      return true;
    } catch (e) {
      print('复制TODO失败: $e');
      return false;
    }
  }
}

/// TODO统计信息
class TodoStatistics {
  final int total;
  final int completed;
  final int pending;
  final int completionRate;
  final Map<int, int> priorityStats;

  TodoStatistics({
    required this.total,
    required this.completed,
    required this.pending,
    required this.completionRate,
    required this.priorityStats,
  });

  factory TodoStatistics.empty() {
    return TodoStatistics(
      total: 0,
      completed: 0,
      pending: 0,
      completionRate: 0,
      priorityStats: {},
    );
  }

  bool get isEmpty => total == 0;
  bool get hasCompleted => completed > 0;
  bool get hasPending => pending > 0;
  bool get isAllCompleted => total > 0 && completed == total;
}
