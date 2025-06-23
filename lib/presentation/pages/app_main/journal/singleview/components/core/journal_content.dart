import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/text_styles.dart';
import 'package:WeekLife/common/ui/size_styles.dart';
import 'package:WeekLife/common/constants/default_config.dart';
import 'package:WeekLife/common/utils/week_utils.dart';
import '../widgets/selectors/enhanced_week_selector.dart';
import '../widgets/media/photo_manager_picker.dart';
import 'package:WeekLife/presentation/blocs/journal/journal_edit_bloc.dart';

import '../widgets/imageviewer/viewer.dart';
import '../sections/todo_section.dart';
import '../sections/photo_section.dart';
import '../sections/location_section.dart';
import '../widgets/selectors/mood_selector.dart';
import '../widgets/editors/markdown_editor.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:WeekLife/core/utils/permission_manager.dart';
import 'package:WeekLife/data/models/weekly_journal/weekly_journal_data.dart';
import 'package:WeekLife/data/models/todo_record/todo_record_data.dart';
import 'package:WeekLife/data/dao/todo_record_dao.dart';
import 'package:WeekLife/data/dao/journal_writer/journal_writer_dao.dart';
import 'package:WeekLife/data/dao/weekly_journal/weekly_journal_dao.dart';
import 'package:WeekLife/core/utils/database/database_manager.dart';
import '../../logic/todo_business_logic.dart';
import 'package:WeekLife/core/services/reminder_service.dart';
import 'package:WeekLife/data/models/location/location_data.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:WeekLife/common/ui/icon/app_icon.dart';
import 'package:WeekLife/common/ui/icon/app_emoji.dart';
import 'package:WeekLife/data/dao/favorite_journal/favorite_journal_dao.dart';
import 'package:share_plus/share_plus.dart';
import 'package:WeekLife/core/services/location_service_compat.dart';
import 'package:WeekLife/data/repositories/location/location_repo.dart';
import 'package:WeekLife/data/models/location/location_record_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:exif/exif.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:camera/camera.dart';
import 'package:cross_file/cross_file.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/icon/app_icon.dart';
import '../widgets/media/photo_manager_picker.dart';
import '../widgets/media/camera_page.dart';

/// 周记内容组件
/// 使用 forui 组件实现，包含周记编辑、心情选择、照片上传、定位等功能
class JournalContent extends StatefulWidget {
  final int currentWeek;
  final int currentYear;
  final List<WeeklyJournalData> yearlyJournals; // 今年的所有周记数据
  final bool? isEditing; // 外部传入的编辑状态（用于未来周份）
  final Function(bool)? onEditStateChanged; // 回调函数，通知编辑状态变化
  final Function(int, int)? onWeekChanged; // 回调函数，通知周数变化
  final VoidCallback? onDataUpdated; // 回调函数，通知数据已更新，需要重新加载

  const JournalContent({
    super.key,
    required this.currentWeek,
    required this.currentYear,
    required this.yearlyJournals,
    this.isEditing,
    this.onEditStateChanged,
    this.onWeekChanged,
    this.onDataUpdated,
  });

  @override
  State<JournalContent> createState() => _JournalContentState();
}

class _JournalContentState extends State<JournalContent> with TickerProviderStateMixin {
  final TextEditingController _journalController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedMood = DefaultConfig.defaultMood;
  String _selectedMoodEmoji = DefaultConfig.defaultMoodEmoji;
  bool _isLocationEnabled = DefaultConfig.defaultLocationEnabled;
  List<XFile> _selectedImages = [];

  // 用于跟踪正在删除的图片动画
  final Map<int, AnimationController> _deleteAnimations = {};
  // 用于跟踪新添加图片的渐入动画
  final Map<String, AnimationController> _fadeInAnimations = {};

  // 用于跟踪是否刚刚保存成功
  bool _justSaved = false;

  // TODO 相关状态
  List<TodoRecordData> _todoRecords = [];
  bool _isLoadingTodos = false;

  // 定位相关状态
  LocationData? _currentLocation;
  bool _isLoadingLocation = false;
  List<LocationData> _weeklyLocations = [];

  // DAO 实例
  late final TodoRecordDao _todoDao;
  late final JournalWriterDao _writerDao;
  late final WeeklyJournalDao _journalDao;
  late final FavoriteJournalDao _favoriteDao;
  late final LocationRepository _locationRepo;

  // 业务逻辑实例
  late final TodoBusinessLogic _todoBusinessLogic;

  // 定位服务实例
  late final LocationService _locationService;

  // 收藏状态
  bool _isFavorited = false;
  bool _isLoadingFavorite = false;

  // 图标状态
  final bool _isHeartPressed = false;
  final bool _isDotsPressed = false;

  // PhotoSection删除模式状态
  bool _isPhotoDeleteMode = false;

  // 用于磁吸效果的动画控制器
  late AnimationController _snapAnimationController;
  late Animation<double> _snapAnimation;

  @override
  void initState() {
    super.initState();

    // 初始化磁吸动画控制器
    _snapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // 添加滚动监听
    _scrollController.addListener(_handleScroll);

    // 初始化 DAO
    final database = DatabaseManager.instance.database;
    _todoDao = TodoRecordDao(database);
    _writerDao = JournalWriterDao(database);
    _journalDao = WeeklyJournalDao(database);
    _favoriteDao = FavoriteJournalDao(database);

    // 初始化业务逻辑实例
    _todoBusinessLogic = TodoBusinessLogic(
      todoDao: _todoDao,
      writerDao: _writerDao,
      journalDao: _journalDao,
    );

    // 加载当前周的周记数据
    _loadJournalData();

    // 加载 TODO 数据
    _loadTodoRecords();

    // 加载收藏状态
    _loadFavoriteStatus();

    // 加载本周定位记录
    _loadWeeklyLocations();

    // 初始化定位服务实例
    _locationService = LocationService();
  }

  @override
  void didUpdateWidget(JournalContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果周数或年份发生变化，重新加载数据并滚动到顶部
    if (widget.currentWeek != oldWidget.currentWeek || widget.currentYear != oldWidget.currentYear) {
      _loadJournalData();
      _loadTodoRecords(); // 重新加载TODO数据
      _loadFavoriteStatus(); // 重新加载收藏状态
      _loadWeeklyLocations(); // 重新加载定位记录
      _scrollToTop();
    }
  }

  /// 加载周记数据
  void _loadJournalData() {
    // 未来周份不需要加载周记数据，只需要加载TODO数据
    if (WeekUtils.isFutureWeek(widget.currentWeek, widget.currentYear)) {
      print('📅 未来周份 ${widget.currentYear}年第${widget.currentWeek}周，跳过周记数据加载');
      return;
    }

    print('📅 过去/当前周份 ${widget.currentYear}年第${widget.currentWeek}周，加载周记数据');
    context.read<JournalEditBloc>().add(LoadJournalEvent(
          weekNumber: widget.currentWeek,
          year: widget.currentYear,
        ));
  }

  /// 加载 TODO 记录数据
  Future<void> _loadTodoRecords() async {
    if (_isLoadingTodos) return;

    setState(() {
      _isLoadingTodos = true;
    });

    try {
      final todos = await _todoBusinessLogic.loadTodoRecords(widget.currentWeek, widget.currentYear);
      setState(() {
        _todoRecords = todos;
      });
    } catch (e) {
      print('加载 TODO 记录失败: $e');
    } finally {
      setState(() {
        _isLoadingTodos = false;
      });
    }
  }

  /// 加载收藏状态
  Future<void> _loadFavoriteStatus() async {
    if (_isLoadingFavorite) return;

    setState(() {
      _isLoadingFavorite = true;
    });

    try {
      // 检查DAO是否已初始化
      if (!mounted) return;

      // 获取当前作者ID
      final currentWriter = await _writerDao.getCurrentWriter();
      if (currentWriter.id == null) {
        print('❌ 当前作者ID为空，无法加载收藏状态');
        return;
      }

      final writerId = currentWriter.id!;
      final isFavorited = await _favoriteDao.isFavorited(
        weekNumber: widget.currentWeek,
        year: widget.currentYear,
        writerId: writerId,
      );

      if (mounted) {
        setState(() {
          _isFavorited = isFavorited;
        });
      }
    } catch (e) {
      print('加载收藏状态失败: $e');
      // 如果是LateInitializationError，可能是数据库还没准备好
      if (e.toString().contains('LateInitializationError')) {
        print('数据库可能还没准备好，延迟重试...');
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _loadFavoriteStatus();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingFavorite = false;
        });
      }
    }
  }

  /// 保存位置数据到数据库
  Future<void> _saveLocationToDatabase(LocationData location) async {
    try {
      // 获取当前作者ID
      final currentWriter = await _writerDao.getCurrentWriter();
      if (currentWriter.id == null) {
        print('❌ 当前作者ID为空，无法保存定位记录');
        return;
      }

      final writerId = currentWriter.id!;
      final timestamp = location.timestamp.millisecondsSinceEpoch ~/ 1000;

      // 创建定位记录
      final locationRecord = LocationRecordData(
        latitude: location.latitude,
        longitude: location.longitude,
        locationName: location.address,
        accuracy: location.accuracy,
        altitude: location.altitude,
        recordedAt: timestamp,
        userId: writerId,
        createdAt: timestamp,
      );

      await _locationRepo.createLocationRecord(locationRecord);
      print('✅ 定位记录保存成功: ${location.shortAddress}');
    } catch (e) {
      print('❌ 保存定位记录失败: $e');
      rethrow;
    }
  }

  /// 加载本周定位记录
  Future<void> _loadWeeklyLocations() async {
    try {
      // 获取当前作者ID
      final currentWriter = await _writerDao.getCurrentWriter();
      if (currentWriter.id == null) {
        print('❌ 当前作者ID为空，无法加载定位记录');
        return;
      }

      final writerId = currentWriter.id!;

      // 计算本周的开始和结束时间
      final firstDayOfYear = DateTime(widget.currentYear, 1, 1);
      final weekStart = firstDayOfYear.add(Duration(days: (widget.currentWeek - 1) * 7));
      final weekEnd = weekStart.add(const Duration(days: 6));

      // 确保不超出年份范围
      final lastDayOfYear = DateTime(widget.currentYear, 12, 31);
      final actualWeekEnd = weekEnd.isAfter(lastDayOfYear) ? lastDayOfYear : weekEnd;

      final startTimestamp = weekStart.millisecondsSinceEpoch ~/ 1000;
      final endTimestamp = actualWeekEnd.millisecondsSinceEpoch ~/ 1000;

      // 从数据库获取本周的定位记录
      final locationRecords = await _locationRepo.getLocationRecordsByTimeRange(
        writerId,
        startTimestamp,
        endTimestamp,
      );

      // 转换为LocationData格式
      final weeklyLocations = locationRecords.map((record) {
        return LocationData(
          latitude: record.latitude,
          longitude: record.longitude,
          altitude: record.altitude,
          accuracy: record.accuracy,
          address: record.locationName,
          timestamp: DateTime.fromMillisecondsSinceEpoch(record.recordedAt * 1000),
        );
      }).toList();

      if (mounted) {
        setState(() {
          _weeklyLocations = weeklyLocations;
        });
      }
    } catch (e) {
      print('加载本周定位记录失败: $e');
    }
  }

  /// 切换收藏状态
  Future<void> _toggleFavorite() async {
    if (_isLoadingFavorite) return;

    setState(() {
      _isLoadingFavorite = true;
    });

    try {
      // 检查DAO是否已初始化
      if (!mounted) return;

      // 获取当前作者ID
      final currentWriter = await _writerDao.getCurrentWriter();
      if (currentWriter.id == null) {
        print('❌ 当前作者ID为空，无法切换收藏状态');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('用户信息异常，请重试'),
              duration: Duration(seconds: 1),
            ),
          );
        }
        return;
      }

      final writerId = currentWriter.id!;
      final newFavoriteStatus = await _favoriteDao.toggleFavorite(
        weekNumber: widget.currentWeek,
        year: widget.currentYear,
        writerId: writerId,
      );

      if (mounted) {
        setState(() {
          _isFavorited = newFavoriteStatus;
        });

        // 显示提示信息
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newFavoriteStatus ? '已添加到收藏' : '已取消收藏'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print('切换收藏状态失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('操作失败: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingFavorite = false;
        });
      }
    }
  }

  /// 滚动到顶部
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _snapAnimationController.dispose();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _journalController.dispose();
    // 清理所有动画控制器
    for (var controller in _deleteAnimations.values) {
      controller.dispose();
    }
    _deleteAnimations.clear();
    for (var controller in _fadeInAnimations.values) {
      controller.dispose();
    }
    _fadeInAnimations.clear();
    super.dispose();
  }

  /// 处理滚动事件，实现磁吸效果
  void _handleScroll() {
    // if (!_scrollController.hasClients) return;

    // final offset = _scrollController.offset;
    // // 如果滚动位置在30像素以内，触发磁吸效果
    // if (offset > 0 && offset < 30) {
    //   _snapToTop();
    // }
  }

  /// 滚动到顶部的磁吸效果
  void _snapToTop() {
    // 设置动画
    _snapAnimation = Tween<double>(
      begin: _scrollController.offset,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _snapAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // 添加动画监听
    void animationListener() {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_snapAnimation.value);
      }
    }

    _snapAnimation.addListener(animationListener);

    // 开始动画
    _snapAnimationController.forward(from: 0.0).then((_) {
      _snapAnimation.removeListener(animationListener);
      _snapAnimationController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击空白区域收起键盘
        FocusScope.of(context).unfocus();

        // 如果PhotoSection处于删除模式，退出删除模式
        if (_isPhotoDeleteMode) {
          // 通过回调通知PhotoSection退出删除模式
          // 这里需要通过其他方式通知，因为我们没有直接的引用
          setState(() {
            _isPhotoDeleteMode = false;
          });
        }
      },
      child: BlocListener<JournalEditBloc, JournalEditState>(
        listener: (context, state) {
          // 通知父组件编辑状态变化（现在总是false，因为没有编辑模式）
          if (widget.onEditStateChanged != null) {
            widget.onEditStateChanged!(false);
          }

          // 处理状态变化
          if (state is JournalViewState) {
            print('📝 收到JournalViewState，_justSaved: $_justSaved, hasCallback: ${widget.onDataUpdated != null}');

            // 更新本地状态
            _updateLocalState(state);

            // 如果是刚刚保存成功，通知父组件重新加载数据
            if (_justSaved && widget.onDataUpdated != null) {
              _justSaved = false; // 重置标志
              print('✅ 保存完成，通知父组件更新周选择器');
              // 立即执行回调，无需延迟
              if (mounted && widget.onDataUpdated != null) {
                print('🔄 执行onDataUpdated回调');
                widget.onDataUpdated!();
              }
            } else {
              print('⚠️ 不满足回调条件: _justSaved=$_justSaved, hasCallback=${widget.onDataUpdated != null}');
            }
          } else if (state is JournalSavingState) {
            // 设置保存标志
            _justSaved = true;

            // 执行实际的保存操作
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) {
                // 准备位置信息
                String locationJson = '';
                if (_isLocationEnabled && _currentLocation != null) {
                  locationJson = _currentLocation!.toJson();
                }

                context.read<JournalEditBloc>().add(SaveJournalEvent(
                      content: _journalController.text,
                      mood: _selectedMood,
                      moodEmoji: _selectedMoodEmoji,
                      isLocationEnabled: _isLocationEnabled,
                      imagePaths: _selectedImages.map((e) => e.path).toList(),
                      locationData: locationJson,
                    ));
              }
            });
          } else if (state is JournalErrorState) {
            // 重置保存标志
            _justSaved = false;
            // 显示错误信息
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部区域（周选择器、分隔线、周标题）- 所有周份都相同
              Padding(
                padding: const EdgeInsets.all(GlobalSize.primaryPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWeekSelector(),
                    const SizedBox(height: 16),
                    Container(
                      height: 1,
                      color: AppColors.borderColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    _buildUnifiedWeekHeader(),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // 内容区域 - 根据周份类型显示不同内容
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: GlobalSize.primaryPadding),
                    child: Column(
                      children: [
                        // 根据是否是未来周份显示不同的内容
                        if (WeekUtils.isFutureWeek(widget.currentWeek, widget.currentYear)) ...[
                          // 未来周份只显示 TODO
                          _buildFutureTodoSection(),
                        ] else ...[
                          // 过去和当前周份显示完整内容
                          _buildJournalSection(),
                          const SizedBox(height: 24),
                          _buildPhotoSection(),
                          const SizedBox(height: 24),
                          _buildTodoSection(),
                          const SizedBox(height: 24),
                          _buildLocationSection(),
                        ],
                        const SizedBox(height: 118),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 更新本地状态
  void _updateLocalState(dynamic state) {
    if (state is JournalViewState) {
      setState(() {
        _journalController.text = state.content;
        _selectedMood = state.mood;
        _selectedMoodEmoji = state.moodEmoji;
        _isLocationEnabled = state.isLocationEnabled;

        // 更新图片列表
        _selectedImages.clear();
        for (String path in state.imagePaths) {
          // 检查文件是否存在
          final file = File(path);
          if (file.existsSync()) {
            _selectedImages.add(XFile(path));
          } else {
            print('图片文件不存在: $path');
          }
        }
        print('加载了 ${_selectedImages.length} 张图片');

        // 加载位置信息
        _loadLocationFromState(state);
      });
    }
  }

  /// 从状态中加载位置信息
  void _loadLocationFromState(dynamic state) {
    if (state is JournalViewState && state.journalData != null) {
      final geoString = state.journalData!.geo;
      if (geoString.isNotEmpty && geoString != '{}') {
        try {
          _currentLocation = LocationData.fromJson(geoString);
          print('📍 加载了保存的位置信息: ${_currentLocation!.shortAddress}');
        } catch (e) {
          print('📍 解析位置信息失败: $e');
          _currentLocation = null;
        }
      } else {
        _currentLocation = null;
      }
    } else {
      _currentLocation = null;
    }
  }

  /// 构建统一的周标题（适应所有周份类型）
  Widget _buildUnifiedWeekHeader() {
    final isFutureWeek = WeekUtils.isFutureWeek(widget.currentWeek, widget.currentYear);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 主标题行和操作图标行
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 左侧标题区域
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 周标题
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${widget.currentYear} 年第',
                        style: AppTextStyles.journalWeekHeaderYear,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.currentWeek}',
                            style: AppTextStyles.journalWeekHeaderNumber.copyWith(
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '周',
                        style: AppTextStyles.journalWeekHeaderYear,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 状态文本
                  if (isFutureWeek)
                    SizedBox(
                      height: 16, // 固定高度，确保与其他状态文本高度一致
                      child: Text(
                        '未来计划',
                        style: AppTextStyles.placeholderText.copyWith(
                          height: 1.0, // 固定行高，防止文本内容影响高度
                        ),
                      ),
                    )
                  else
                    // 过去和当前周份显示周记状态，但需要从外部获取状态而不是BlocBuilder
                    _buildJournalStatus(),
                ],
              ),
            ),
            // 右侧操作图标区域
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 心情图标 - 未来周份不显示
                if (!isFutureWeek) ...[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        _showMoodSelector();
                      },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: AppColors.primary.withOpacity(0.3),
                      highlightColor: AppColors.primary.withOpacity(0.2),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AppEmoji(
                          assetName: _selectedMoodEmoji,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                // 心形图标 - 未来周份不显示
                if (!isFutureWeek) ...[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isLoadingFavorite
                          ? null
                          : () {
                              HapticFeedback.selectionClick();
                              _toggleFavorite();
                            },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: AppColors.primary.withOpacity(0.3),
                      highlightColor: AppColors.primary.withOpacity(0.2),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: _isLoadingFavorite
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary.withOpacity(0.6),
                                  ),
                                ),
                              )
                            : AppIcon(
                                assetName: _isFavorited ? 'heart-filled' : 'heart',
                                size: 22,
                                color: _isFavorited ? AppColors.primary : AppColors.primary,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                // 三点图标 - 始终显示
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      _showMoreOptions();
                    },
                    borderRadius: BorderRadius.circular(20),
                    splashColor: AppColors.primary.withOpacity(0.3),
                    highlightColor: AppColors.primary.withOpacity(0.2),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const AppIcon(
                        assetName: 'dot-vertical',
                        size: 22,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// 构建周记状态显示（不依赖BlocBuilder）
  Widget _buildJournalStatus() {
    return BlocBuilder<JournalEditBloc, JournalEditState>(
      builder: (context, state) {
        // 从yearlyJournals中查找当前周的周记数据
        final currentWeekJournal =
            widget.yearlyJournals.where((journal) => journal.weekNumber == widget.currentWeek).firstOrNull;

        String statusText;
        if (currentWeekJournal != null) {
          // 存在周记的情况
          if (currentWeekJournal.updatedAt != null && currentWeekJournal.updatedAt != currentWeekJournal.createdAt) {
            // 有修改时间且不等于创建时间，显示修改时间
            statusText = '修改于 ${_formatDateTime(currentWeekJournal.updatedAt!)}';
          } else {
            // 没有修改时间或修改时间等于创建时间，显示创建时间
            statusText = '记录于 ${_formatDateTime(currentWeekJournal.createdAt)}';
          }
        } else {
          // 不存在周记的情况
          statusText = '未记录';
        }

        return SizedBox(
          height: 16, // 固定高度，确保所有状态文本高度一致
          child: Text(
            statusText,
            style: AppTextStyles.placeholderText.copyWith(
              height: 1.0, // 固定行高，防止文本内容影响高度
            ),
          ),
        );
      },
    );
  }

  /// 格式化日期时间显示
  String _formatDateTime(DateTime dateTime) {
    // 统一使用 年/月/日 时:分:秒 格式
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  /// 构建周记部分（支持 Markdown）
  Widget _buildJournalSection() {
    return BlocBuilder<JournalEditBloc, JournalEditState>(
      builder: (context, state) {
        // 现在总是可以编辑
        const isEditing = true;
        String content = '';

        if (_journalController.text.isNotEmpty) {
          content = _journalController.text;
        } else if (state is JournalViewState) {
          content = state.content;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 周记输入框容器
            _buildJournalContainer(content, isEditing),
          ],
        );
      },
    );
  }

  /// 构建周记容器（根据内容是否为空决定是否显示动画）
  Widget _buildJournalContainer(String content, bool isEditing) {
    final hasContent = content.isNotEmpty;

    // 先构建基础容器
    Widget baseContainer = Container(
      width: double.infinity,
      // 根据是否有内容决定高度：无内容时固定180，有内容时自适应
      height: hasContent ? null : 120,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        // 无内容时显示背景色以便动画可见，有内容时透明
        color: hasContent ? AppColors.secondary.withOpacity(0.0) : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          // 主要内容区域
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: hasContent ? MainAxisSize.min : MainAxisSize.max,
              children: [
                // 有内容时不使用 Expanded，让内容自然撑开高度
                hasContent
                    ? _buildJournalContentWidget(content, isEditing)
                    : Expanded(
                        child: Center(
                          child: _buildJournalContentWidget(content, isEditing),
                        ),
                      ),
              ],
            ),
          ),

          // 左上角引号图标
          Positioned(
            top: 0,
            left: 0,
            child: _buildQuoteIcon(true),
          ),

          // 右下角引号图标
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildQuoteIcon(false),
          ),

          // 中间提示 - 仅在无内容且编辑模式下显示
          if (!hasContent && isEditing)
            const Positioned.fill(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcon(
                      assetName: 'cursor-04',
                      size: 26,
                      color: AppColors.secondary,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '双击记录...',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 14,
                        fontFamily: 'MiSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 整个容器的双击检测覆盖层 - 仅在编辑模式下显示
          if (isEditing)
            Positioned.fill(
              child: GestureDetector(
                onDoubleTap: () {
                  HapticFeedback.lightImpact();
                  _showMarkdownEditor(context);
                },
                // 使用translucent行为，让手势能够同时被多个组件处理
                behavior: HitTestBehavior.translucent,
                // 不处理其他手势，专注于双击
                onTap: null,
                onLongPress: null,
                onTapDown: null,
                onTapUp: null,
                onTapCancel: null,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
        ],
      ),
    );

    // 无内容时添加shimmer动画效果
    if (!hasContent) {
      baseContainer = baseContainer
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(duration: 2000.ms, color: AppColors.secondary.withOpacity(0.15), size: 3)
          .animate();
    }

    return baseContainer;
  }

  /// 构建引号图标
  Widget _buildQuoteIcon(bool isTopLeft) {
    print('🔤 构建引号图标: ${isTopLeft ? "左上角" : "右下角"}');

    Widget quoteIcon = const AppIcon(
      assetName: 'quote',
      size: 20,
      color: AppColors.primary,
    );

    // 右下角的引号旋转180度，表示结束引号
    if (!isTopLeft) {
      quoteIcon = Transform.rotate(
        angle: 3.14159, // 180度 (π 弧度)
        child: quoteIcon,
      );
    }

    return quoteIcon;
  }

  /// 构建周记内容组件
  Widget _buildJournalContentWidget(String content, bool isEditing) {
    final hasContent = content.isNotEmpty;

    if (hasContent) {
      // 有内容时显示Markdown渲染的内容，支持文本选择
      // 双击检测由外层容器处理
      return SelectionArea(
        child: MarkdownBody(
          data: content.replaceAll('\n', '  \n'), // 确保换行正确显示
          styleSheet: _getMarkdownStyleSheet(),
          selectable: true, // 启用文本选择
          shrinkWrap: true, // 让内容自适应高度
        ),
      );
    } else {
      // 无内容时不显示任何文本，双击检测由外层容器处理
      return const SizedBox.shrink();
    }
  }

  /// 显示 Markdown 编辑器
  void _showMarkdownEditor(BuildContext context) {
    // 触发触觉反馈
    HapticFeedback.lightImpact();

    print('📝 显示 Markdown 编辑器');
    final currentContent = _journalController.text;
    print('  当前内容长度: ${currentContent.length}');
    print('  当前内容预览: ${currentContent.length > 50 ? '${currentContent.substring(0, 50)}...' : currentContent}');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MarkdownEditor(
        initialText: currentContent,
        onSave: (newContent) {
          print('📝 周记内容已更新');
          print('  新内容长度: ${newContent.length}');
          print('  新内容预览: ${newContent.length > 50 ? '${newContent.substring(0, 50)}...' : newContent}');

          // 更新控制器内容
          _journalController.text = newContent;

          // 即时保存周记内容
          _saveJournalContentData(newContent);
        },
      ),
    );
  }

  /// 显示心情选择器
  void _showMoodSelector() {
    final options = DefaultConfig.defaultMoodOptions;

    print('🎭 显示心情选择器');
    print('  当前选中的心情: $_selectedMood');
    print('  当前选中的emoji: $_selectedMoodEmoji');
    print('  可选心情选项:');
    for (final option in options) {
      print('    ${option.emoji} ${option.name}');
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MoodSelector(
        selectedMood: _selectedMood,
        selectedMoodEmoji: _selectedMoodEmoji,
        onMoodSelected: (mood, emoji) {
          print('🎭 用户选择了心情: $mood ($emoji)');
          print('⚡ 立即更新本地状态');
          setState(() {
            _selectedMood = mood;
            _selectedMoodEmoji = emoji;
          });
          print('💾 开始异步保存心情数据');
          // 即时保存心情
          _saveMoodData(mood, emoji);
        },
        moodOptions: options,
      ),
    );
  }

  /// 获取统一的 Markdown 样式配置
  MarkdownStyleSheet _getMarkdownStyleSheet() {
    return MarkdownStyleSheet(
      p: AppTextStyles.markdownParagraph,
      h1: AppTextStyles.markdownH1,
      h2: AppTextStyles.markdownH2,
      h3: AppTextStyles.markdownH3,
      h4: AppTextStyles.markdownH4,
      h5: AppTextStyles.markdownH5,
      strong: AppTextStyles.markdownStrong,
      em: AppTextStyles.markdownEmphasis,
      code: AppTextStyles.markdownCode,
      codeblockDecoration: BoxDecoration(
        color: AppColors.appBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      codeblockPadding: const EdgeInsets.all(GlobalSize.primaryPadding),
      blockquote: AppTextStyles.markdownBlockquote,
      blockquoteDecoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          left: BorderSide(
            color: AppColors.primary.withOpacity(0.3),
            width: 4,
          ),
        ),
      ),
      blockquotePadding: const EdgeInsets.symmetric(
        horizontal: GlobalSize.primaryPadding,
        vertical: GlobalSize.secondaryPadding,
      ),
      listBullet: AppTextStyles.markdownListBullet,
      // 表格样式配置
      tableHead: AppTextStyles.markdownParagraph.copyWith(
        fontWeight: FontWeight.w600,
      ),
      tableBody: AppTextStyles.markdownParagraph,
      tableBorder: TableBorder.all(
        color: AppColors.borderColor, // 使用边框颜色而不是红色
        width: 1,
      ),
      tableCellsPadding: const EdgeInsets.all(8),
      tableColumnWidth: const FlexColumnWidth(),
      // 分割线样式配置
      horizontalRuleDecoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.borderColor, // 使用边框颜色而不是红色
            width: 1,
          ),
        ),
      ),
    );
  }

  /// 构建照片部分
  Widget _buildPhotoSection() {
    return PhotoSection(
      images: _selectedImages,
      isEditing: true, // 现在总是可以编辑
      onImagesChanged: (newImages) {
        setState(() {
          _selectedImages = newImages;
        });
        // 即时保存照片
        _savePhotosData(newImages);
      },
      onAddPhoto: _addPhoto,
      onRemovePhoto: (index) async {
        // 删除对应的图片文件
        if (index < _selectedImages.length) {
          final imagePath = _selectedImages[index].path;
          await _deleteImageFile(imagePath);
          print('照片已删除，索引: $index, 路径: $imagePath');
        }
      },
      onImageTap: (index) {
        _showFullScreenImage(index);
      },
      onDeleteModeChanged: (isDeleteMode) {
        setState(() {
          _isPhotoDeleteMode = isDeleteMode;
        });
      },
      externalDeleteMode: _isPhotoDeleteMode,
    );
  }

  /// 构建定位部分
  Widget _buildLocationSection() {
    return BlocBuilder<JournalEditBloc, JournalEditState>(
      builder: (context, state) {
        const isEditing = true; // 现在总是可以编辑

        return LocationSection(
          isLocationEnabled: _isLocationEnabled,
          weeklyLocations: _weeklyLocations,
          currentLocation: _currentLocation,
          isLoadingLocation: _isLoadingLocation,
          isEditing: isEditing,
          onLocationToggle: (enabled) async {
            if (enabled) {
              // 开启定位时，检查权限并获取位置
              await _enableLocation();
            } else {
              // 关闭定位
              setState(() {
                _isLocationEnabled = false;
                _currentLocation = null;
              });

              // 立即保存定位关闭状态
              _saveLocationData(false, null);
            }
          },
          onManualRecord: () async {
            // 手动记录当前位置
            await _manualRecordLocation();
          },
          onRetryLocation: _enableLocation,
        );
      },
    );
  }

  /// 手动记录当前位置
  Future<void> _manualRecordLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // 检查定位权限
      bool hasPermission = await _locationService.checkLocationPermission();
      if (!hasPermission) {
        setState(() {
          _isLoadingLocation = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('请先开启定位权限'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // 检查定位服务
      final serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoadingLocation = false;
        });
        if (mounted) {
          _showLocationServiceDialog();
        }
        return;
      }

      // 获取当前位置
      final location = await _locationService.getCurrentLocation(
        useCache: false, // 手动记录时不使用缓存，获取最新位置
        includeAddress: true,
      );

      if (location != null) {
        setState(() {
          _currentLocation = location;
          _isLoadingLocation = false;
        });

        // 保存位置数据到数据库
        await _saveLocationToDatabase(location);

        // 重新加载本周定位记录以更新显示
        await _loadWeeklyLocations();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('位置记录成功: ${location.shortAddress}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        setState(() {
          _isLoadingLocation = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('位置获取失败，请重试'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('位置记录失败: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// 启用定位功能
  Future<void> _enableLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // 检查并请求定位权限
      bool hasPermission = await _locationService.checkLocationPermission();
      print('📍 初始权限检查: $hasPermission');

      if (!hasPermission) {
        if (mounted) {
          // 先检查权限状态，如果是永久拒绝，直接引导到设置
          final permissionStatus = await PermissionManager.checkPermissionStatus(Permission.location);
          print('📍 权限状态: ${PermissionManager.getPermissionStatusText(permissionStatus)}');

          if (permissionStatus == PermissionStatus.permanentlyDenied) {
            print('📍 权限被永久拒绝，引导用户到设置');
            setState(() {
              _isLoadingLocation = false;
            });
            _showLocationPermissionFailedDialog();
            return;
          }

          print('📍 显示权限授权对话框');
          final granted = await PermissionManager.showPermissionDialog(
            context,
            permissionName: '位置',
            description: '为了记录您的位置信息，需要获取位置权限。这将帮助您更好地记录生活轨迹。',
            permission: Permission.location,
          );

          print('📍 权限对话框结果: $granted');

          if (granted != true) {
            print('📍 权限授权失败');
            setState(() {
              _isLoadingLocation = false;
            });

            // 检查最新的权限状态，如果多次拒绝，显示引导对话框
            final latestStatus = await PermissionManager.checkPermissionStatus(Permission.location);
            print('📍 最新权限状态: ${PermissionManager.getPermissionStatusText(latestStatus)}');

            // 如果权限被拒绝（无论是普通拒绝还是永久拒绝），都显示引导对话框
            if (latestStatus == PermissionStatus.permanentlyDenied || latestStatus == PermissionStatus.denied) {
              if (mounted) {
                _showLocationPermissionFailedDialog();
              }
            }
            return;
          }

          // 等待一小段时间让权限生效
          await Future.delayed(const Duration(milliseconds: 500));

          // 权限授权成功后，重新检查权限状态
          hasPermission = await _locationService.checkLocationPermission();
          print('📍 重新检查权限状态: $hasPermission');

          if (!hasPermission) {
            // 如果仍然没有权限，引导用户到设置
            print('📍 权限仍然被拒绝，引导用户到设置');
            setState(() {
              _isLoadingLocation = false;
            });
            if (mounted) {
              _showLocationPermissionFailedDialog();
            }
            return;
          }
        } else {
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      // 检查定位服务
      final serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          _showLocationServiceDialog();
        }
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      // 获取位置信息
      final location = await _locationService.getCurrentLocation(
        useCache: true,
        includeAddress: true,
      );

      if (location != null) {
        setState(() {
          _isLocationEnabled = true;
          _currentLocation = location;
          _isLoadingLocation = false;
        });

        // 立即保存位置状态变化
        _saveLocationData(true, location);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('位置获取成功: ${location.shortAddress}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        setState(() {
          _isLocationEnabled = false;
          _isLoadingLocation = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('位置获取失败，请检查网络连接'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLocationEnabled = false;
        _isLoadingLocation = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('定位失败: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// 显示定位权限失败对话框
  void _showLocationPermissionFailedDialog() {
    print('📍 显示权限失败对话框');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('权限授权失败'),
        content: const Text('位置权限可能被永久拒绝，请在系统设置中手动开启位置权限。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _locationService.openAppSettings();
            },
            child: const Text('去设置'),
          ),
        ],
      ),
    );
  }

  /// 显示定位服务对话框
  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('需要开启定位服务'),
        content: const Text('请在系统设置中开启定位服务。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _locationService.openLocationSettings();
            },
            child: const Text('去设置'),
          ),
        ],
      ),
    );
  }

  /// 显示更多选项弹窗
  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true, // 允许点击外部关闭
      enableDrag: true, // 允许拖拽关闭
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.appBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), // 统一使用16的圆角
              topRight: Radius.circular(16),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 拖拽指示器
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // 选择选项
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20), // 统一使用20的边距
                  child: Column(
                    children: [
                      // 分享周记选项
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.pop(context); // 关闭弹窗
                          _shareJournal(); // 调用分享方法
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(GlobalSize.primaryPadding),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppIcon(
                                assetName: 'cursor-arrow',
                                color: AppColors.primary,
                                size: 24,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '分享周记',
                                      style: AppTextStyles.imageOptionTitle,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '将周记内容分享给朋友',
                                      style: AppTextStyles.imageOptionDescription,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: GlobalSize.primaryPadding + GlobalSize.secondaryPadding),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 分享周记内容
  void _shareJournal() async {
    try {
      // 构建分享内容
      final StringBuffer shareContent = StringBuffer();

      // 添加标题
      shareContent.writeln('📖 ${widget.currentYear}年第${widget.currentWeek}周的周记');
      shareContent.writeln('');

      // 添加心情
      if (_selectedMood != DefaultConfig.defaultMood) {
        shareContent.writeln('😊 心情：$_selectedMood');
        shareContent.writeln('');
      }

      // 添加周记内容
      if (_journalController.text.isNotEmpty) {
        shareContent.writeln('📝 周记内容：');
        shareContent.writeln(_journalController.text);
        shareContent.writeln('');
      }

      // 添加TODO完成情况
      if (_todoRecords.isNotEmpty) {
        final completedTodos = _todoRecords.where((todo) => todo.isCompleted).length;
        final totalTodos = _todoRecords.length;
        shareContent.writeln('✅ TODO完成情况：$completedTodos/$totalTodos');

        // 列出未完成的TODO
        final incompleteTodos = _todoRecords.where((todo) => !todo.isCompleted).toList();
        if (incompleteTodos.isNotEmpty) {
          shareContent.writeln('');
          shareContent.writeln('📋 待完成事项：');
          for (final todo in incompleteTodos) {
            shareContent.writeln('• ${todo.content}');
          }
        }
        shareContent.writeln('');
      }

      // 添加定位信息
      if (_isLocationEnabled && _currentLocation != null) {
        shareContent.writeln('📍 位置：${_currentLocation!.address ?? '未知位置'}');
        shareContent.writeln('');
      }

      // 添加应用签名
      shareContent.writeln('✨ 来自 WeekLife 生活记录应用');

      // 执行分享
      await Share.share(
        shareContent.toString(),
        subject: '${widget.currentYear}年第${widget.currentWeek}周的周记',
      );

      print('📤 周记分享成功');
    } catch (e) {
      print('❌ 分享周记失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('分享失败: $e')),
        );
      }
    }
  }

  /// 添加照片（只支持多选）
  void _addPhoto() async {
    if (_selectedImages.length >= 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('最多只能选择9张照片')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true, // 允许点击外部关闭
      enableDrag: true, // 允许拖拽关闭
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.appBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), // 统一使用16的圆角
              topRight: Radius.circular(16),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 拖拽指示器
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // 选择选项
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20), // 统一使用20的边距
                  child: Column(
                    children: [
                      // 拍照选项
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.pop(context); // 关闭弹窗
                          _pickImageWithCamera(); // 调用拍照方法
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(GlobalSize.primaryPadding),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppIcon(
                                assetName: 'camera-01',
                                color: AppColors.primary, // 卡片背景色
                                size: 24,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '拍照',
                                      style: AppTextStyles.imageOptionTitle,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '使用相机拍摄新照片',
                                      style: AppTextStyles.imageOptionDescription,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: GlobalSize.secondaryPadding),

                      // 从相册选择选项
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.pop(context); // 关闭弹窗
                          _pickImagesWithPhotoManager(); // 调用相册选择方法
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(GlobalSize.primaryPadding),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const AppIcon(
                                assetName: 'image-02',
                                color: AppColors.primary, // 卡片背景色
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '从相册选择',
                                      style: AppTextStyles.imageOptionTitle,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _selectedImages.isNotEmpty ? '支持显示已选中的图片状态 ✨' : '从相册中选择图片',
                                      style: AppTextStyles.imageOptionDescription,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: GlobalSize.primaryPadding + GlobalSize.secondaryPadding),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 拍照获取图片
  void _pickImageWithCamera() async {
    try {
      // 获取可用相机列表
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('没有可用的相机');
      }

      if (!mounted) return;

      // 打开相机页面
      final XFile? imageFile = await Navigator.of(context).push<XFile>(
        MaterialPageRoute(
          builder: (context) => CameraPage(camera: cameras.first),
        ),
      );

      if (imageFile != null && mounted) {
        try {
          // 读取原始文件的EXIF信息并验证
          final bytes = await imageFile.readAsBytes();
          final exifData = await readExifFromBytes(bytes);

          print('📊 EXIF信息统计:');
          if (exifData.isEmpty) {
            print('⚠️ 警告：未检测到EXIF信息');
          } else {
            print('✅ 检测到 ${exifData.length} 个EXIF标签');
            // 检查关键EXIF标签
            final hasAperture = exifData['EXIF FNumber'] != null ||
                exifData['FNumber'] != null ||
                exifData['EXIF ApertureValue'] != null;
            print('📸 光圈信息: ${hasAperture ? '存在' : '缺失'}');
          }

          // 复制图片到应用目录（使用字节流复制以保留EXIF）
          final appDocDir = await getApplicationDocumentsDirectory();
          final imagesDir = Directory(path.join(appDocDir.path, 'images'));
          if (!await imagesDir.exists()) {
            await imagesDir.create(recursive: true);
          }

          final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          final String newPath = path.join(imagesDir.path, 'IMG_$timestamp.jpg');

          // 使用字节流复制以保留所有元数据
          await File(newPath).writeAsBytes(bytes);

          // 验证复制后的EXIF信息
          final copiedBytes = await File(newPath).readAsBytes();
          final copiedExif = await readExifFromBytes(copiedBytes);

          print('📊 复制后EXIF信息验证:');
          print('✅ 原始EXIF标签数: ${exifData.length}');
          print('✅ 复制后EXIF标签数: ${copiedExif.length}');

          if (mounted) {
            setState(() {
              _selectedImages.add(XFile(newPath));
            });
            // 保存图片变化
            await _savePhotosData(_selectedImages);
          }
        } catch (e) {
          print('❌ 处理拍照图片失败: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('处理拍照图片失败: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      print('❌ 拍照失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('拍照失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 使用自定义 PhotoManager 选择器选择图片
  void _pickImagesWithPhotoManager() async {
    try {
      // 先检查权限状态
      final hasPermission = await PermissionManager.checkPhotoPermission();

      if (!hasPermission) {
        // 显示权限授权弹窗
        final granted = await PermissionManager.showPhotoPermissionDialog(context);
        if (granted != true) {
          // 用户拒绝授权
          return;
        }
      }

      final List<XFile>? result = await showModalBottomSheet<List<XFile>>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => PhotoManagerPicker(
          selectedImages: _selectedImages,
          maxCount: 9,
          topMargin: 115,
        ),
      );

      if (result != null && mounted) {
        // 直接使用返回的结果，因为 PhotoManagerPicker 已经处理了图片复制
        setState(() {
          _selectedImages = result;
        });

        // 立即保存图片变化
        _savePhotosData(_selectedImages);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('图片选择失败: $e'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  /// 添加图片并播放渐入动画
  void _addImageWithFadeIn(XFile image) async {
    try {
      // 复制图片到应用目录
      final copiedImage = await _copyImageToAppDirectory(image);

      // 创建渐入动画控制器
      final AnimationController fadeInController = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );

      setState(() {
        _selectedImages.add(copiedImage);
        _fadeInAnimations[copiedImage.path] = fadeInController;
      });

      // 立即保存图片变化
      _savePhotosData(_selectedImages);

      // 开始渐入动画
      fadeInController.forward().then((_) {
        // 动画完成后清理控制器
        if (mounted) {
          setState(() {
            _fadeInAnimations.remove(copiedImage.path);
            fadeInController.dispose();
          });
        }
      });
    } catch (e) {
      print('复制图片失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存图片失败: $e')),
        );
      }
    }
  }

  /// 将图片复制到应用的文档目录中
  Future<XFile> _copyImageToAppDirectory(XFile image) async {
    // 获取应用文档目录
    final appDocDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(path.join(appDocDir.path, 'images'));

    // 确保图片目录存在
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    // 生成唯一的文件名
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final originalExtension = path.extension(image.path);
    final newFileName = 'image_$timestamp$originalExtension';
    final newPath = path.join(imagesDir.path, newFileName);

    try {
      // 读取原始文件的字节数据（包含EXIF信息）
      final originalFile = File(image.path);
      final bytes = await originalFile.readAsBytes();

      // 直接写入新文件，保留所有原始数据（包括EXIF）
      final newFile = File(newPath);
      await newFile.writeAsBytes(bytes, flush: true);

      print('📸 图片已复制到: $newPath');
      print('📝 EXIF信息已完整保留');

      // 验证EXIF信息
      try {
        final exifData = await readExifFromBytes(bytes);
        if (exifData.isNotEmpty) {
          print('✅ EXIF信息验证成功: ${exifData.length} 个标签');
          exifData.forEach((key, value) {
            if (key.contains('FNumber') ||
                key.contains('FocalLength') ||
                key.contains('ISOSpeed') ||
                key.contains('ExposureTime')) {
              print('  $key: ${value.printable}');
            }
          });
        }
      } catch (e) {
        print('⚠️ EXIF信息验证失败: $e');
      }

      return XFile(newFile.path);
    } catch (e) {
      print('❌ 复制图片失败: $e');
      rethrow;
    }
  }

  /// 删除图片文件（当从周记中移除图片时）
  Future<void> _deleteImageFile(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        print('🗑️ 已删除图片文件: $imagePath');
      }
    } catch (e) {
      print('删除图片文件失败: $e');
    }
  }

  /// 显示全屏图片查看器
  void _showFullScreenImage(int initialIndex) {
    if (_selectedImages.isEmpty || initialIndex < 0 || initialIndex >= _selectedImages.length) {
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ImageViewer(
          images: _selectedImages,
          initialIndex: initialIndex,
          onPageChanged: (index) {
            // 可以在这里处理页面切换事件
            print('图片查看器切换到第 ${index + 1} 张图片');
          },
          onClose: () {
            // 可以在这里处理关闭事件
            print('图片查看器已关闭');
          },
        ),
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        opaque: false,
      ),
    );
  }

  /// 构建周选择器（使用统一的状态管理方式）
  Widget _buildWeekSelector() {
    return EnhancedWeekSelector(
      key: ValueKey('week_selector_${widget.currentYear}'), // 添加稳定的key
      currentWeek: widget.currentWeek,
      year: widget.currentYear,
      yearlyJournals: widget.yearlyJournals,
      isYearCompleted: widget.currentYear < DateTime.now().year,
      height: 56,
      itemWidth: 45,
      spacing: 6,
      isEditingMode: false, // 现在没有编辑模式，总是可以切换
      onWeekSelected: (week) {
        // 现在总是允许切换
        if (widget.onWeekChanged != null) {
          widget.onWeekChanged!(week, widget.currentYear);
        }
      },
    );
  }

  /// 构建TODO记录部分（适用于所有周份）
  Widget _buildTodoSection() {
    return BlocBuilder<JournalEditBloc, JournalEditState>(
      builder: (context, state) {
        const isEditing = true; // 现在总是可以编辑

        return TodoSection(
          currentWeek: widget.currentWeek,
          currentYear: widget.currentYear,
          todos: _todoRecords,
          isLoading: _isLoadingTodos,
          isEditing: isEditing, // 传递编辑状态
          onAddTodo: (content, priority, reminderTime) => _addTodoData(content, priority, reminderTime),
          onToggleTodo: (todoId) => _toggleTodoStatusData(todoId),
          onDeleteTodo: (todoId) => _deleteTodoData(todoId),
          onEditTodo: (todoId, content, priority, reminderTime) =>
              _editTodoData(todoId, content, priority, reminderTime),
        );
      },
    );
  }

  /// 切换TODO状态
  Future<void> _toggleTodoStatusData(int todoId) async {
    final success = await _todoBusinessLogic.toggleTodoStatus(todoId);
    if (success) {
      await _loadTodoRecords(); // 重新加载数据
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('切换状态失败'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 删除TODO
  Future<void> _deleteTodoData(int todoId) async {
    final success = await _todoBusinessLogic.deleteTodoRecord(todoId);
    if (success) {
      await _loadTodoRecords(); // 重新加载数据
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('删除失败'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 编辑TODO
  Future<void> _editTodoData(int todoId, String content, int priority, DateTime? reminderTime) async {
    final success = await _todoBusinessLogic.updateTodoContent(todoId, content);
    final prioritySuccess = await _todoBusinessLogic.updateTodoPriority(todoId, priority);

    // 更新提醒时间
    bool reminderSuccess = true;
    reminderSuccess = await _todoBusinessLogic.updateTodoReminderTime(todoId, reminderTime);

    // 设置或取消提醒
    if (reminderSuccess) {
      final todo = _todoRecords.firstWhere((t) => t.id == todoId);
      final updatedTodo = todo.copyWith(reminderTime: reminderTime);
      final reminderService = ReminderService();
      if (reminderTime != null) {
        await reminderService.updateTodoReminder(updatedTodo);
      } else {
        await reminderService.cancelTodoReminder(todoId);
      }
    }

    if (success && prioritySuccess && reminderSuccess) {
      await _loadTodoRecords(); // 重新加载数据
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('编辑失败'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 添加TODO
  Future<void> _addTodoData(String content, int priority, DateTime? reminderTime) async {
    final success = await _todoBusinessLogic.addTodoRecord(
      content,
      widget.currentWeek,
      widget.currentYear,
      priority: priority,
      reminderTime: reminderTime,
    );

    if (success && reminderTime != null) {
      // 获取刚添加的TODO记录，设置提醒
      await _loadTodoRecords();
      final newTodo = _todoRecords.where((t) => t.content == content).last;
      final reminderService = ReminderService();
      await reminderService.setTodoReminder(newTodo);
    } else if (success) {
      await _loadTodoRecords(); // 重新加载数据
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('添加失败'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 构建未来周份的TODO部分（不依赖JournalEditBloc，但需要支持编辑状态）
  Widget _buildFutureTodoSection() {
    // 现在总是可以编辑
    const isEditing = true;

    return TodoSection(
      currentWeek: widget.currentWeek,
      currentYear: widget.currentYear,
      todos: _todoRecords,
      isLoading: _isLoadingTodos,
      isEditing: isEditing,
      onAddTodo: (content, priority, reminderTime) => _addTodoData(content, priority, reminderTime),
      onToggleTodo: (todoId) => _toggleTodoStatusData(todoId),
      onDeleteTodo: (todoId) => _deleteTodoData(todoId),
      onEditTodo: (todoId, content, priority, reminderTime) => _editTodoData(todoId, content, priority, reminderTime),
    );
  }

  /// 即时保存心情数据
  Future<void> _saveMoodData(String mood, String emoji) async {
    try {
      print('💾 准备保存心情数据到数据库');

      // 设置保存标志，让BlocListener知道即将保存
      _justSaved = true;

      // 准备位置信息
      String locationJson = '';
      if (_isLocationEnabled && _currentLocation != null) {
        locationJson = _currentLocation!.toJson();
      }

      context.read<JournalEditBloc>().add(SaveJournalEvent(
            content: _journalController.text,
            mood: mood,
            moodEmoji: emoji,
            isLocationEnabled: _isLocationEnabled,
            imagePaths: _selectedImages.map((e) => e.path).toList(),
            locationData: locationJson,
          ));

      // 不在这里立即通知父组件，而是等待保存完成后在BlocListener中通知
    } catch (e) {
      print('保存心情失败: $e');
      _justSaved = false; // 重置标志
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存心情失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 即时保存照片数据
  Future<void> _savePhotosData(List<XFile> images) async {
    try {
      print('💾 准备保存照片数据到数据库');

      // 验证每张图片的 EXIF 信息
      for (final image in images) {
        try {
          final bytes = await File(image.path).readAsBytes();
          final exifData = await readExifFromBytes(bytes);

          if (exifData.isNotEmpty) {
            print('✅ 图片 EXIF 信息验证成功: ${path.basename(image.path)}');
            print('📝 EXIF 标签数量: ${exifData.length}');

            // 打印关键 EXIF 信息
            final importantTags = [
              'Make',
              'Model',
              'FNumber',
              'ExposureTime',
              'ISOSpeedRatings',
              'FocalLength',
              'Flash',
              'WhiteBalance'
            ];

            for (final tag in importantTags) {
              final value =
                  exifData[tag]?.printable ?? exifData['EXIF $tag']?.printable ?? exifData['Image $tag']?.printable;
              if (value != null) {
                print('  $tag: $value');
              }
            }
          } else {
            print('⚠️ 图片没有 EXIF 信息: ${path.basename(image.path)}');
          }
        } catch (e) {
          print('⚠️ 验证 EXIF 信息失败: ${path.basename(image.path)} - $e');
        }
      }

      // 设置保存标志，让BlocListener知道即将保存
      _justSaved = true;

      context.read<JournalEditBloc>().add(SaveJournalEvent(
            content: _journalController.text,
            mood: _selectedMood,
            moodEmoji: _selectedMoodEmoji,
            isLocationEnabled: _isLocationEnabled,
            imagePaths: images.map((e) => e.path).toList(),
            locationData: _currentLocation?.toJson() ?? '',
          ));
    } catch (e) {
      print('❌ 保存照片数据失败: $e');
      _justSaved = false; // 重置标志
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存照片数据失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 即时保存定位数据
  Future<void> _saveLocationData(bool isEnabled, LocationData? locationData) async {
    try {
      print('💾 准备保存定位数据到数据库');

      // 设置保存标志，让BlocListener知道即将保存
      _justSaved = true;

      // 准备位置信息
      String locationJson = '';
      if (isEnabled && locationData != null) {
        locationJson = locationData.toJson();
      }

      context.read<JournalEditBloc>().add(SaveJournalEvent(
            content: _journalController.text,
            mood: _selectedMood,
            moodEmoji: _selectedMoodEmoji,
            isLocationEnabled: isEnabled,
            imagePaths: _selectedImages.map((e) => e.path).toList(),
            locationData: locationJson,
          ));

      // 不在这里立即通知父组件，而是等待保存完成后在BlocListener中通知
    } catch (e) {
      print('保存定位数据失败: $e');
      _justSaved = false; // 重置标志
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存定位数据失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 即时保存周记内容
  Future<void> _saveJournalContentData(String content) async {
    try {
      print('💾 准备保存周记内容到数据库');

      // 设置保存标志，让BlocListener知道即将保存
      _justSaved = true;

      // 准备位置信息
      String locationJson = '';
      if (_isLocationEnabled && _currentLocation != null) {
        locationJson = _currentLocation!.toJson();
      }

      context.read<JournalEditBloc>().add(SaveJournalEvent(
            content: content,
            mood: _selectedMood,
            moodEmoji: _selectedMoodEmoji,
            isLocationEnabled: _isLocationEnabled,
            imagePaths: _selectedImages.map((e) => e.path).toList(),
            locationData: locationJson,
          ));

      // 不在这里立即通知父组件，而是等待保存完成后在BlocListener中通知
    } catch (e) {
      print('保存周记内容失败: $e');
      _justSaved = false; // 重置标志
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存周记内容失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
