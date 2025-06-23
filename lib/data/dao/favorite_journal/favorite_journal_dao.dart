import 'package:drift/drift.dart';
import 'package:WeekLife/data/models/favorite_journal/favorite_journal_data.dart';

/// 收藏周记数据访问对象
class FavoriteJournalDao {
  final GeneratedDatabase _database;

  FavoriteJournalDao(this._database);

  /// 添加收藏
  Future<int> addFavorite({
    required int weekNumber,
    required int year,
    required int writerId,
  }) async {
    try {
      final result = await _database.customInsert(
        'INSERT INTO favorite_journal_table (week_number, year, writer_id, created_at) VALUES (?, ?, ?, ?)',
        variables: [
          Variable.withInt(weekNumber),
          Variable.withInt(year),
          Variable.withInt(writerId),
          Variable.withDateTime(DateTime.now()),
        ],
      );
      print('✅ 添加收藏成功: 第$weekNumber周 ($year年), writerId: $writerId');
      return result;
    } catch (e) {
      print('❌ 添加收藏失败: $e');
      rethrow;
    }
  }

  /// 移除收藏
  Future<bool> removeFavorite({
    required int weekNumber,
    required int year,
    required int writerId,
  }) async {
    try {
      final result = await _database.customUpdate(
        'DELETE FROM favorite_journal_table WHERE week_number = ? AND year = ? AND writer_id = ?',
        variables: [
          Variable.withInt(weekNumber),
          Variable.withInt(year),
          Variable.withInt(writerId),
        ],
      );
      print('✅ 移除收藏成功: 第$weekNumber周 ($year年), writerId: $writerId');
      return result > 0;
    } catch (e) {
      print('❌ 移除收藏失败: $e');
      rethrow;
    }
  }

  /// 检查是否已收藏
  Future<bool> isFavorited({
    required int weekNumber,
    required int year,
    required int writerId,
  }) async {
    try {
      final result = await _database.customSelect(
        'SELECT COUNT(*) as count FROM favorite_journal_table WHERE week_number = ? AND year = ? AND writer_id = ?',
        variables: [
          Variable.withInt(weekNumber),
          Variable.withInt(year),
          Variable.withInt(writerId),
        ],
      ).getSingle();

      final count = result.data['count'] as int;
      return count > 0;
    } catch (e) {
      print('❌ 检查收藏状态失败: $e');
      return false;
    }
  }

  /// 获取用户的所有收藏
  Future<List<FavoriteJournalData>> getFavoritesByWriter(int writerId) async {
    try {
      final result = await _database.customSelect(
        'SELECT * FROM favorite_journal_table WHERE writer_id = ? ORDER BY year DESC, week_number DESC',
        variables: [Variable.withInt(writerId)],
      ).get();

      return result.map((row) {
        return FavoriteJournalData(
          id: row.data['id'] as int,
          weekNumber: row.data['week_number'] as int,
          year: row.data['year'] as int,
          writerId: row.data['writer_id'] as int,
          createdAt: row.data['created_at'] as DateTime,
        );
      }).toList();
    } catch (e) {
      print('❌ 获取收藏列表失败: $e');
      return [];
    }
  }

  /// 切换收藏状态
  Future<bool> toggleFavorite({
    required int weekNumber,
    required int year,
    required int writerId,
  }) async {
    final isFavorited = await this.isFavorited(
      weekNumber: weekNumber,
      year: year,
      writerId: writerId,
    );

    if (isFavorited) {
      await removeFavorite(
        weekNumber: weekNumber,
        year: year,
        writerId: writerId,
      );
      return false; // 取消收藏
    } else {
      await addFavorite(
        weekNumber: weekNumber,
        year: year,
        writerId: writerId,
      );
      return true; // 添加收藏
    }
  }
}
