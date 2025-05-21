import 'package:drift/drift.dart';
import 'package:WeekLife/data/repositories/weekly_journal/weekly_journal_repo.dart';

class WeeklyJournalData {
  final int? id;
  final String title;
  final String content;
  final int mood;
  final String moodColor;
  final String pics;
  final String geo;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const WeeklyJournalData({
    this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.moodColor,  
    required this.pics,
    required this.geo,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory WeeklyJournalData.fromDb(WeeklyJournal weeklyJournal) => WeeklyJournalData(
    id: weeklyJournal.id,
    title: weeklyJournal.title,
    content: weeklyJournal.content,
    mood: weeklyJournal.mood,
    moodColor: weeklyJournal.moodColor,
    pics: weeklyJournal.pics,
    geo: weeklyJournal.geo,
    createdAt: weeklyJournal.createdAt,
    updatedAt: weeklyJournal.updatedAt,
    deletedAt: weeklyJournal.deletedAt,
  );

  WeeklyJournalTableCompanion toCompanion() => WeeklyJournalTableCompanion(
    id: id == null ? const Value.absent() : Value(id!),
    title: Value(title),
    content: Value(content),
    mood: Value(mood),
    moodColor: Value(moodColor),
    pics: Value(pics),
    geo: Value(geo),
    createdAt: Value(createdAt),
    updatedAt: updatedAt == null ? const Value.absent() : Value(updatedAt!),
    deletedAt: deletedAt == null ? const Value.absent() : Value(deletedAt!),
  );

  WeeklyJournalData copyWith({
    int? id,
    String? title,
    String? content,
    int? mood,
    String? moodColor,
    String? pics,
    String? geo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return WeeklyJournalData(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      moodColor: moodColor ?? this.moodColor,
      pics: pics ?? this.pics,
      geo: geo ?? this.geo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
