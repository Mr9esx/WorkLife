import 'package:flutter/material.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/app_bar/custom_app_bar.dart';
import 'package:WeekLife/core/utils/index.dart';
import 'package:WeekLife/core/utils/database/database_manager.dart';
import 'package:WeekLife/data/dao/journal_writer/journal_writer_dao.dart';
import 'package:WeekLife/data/dao/weekly_journal/weekly_journal_dao.dart';
import 'package:WeekLife/data/models/weekly_journal/weekly_journal_data.dart';
import 'package:WeekLife/core/debug/debug_data_manager.dart';
import 'singleview/single.dart';
import 'package:WeekLife/common/ui/icon/app_icon.dart';

/// Journal 主页面
/// 管理不同的视图切换：单周视角、全年视角、人生视角
class JournalMain extends StatefulWidget {
  final Map<String, dynamic>? params;
  final String? viewType;
  
  const JournalMain({super.key, this.params, this.viewType});

  @override
  State<JournalMain> createState() => _JournalMainState();
}

class _JournalMainState extends State<JournalMain> {
  String _currentViewType = '单周视角'; // 当前视图类型
  
  // 当前周份和年份
  late int _currentWeek;
  late int _currentYear;
  
  // 今年的周记数据
  List<WeeklyJournalData> _yearlyJournals = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  // DAO 实例
  late final JournalWriterDao _writerDao;
  late final WeeklyJournalDao _journalDao;
  
  // 视图类型映射
  Map<String, Widget> _viewWidgets = {};

  @override
  void initState() {
    super.initState();
    _currentViewType = widget.viewType ?? '单周视角';
    
    // 获取当前周份和年份
    final weekInfo = DateUtil.getCurrentWeekOfYear();
    _currentWeek = weekInfo.week;
    _currentYear = weekInfo.year;
    
    // 初始化 DAO
    final database = DatabaseManager.instance.database;
    _writerDao = JournalWriterDao(database);
    _journalDao = WeeklyJournalDao(database);
    
    // 更新调试数据
    _updateDebugData();
    
    // 加载数据（会在完成后初始化视图）
    _loadYearlyJournals();
  }
  
  /// 初始化视图组件映射
  void _initializeViewWidgets() {
    _viewWidgets = {
      '单周视角': SingleWeekView(
        currentWeek: _currentWeek,
        currentYear: _currentYear,
        yearlyJournals: _yearlyJournals,
      ),
      '全年视角': WeekView(
        currentYear: _currentYear,
        yearlyJournals: _yearlyJournals,
      ), 
      '人生视角': LifeView(
        yearlyJournals: _yearlyJournals,
      ),
    };
  }
  
  /// 更新调试数据
  void _updateDebugData() {
    DebugDataManager().setCurrentPageData('Journal Main', {
      'currentYear': _currentYear,
      'currentWeek': _currentWeek,
      'currentViewType': _currentViewType,
      'yearlyJournalsCount': _yearlyJournals.length,
      'isLoading': _isLoading,
      'errorMessage': _errorMessage,
      'hasViewWidgets': _viewWidgets.isNotEmpty,
      'availableViews': _viewWidgets.keys.toList(),
    });
  }
  
  /// 加载今年的周记数据
  Future<void> _loadYearlyJournals() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      print('🔍 开始加载周记数据...');
      print('📅 当前年份: $_currentYear, 当前周: $_currentWeek');
      
      // 检查数据库是否初始化
      if (!DatabaseManager.isInitialized) {
        throw Exception('数据库未初始化');
      }
      
      // 获取当前作者
      print('👤 正在获取当前作者...');
      final currentWriter = await _writerDao.getCurrentWriter();
      print('✅ 获取到当前作者: ${currentWriter.username} (ID: ${currentWriter.id})');
      
      if (currentWriter.id == null) {
        throw Exception('当前作者ID为空');
      }
      
      // 获取今年的所有周记基础信息
      print('📖 正在获取今年的周记数据...');
      final journals = await _journalDao.getYearlyJournalsSummary(
        currentWriter.id!,
        _currentYear,
      );
      print('✅ 获取到 ${journals.length} 篇周记');
      
      setState(() {
        _yearlyJournals = journals;
        _isLoading = false;
        // 重新初始化视图组件以传递新数据
        _initializeViewWidgets();
      });
      
      // 更新调试数据
      _updateDebugData();
      
      print('🎉 周记数据加载完成');
      
    } catch (e, stackTrace) {
      print('❌ 加载周记数据失败: $e');
      print('📊 错误堆栈: $stackTrace');
      setState(() {
        _errorMessage = '加载周记数据失败: $e';
        _isLoading = false;
        // 即使加载失败，也要初始化视图组件（使用空数据）
        _yearlyJournals = [];
        _initializeViewWidgets();
      });
      
      // 更新调试数据
      _updateDebugData();
    }
  }

  @override
  void didUpdateWidget(JournalMain oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewType != oldWidget.viewType && widget.viewType != null) {
      setState(() {
        _currentViewType = widget.viewType!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const HomeAppBar(),
      body: _buildBody(),
    );
  }
  
  /// 构建主体内容
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              '加载周记数据中...',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(
                color: AppColors.secondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadYearlyJournals,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }
    
    return _getCurrentView();
  }

  /// 获取当前视图
  Widget _getCurrentView() {
    if (_viewWidgets.isEmpty) {
      // 如果视图还未初始化，显示加载状态
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }
    return _viewWidgets[_currentViewType] ?? _viewWidgets['单周视角']!;
  }

  /// 切换视图类型
  void switchViewType(String viewType) {
    if (_viewWidgets.containsKey(viewType)) {
      setState(() {
        _currentViewType = viewType;
      });
      // 更新调试数据
      _updateDebugData();
    }
  }
}



/// 全年视图组件（占位符，待实现）
class WeekView extends StatelessWidget {
  final int currentYear;
  final List<WeeklyJournalData> yearlyJournals;
  
  const WeekView({
    super.key,
    required this.currentYear,
    required this.yearlyJournals,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(
            assetName: 'book-01',
            size: 64,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            '全年视角 ($currentYear年)',
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '已有 ${yearlyJournals.length} 篇周记',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '开发中...',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 人生视图组件（占位符，待实现）
class LifeView extends StatelessWidget {
  final List<WeeklyJournalData> yearlyJournals;
  
  const LifeView({
    super.key,
    required this.yearlyJournals,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(
            assetName: 'globe-01-1',
            size: 64,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 16),
          const Text(
            '人生视角',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '总计 ${yearlyJournals.length} 篇周记',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '开发中...',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
} 