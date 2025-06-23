import 'package:flutter/material.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'components/core/journal_content.dart';
import 'package:WeekLife/common/ui/app_bar/custom_app_bar.dart';
import 'package:WeekLife/core/utils/index.dart';
import 'package:WeekLife/data/models/weekly_journal/weekly_journal_data.dart';
import 'package:WeekLife/core/utils/database/database_manager.dart';
import 'package:WeekLife/data/dao/journal_writer/journal_writer_dao.dart';
import 'package:WeekLife/data/dao/weekly_journal/weekly_journal_dao.dart';

/// 单周视角页面
/// 包含topbar、周记记录组件和bottombar
class SingleWeekJournalPage extends StatefulWidget {
  final Map<String, dynamic>? params;

  const SingleWeekJournalPage({super.key, this.params});

  @override
  State<SingleWeekJournalPage> createState() => _SingleWeekJournalPageState();
}

/// 单周视角内容组件（可复用）
/// 只包含周记内容，WeekSelector已经集成到JournalContent中
class SingleWeekView extends StatefulWidget {
  final int currentWeek;
  final int currentYear;
  final List<WeeklyJournalData> yearlyJournals;

  const SingleWeekView({
    super.key,
    required this.currentWeek,
    required this.currentYear,
    required this.yearlyJournals,
  });

  @override
  State<SingleWeekView> createState() => _SingleWeekViewState();
}

class _SingleWeekJournalPageState extends State<SingleWeekJournalPage> {
  late int currentWeek;
  late int currentYear;
  List<WeeklyJournalData> yearlyJournals = [];
  bool isLoading = true;
  bool isEditing = false; // 添加编辑状态管理

  // DAO 实例
  late final JournalWriterDao _writerDao;
  late final WeeklyJournalDao _journalDao;

  @override
  void initState() {
    super.initState();
    final weekInfo = DateUtil.getCurrentWeekOfYear();
    currentWeek = weekInfo.week;
    currentYear = weekInfo.year;

    // 初始化 DAO
    final database = DatabaseManager.instance.database;
    _writerDao = JournalWriterDao(database);
    _journalDao = WeeklyJournalDao(database);

    // 加载数据
    _loadYearlyJournals();
  }

  /// 加载今年的周记数据
  Future<void> _loadYearlyJournals() async {
    try {
      setState(() {
        isLoading = true;
      });

      // 获取当前作者
      final currentWriter = await _writerDao.getCurrentWriter();
      if (currentWriter.id == null) {
        throw Exception('当前作者ID为空');
      }

      // 获取今年的所有周记基础信息
      final journals = await _journalDao.getYearlyJournalsSummary(
        currentWriter.id!,
        currentYear,
      );

      setState(() {
        yearlyJournals = journals;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('加载周记数据失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const HomeAppBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : JournalContent(
              currentWeek: currentWeek,
              currentYear: currentYear,
              yearlyJournals: yearlyJournals,
              isEditing: isEditing, // 传递编辑状态
              onEditStateChanged: (editing) {
                setState(() {
                  isEditing = editing;
                });
              },
              onWeekChanged: (week, year) {
                setState(() {
                  currentWeek = week;
                  currentYear = year;
                });
              },
              onDataUpdated: _loadYearlyJournals,
            ),
    );
  }
}

class _SingleWeekViewState extends State<SingleWeekView> {
  late int currentWeek;
  late int currentYear;
  bool isEditing = false; // 编辑状态
  List<WeeklyJournalData> yearlyJournals = [];

  // DAO 实例
  late final JournalWriterDao _writerDao;
  late final WeeklyJournalDao _journalDao;

  @override
  void initState() {
    super.initState();
    // 使用传入的参数初始化
    currentWeek = widget.currentWeek;
    currentYear = widget.currentYear;
    yearlyJournals = List.from(widget.yearlyJournals);

    // 初始化 DAO
    final database = DatabaseManager.instance.database;
    _writerDao = JournalWriterDao(database);
    _journalDao = WeeklyJournalDao(database);
  }

  @override
  void didUpdateWidget(SingleWeekView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果父组件传入的数据发生变化，更新本地数据
    if (widget.yearlyJournals != oldWidget.yearlyJournals) {
      setState(() {
        yearlyJournals = List.from(widget.yearlyJournals);
      });
    }
  }

  /// 重新加载周记数据
  Future<void> _reloadYearlyJournals() async {
    try {
      print('🔄 开始重新加载周记数据...');

      // 获取当前作者
      final currentWriter = await _writerDao.getCurrentWriter();
      if (currentWriter.id == null) {
        print('❌ 当前作者ID为空');
        return;
      }

      print('👤 当前作者ID: ${currentWriter.id}，年份: $currentYear');

      // 获取今年的所有周记基础信息
      final journals = await _journalDao.getYearlyJournalsSummary(
        currentWriter.id!,
        currentYear,
      );

      print('📊 从数据库获取到 ${journals.length} 篇周记');

      // 查找当前周的周记
      final currentWeekJournal = journals.firstWhere(
        (j) => j.weekNumber == currentWeek,
        orElse: () => WeeklyJournalData(
          writerId: currentWriter.id!,
          year: currentYear,
          weekNumber: currentWeek,
          title: '第$currentWeek周',
          content: '',
          mood: -1,
          moodColor: '',
          pics: '',
          geo: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          deletedAt: null,
        ),
      );

      if (currentWeekJournal.id != null) {
        print('🎯 找到当前周($currentWeek)的周记:');
        print('  ID: ${currentWeekJournal.id}');
        print('  心情ID: ${currentWeekJournal.mood}');
        print('  心情颜色: ${currentWeekJournal.moodColor}');
        print('  内容长度: ${currentWeekJournal.content.length}');
      } else {
        print('⚠️  当前周($currentWeek)没有周记数据');
      }

      setState(() {
        yearlyJournals = journals;
      });

      print('✅ 周记数据重新加载完成并更新状态');

      // 打印前几条记录用于调试
      final firstFew = journals.take(5).toList();
      for (final journal in firstFew) {
        print(
            '  周${journal.weekNumber}: mood=${journal.mood}, moodColor=${journal.moodColor}, hasContent=${journal.content.isNotEmpty}');
      }
    } catch (e) {
      print('❌ 重新加载周记数据失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return JournalContent(
      currentWeek: currentWeek,
      currentYear: currentYear,
      yearlyJournals: yearlyJournals,
      isEditing: isEditing,
      // 监听编辑状态变化
      onEditStateChanged: (editing) {
        setState(() {
          isEditing = editing;
        });
      },
      // 监听周数变化
      onWeekChanged: (week, year) {
        setState(() {
          currentWeek = week;
          currentYear = year;
        });
      },
      // 监听数据更新
      onDataUpdated: _reloadYearlyJournals,
    );
  }
}
