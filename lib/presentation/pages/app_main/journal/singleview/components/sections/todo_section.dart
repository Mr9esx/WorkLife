import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WeekLife/data/models/todo_record/todo_record_data.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/icon/app_icon.dart';
import 'package:WeekLife/core/services/reminder_service.dart';

/// TODO记录组件
/// 负责显示和管理TODO列表，支持添加、删除、状态切换等功能
class TodoSection extends StatelessWidget {
  /// 当前周数
  final int currentWeek;

  /// 当前年份
  final int currentYear;

  /// TODO记录列表
  final List<TodoRecordData> todos;

  /// 是否正在加载
  final bool isLoading;

  /// 添加TODO回调
  final Function(String content, int priority, DateTime? reminderTime) onAddTodo;

  /// 切换TODO状态回调
  final Function(int todoId) onToggleTodo;

  /// 删除TODO回调
  final Function(int todoId) onDeleteTodo;

  /// 编辑TODO回调
  final Function(int todoId, String content, int priority, DateTime? reminderTime) onEditTodo;

  /// 是否处于编辑状态（从外部传入）
  final bool isEditing;

  /// 是否启用编辑功能
  final bool enableEdit;

  const TodoSection({
    super.key,
    required this.currentWeek,
    required this.currentYear,
    required this.todos,
    required this.isLoading,
    required this.onAddTodo,
    required this.onToggleTodo,
    required this.onDeleteTodo,
    required this.onEditTodo,
    this.isEditing = false,
    this.enableEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            '待办事项',
            style: TextStyle(
              color: const Color(0xFF2F3036), // 重点色
              fontSize: 14,
              fontFamily: 'MiSans',
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          // TODO列表
          Column(
            children: [
              ..._buildTodoItems(),
              if (enableEdit && isEditing) _buildNewAddButton(),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建TODO项目列表
  List<Widget> _buildTodoItems() {
    if (isLoading) {
      return [
        SizedBox(
          height: 60,
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF2F3036),
            ),
          ),
        ),
      ];
    }

    if (todos.isEmpty) {
      return [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
          margin: const EdgeInsets.only(bottom: 8),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0x0C35383E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '暂无待办事项',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 14,
                    fontFamily: 'MiSans',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ];
    }

    return todos.map((todo) => _buildNewTodoItem(todo)).toList();
  }

  /// 构建新样式的TODO项目
  Widget _buildNewTodoItem(TodoRecordData todo) {
    Color backgroundColor;
    Color checkboxColor;
    Widget? priorityIcon;

    // 统一使用app背景色，只通过选择框颜色区分状态
    backgroundColor = AppColors.appBackground; // 统一背景色

    // 根据状态确定选择框颜色
    switch (todo.status) {
      case TodoStatus.completed:
        checkboxColor = const Color(0xCC1FC47A); // 绿色选择框
        break;
      case TodoStatus.inProgress:
        checkboxColor = const Color(0xCCFF9900); // 橙色选择框
        break;
      case TodoStatus.notStarted:
        checkboxColor = const Color(0x1935383E); // 灰色选择框
        break;
    }

    // 只有高优先级才显示感叹号图标
    if (todo.priority == 3) {
      priorityIcon = Container(
        width: 24,
        height: 24,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: JournalThemeColors.red, // 红色背景
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const AppIcon(
          assetName: 'information-circle-contained',
          size: 18,
          color: AppColors.cardBackground,
        ),
      );
    }

    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: enableEdit && isEditing
            ? Dismissible(
                key: Key('todo_${todo.id}'),
                direction: DismissDirection.endToStart, // 只允许从右向左滑动
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: JournalThemeColors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const AppIcon(
                    assetName: 'trash-01',
                    size: 24,
                    color: AppColors.cardBackground,
                  ),
                ),
                confirmDismiss: (direction) async {
                  // 显示确认对话框
                  return await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('确认删除'),
                            content: Text('确定要删除「${todo.content}」吗？'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('删除'),
                              ),
                            ],
                          );
                        },
                      ) ??
                      false;
                },
                onDismissed: (direction) {
                  HapticFeedback.selectionClick();
                  onDeleteTodo(todo.id!);
                },
                child: _buildTodoContent(todo, backgroundColor, checkboxColor, priorityIcon, context),
              )
            : _buildTodoContent(todo, backgroundColor, checkboxColor, priorityIcon, context),
      ),
    );
  }

  /// 构建TODO内容部分
  Widget _buildTodoContent(
      TodoRecordData todo, Color backgroundColor, Color checkboxColor, Widget? priorityIcon, BuildContext context) {
    final isCompleted = todo.status == TodoStatus.completed;

    return GestureDetector(
      // 移除整个项目的点击状态切换逻辑
      onDoubleTap: enableEdit && isEditing
          ? () {
              HapticFeedback.selectionClick();
              if (isCompleted) {
                // 已完成的项目不允许编辑，显示提示
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('已完成的待办事项不能编辑'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              print('🖱️ TODO项目被双击编辑: ID=${todo.id}');
              _showEditTodoDialog(context, todo);
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 复选框 - 只有这里可以切换状态
            GestureDetector(
              onTap: enableEdit && isEditing
                  ? () {
                      HapticFeedback.selectionClick();
                      print('🖱️ TODO复选框被点击: ID=${todo.id}, enableEdit=$enableEdit, isEditing=$isEditing');
                      onToggleTodo(todo.id!);
                    }
                  : null,
              child: Container(
                width: 24,
                height: 24,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: checkboxColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _buildStatusIcon(todo.status),
              ),
            ),
            const SizedBox(width: 15),
            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    todo.content,
                    style: TextStyle(
                      color: _getTodoTextColor(todo.status),
                      fontSize: 14,
                      fontFamily: 'MiSans',
                      fontWeight: FontWeight.w500,
                      decoration:
                          todo.status == TodoStatus.completed ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  if (todo.reminderTime != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      ReminderService.formatReminderTime(todo.reminderTime!),
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 12,
                        fontFamily: 'MiSans',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // 优先级图标
            if (priorityIcon != null) ...[
              const SizedBox(width: 8),
              priorityIcon,
            ],
          ],
        ),
      ),
    );
  }

  /// 构建状态图标
  Widget? _buildStatusIcon(TodoStatus status) {
    switch (status) {
      case TodoStatus.notStarted:
        return null; // 空白状态
      case TodoStatus.inProgress:
        return const AppIcon(
          assetName: 'todo-progress',
          color: Colors.white,
          size: 16,
        );
      case TodoStatus.completed:
        return const Icon(
          Icons.check,
          color: Colors.white,
          size: 16,
        );
    }
  }

  /// 构建新的添加按钮
  Widget _buildNewAddButton() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          _showAddTodoDialog(context);
        },
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: ShapeDecoration(
            color: AppColors.primary, // 深色背景
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Center(
            child: Text(
              '新增',
              style: TextStyle(
                color: AppColors.cardBackground, // 白色文字
                fontSize: 14,
                fontFamily: 'MiSans',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 显示添加TODO对话框
  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _AddTodoDialog(
        onAddTodo: (content, priority, reminderTime) => onAddTodo(content, priority, reminderTime),
      ),
    );
  }

  /// 显示编辑TODO对话框
  void _showEditTodoDialog(BuildContext context, TodoRecordData todo) {
    showDialog(
      context: context,
      builder: (context) => _EditTodoDialog(
        todo: todo,
        onEditTodo: (todoId, content, priority, reminderTime) => onEditTodo(todoId, content, priority, reminderTime),
      ),
    );
  }
}

/// 独立的添加TODO对话框组件
class _AddTodoDialog extends StatefulWidget {
  final Function(String content, int priority, DateTime? reminderTime) onAddTodo;

  const _AddTodoDialog({
    required this.onAddTodo,
  });

  @override
  State<_AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<_AddTodoDialog> {
  late final TextEditingController _controller;
  bool _isHighPriority = false;
  DateTime? _reminderTime;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加待办事项'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            enableInteractiveSelection: true,
            contextMenuBuilder: (context, editableTextState) {
              return AdaptiveTextSelectionToolbar.editableText(
                editableTextState: editableTextState,
              );
            },
            decoration: const InputDecoration(
              hintText: '请输入待办事项内容',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                final priority = _isHighPriority ? 3 : 1;
                widget.onAddTodo(value.trim(), priority, _reminderTime);
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _isHighPriority,
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _isHighPriority = value ?? false;
                  });
                },
              ),
              const Text('高优先级'),
            ],
          ),
          const SizedBox(height: 16),
          // 提醒时间选择
          Row(
            children: [
              const Text('提醒时间：'),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _selectReminderTime(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _reminderTime != null ? ReminderService.formatReminderTime(_reminderTime!) : '选择提醒时间',
                      style: TextStyle(
                        color: _reminderTime != null ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              if (_reminderTime != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _reminderTime = null;
                    });
                  },
                  icon: const Icon(Icons.clear, size: 16),
                ),
              ],
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context);
          },
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            if (_controller.text.trim().isNotEmpty) {
              final priority = _isHighPriority ? 3 : 1;
              widget.onAddTodo(_controller.text.trim(), priority, _reminderTime);
            }
            Navigator.pop(context);
          },
          child: const Text('添加'),
        ),
      ],
    );
  }

  /// 选择提醒时间
  Future<void> _selectReminderTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && context.mounted) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _reminderTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }
}

/// 独立的编辑TODO对话框组件
class _EditTodoDialog extends StatefulWidget {
  final TodoRecordData todo;
  final Function(int todoId, String content, int priority, DateTime? reminderTime) onEditTodo;

  const _EditTodoDialog({
    required this.todo,
    required this.onEditTodo,
  });

  @override
  State<_EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<_EditTodoDialog> {
  late final TextEditingController _controller;
  late bool _isHighPriority;
  DateTime? _reminderTime;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.todo.content);
    _isHighPriority = widget.todo.priority == 3;
    _reminderTime = widget.todo.reminderTime;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('编辑待办事项'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            enableInteractiveSelection: true,
            contextMenuBuilder: (context, editableTextState) {
              return AdaptiveTextSelectionToolbar.editableText(
                editableTextState: editableTextState,
              );
            },
            decoration: const InputDecoration(
              hintText: '请输入待办事项内容',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                final priority = _isHighPriority ? 3 : 1;
                widget.onEditTodo(widget.todo.id!, value.trim(), priority, _reminderTime);
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _isHighPriority,
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _isHighPriority = value ?? false;
                  });
                },
              ),
              const Text('高优先级'),
            ],
          ),
          const SizedBox(height: 16),
          // 提醒时间选择
          Row(
            children: [
              const Text('提醒时间：'),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _selectReminderTime(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _reminderTime != null ? ReminderService.formatReminderTime(_reminderTime!) : '选择提醒时间',
                      style: TextStyle(
                        color: _reminderTime != null ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              if (_reminderTime != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _reminderTime = null;
                    });
                  },
                  icon: const Icon(Icons.clear, size: 16),
                ),
              ],
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context);
          },
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            if (_controller.text.trim().isNotEmpty) {
              final priority = _isHighPriority ? 3 : 1;
              widget.onEditTodo(widget.todo.id!, _controller.text.trim(), priority, _reminderTime);
            }
            Navigator.pop(context);
          },
          child: const Text('保存'),
        ),
      ],
    );
  }

  /// 选择提醒时间
  Future<void> _selectReminderTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _reminderTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && context.mounted) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: _reminderTime != null ? TimeOfDay.fromDateTime(_reminderTime!) : TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _reminderTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }
}

Color _getTodoTextColor(TodoStatus status) {
  // 统一使用主色调，不再根据状态改变文字颜色
  return AppColors.primary; // 所有状态都使用主色调 #2F3036
}
