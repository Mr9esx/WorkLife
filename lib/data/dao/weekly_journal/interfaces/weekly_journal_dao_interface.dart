import 'package:WeekLife/data/models/weekly_journal/weekly_journal_data.dart';

abstract class IWeeklyJournalDao {
  Future<int> createWeeklyJournal(WeeklyJournalData weeklyJournal);
  Future<List<WeeklyJournalData>> getWeeklyJournals(int writerId);
  Future<WeeklyJournalData> getWeeklyJournal(int id);
  Future<int> updateWeeklyJournal(WeeklyJournalData weeklyJournal);
  Future<int> deleteWeeklyJournal(int id);
}
