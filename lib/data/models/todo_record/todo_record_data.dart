/// TODO 状态枚举
enum TodoStatus {
  /// 未开始
  notStarted(0),

  /// 进行中
  inProgress(1),

  /// 已完成
  completed(2);

  const TodoStatus(this.value);
  final int value;

  static TodoStatus fromValue(int value) {
    switch (value) {
      case 0:
        return TodoStatus.notStarted;
      case 1:
        return TodoStatus.inProgress;
      case 2:
        return TodoStatus.completed;
      default:
        return TodoStatus.notStarted;
    }
  }
}

/// TODO 记录数据模型
/// 用于表示单个 TODO 记录的数据结构
class TodoRecordData {
  /// 主键ID
  final int? id;

  /// 关联的周记ID（可为空，用于未来周份的TODO）
  final int? weeklyJournalId;

  /// 关联的作者ID
  final int writerId;

  /// 周数（用于未来周份的TODO）
  final int? weekNumber;

  /// 年份（用于未来周份的TODO）
  final int? year;

  /// TODO内容
  final String content;

  /// 是否完成（保留兼容性）
  final bool isCompleted;

  /// TODO状态（新的三状态支持）
  final TodoStatus status;

  /// 优先级（1-低，2-中，3-高）
  final int priority;

  /// 排序顺序
  final int sortOrder;

  /// 提醒时间
  final DateTime? reminderTime;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime? updatedAt;

  const TodoRecordData({
    this.id,
    this.weeklyJournalId,
    required this.writerId,
    this.weekNumber,
    this.year,
    required this.content,
    this.isCompleted = false,
    this.status = TodoStatus.notStarted,
    this.priority = 1,
    this.sortOrder = 0,
    this.reminderTime,
    required this.createdAt,
    this.updatedAt,
  });

  /// 从 Map 创建 TodoRecordData
  factory TodoRecordData.fromMap(Map<String, dynamic> map) {
    // 暂时使用 priority 的特殊值来编码状态信息，直到数据库支持 status 字段
    // priority >= 100 表示进行中状态
    final originalPriority = map['priority'] as int? ?? 1;
    TodoStatus status;
    int actualPriority;

    if (originalPriority >= 100) {
      // 进行中状态：priority - 100 得到实际优先级
      status = TodoStatus.inProgress;
      actualPriority = originalPriority - 100;
    } else if ((map['is_completed'] as int) == 1) {
      // 已完成状态
      status = TodoStatus.completed;
      actualPriority = originalPriority;
    } else {
      // 未开始状态
      status = TodoStatus.notStarted;
      actualPriority = originalPriority;
    }

    return TodoRecordData(
      id: map['id'] as int?,
      weeklyJournalId: map['weekly_journal_id'] as int?,
      writerId: map['writer_id'] as int,
      weekNumber: map['week_number'] as int?,
      year: map['year'] as int?,
      content: map['content'] as String,
      isCompleted: (map['is_completed'] as int) == 1,
      status: status,
      priority: actualPriority.clamp(1, 3),
      sortOrder: map['sort_order'] as int? ?? 0,
      reminderTime: map['reminder_time'] != null ? DateTime.parse(map['reminder_time'] as String) : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'] as String) : null,
    );
  }

  /// 转换为 Map
  Map<String, dynamic> toMap() {
    // 使用 priority 字段编码状态信息
    int encodedPriority;
    bool isCompletedValue;

    switch (status) {
      case TodoStatus.notStarted:
        encodedPriority = priority;
        isCompletedValue = false;
        break;
      case TodoStatus.inProgress:
        encodedPriority = priority + 100; // 进行中状态：priority + 100
        isCompletedValue = false;
        break;
      case TodoStatus.completed:
        encodedPriority = priority;
        isCompletedValue = true;
        break;
    }

    return {
      if (id != null) 'id': id,
      if (weeklyJournalId != null) 'weekly_journal_id': weeklyJournalId,
      'writer_id': writerId,
      if (weekNumber != null) 'week_number': weekNumber,
      if (year != null) 'year': year,
      'content': content,
      'is_completed': isCompletedValue ? 1 : 0,
      'priority': encodedPriority,
      'sort_order': sortOrder,
      if (reminderTime != null) 'reminder_time': reminderTime!.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// 复制并修改部分字段
  TodoRecordData copyWith({
    int? id,
    int? weeklyJournalId,
    int? writerId,
    int? weekNumber,
    int? year,
    String? content,
    bool? isCompleted,
    TodoStatus? status,
    int? priority,
    int? sortOrder,
    DateTime? reminderTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TodoRecordData(
      id: id ?? this.id,
      weeklyJournalId: weeklyJournalId ?? this.weeklyJournalId,
      writerId: writerId ?? this.writerId,
      weekNumber: weekNumber ?? this.weekNumber,
      year: year ?? this.year,
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      sortOrder: sortOrder ?? this.sortOrder,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// toString 方法用于调试和日志输出
  @override
  String toString() {
    return 'TodoRecordData('
        'id: $id, '
        'weeklyJournalId: $weeklyJournalId, '
        'writerId: $writerId, '
        'weekNumber: $weekNumber, '
        'year: $year, '
        'content: $content, '
        'isCompleted: $isCompleted, '
        'priority: $priority, '
        'sortOrder: $sortOrder, '
        'reminderTime: $reminderTime, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }

  /// 相等性比较
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TodoRecordData &&
        other.id == id &&
        other.weeklyJournalId == weeklyJournalId &&
        other.writerId == writerId &&
        other.weekNumber == weekNumber &&
        other.year == year &&
        other.content == content &&
        other.isCompleted == isCompleted &&
        other.priority == priority &&
        other.sortOrder == sortOrder &&
        other.reminderTime == reminderTime &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  /// 哈希码
  @override
  int get hashCode {
    return Object.hash(
      id,
      weeklyJournalId,
      writerId,
      weekNumber,
      year,
      content,
      isCompleted,
      priority,
      sortOrder,
      reminderTime,
      createdAt,
      updatedAt,
    );
  }

  /// 获取优先级显示文本
  String get priorityText {
    switch (priority) {
      case 1:
        return '低';
      case 2:
        return '中';
      case 3:
        return '高';
      default:
        return '低';
    }
  }

  /// 获取优先级颜色
  String get priorityColor {
    switch (priority) {
      case 1:
        return '#4CAF50'; // 绿色
      case 2:
        return '#FF9800'; // 橙色
      case 3:
        return '#F44336'; // 红色
      default:
        return '#4CAF50';
    }
  }
}
