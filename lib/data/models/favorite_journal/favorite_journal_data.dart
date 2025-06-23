/// 收藏周记数据模型
class FavoriteJournalData {
  final int? id;
  final int weekNumber;
  final int year;
  final int writerId;
  final DateTime createdAt;

  const FavoriteJournalData({
    this.id,
    required this.weekNumber,
    required this.year,
    required this.writerId,
    required this.createdAt,
  });

  /// 从Map创建实例
  factory FavoriteJournalData.fromMap(Map<String, dynamic> map) {
    return FavoriteJournalData(
      id: map['id'],
      weekNumber: map['weekNumber'],
      year: map['year'],
      writerId: map['writerId'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weekNumber': weekNumber,
      'year': year,
      'writerId': writerId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// 复制并修改部分字段
  FavoriteJournalData copyWith({
    int? id,
    int? weekNumber,
    int? year,
    int? writerId,
    DateTime? createdAt,
  }) {
    return FavoriteJournalData(
      id: id ?? this.id,
      weekNumber: weekNumber ?? this.weekNumber,
      year: year ?? this.year,
      writerId: writerId ?? this.writerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'FavoriteJournalData(id: $id, weekNumber: $weekNumber, year: $year, writerId: $writerId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteJournalData &&
        other.id == id &&
        other.weekNumber == weekNumber &&
        other.year == year &&
        other.writerId == writerId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ weekNumber.hashCode ^ year.hashCode ^ writerId.hashCode ^ createdAt.hashCode;
  }
}
