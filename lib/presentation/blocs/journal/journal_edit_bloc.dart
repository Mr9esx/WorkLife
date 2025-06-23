import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:WeekLife/common/utils/mood_utils.dart';
import 'package:WeekLife/data/dao/weekly_journal/weekly_journal_dao.dart';
import 'package:WeekLife/data/dao/journal_writer/journal_writer_dao.dart';
import 'package:WeekLife/data/models/weekly_journal/weekly_journal_data.dart';
import 'package:WeekLife/core/utils/database/database_manager.dart';
import 'dart:convert';

// Events
abstract class JournalEditEvent extends Equatable {
  const JournalEditEvent();

  @override
  List<Object> get props => [];
}

class LoadJournalEvent extends JournalEditEvent {
  final int weekNumber;
  final int year;

  const LoadJournalEvent({
    required this.weekNumber,
    required this.year,
  });

  @override
  List<Object> get props => [weekNumber, year];
}

// 新增：直接保存周记内容事件
class SaveJournalContentEvent extends JournalEditEvent {
  final String content;

  const SaveJournalContentEvent({
    required this.content,
  });

  @override
  List<Object> get props => [content];
}

// 新增：直接保存心情事件
class SaveMoodEvent extends JournalEditEvent {
  final String mood;
  final String moodEmoji;

  const SaveMoodEvent({
    required this.mood,
    required this.moodEmoji,
  });

  @override
  List<Object> get props => [mood, moodEmoji];
}

// 新增：直接保存照片事件
class SavePhotosEvent extends JournalEditEvent {
  final List<String> imagePaths;

  const SavePhotosEvent({
    required this.imagePaths,
  });

  @override
  List<Object> get props => [imagePaths];
}

// 新增：直接保存位置事件
class SaveLocationEvent extends JournalEditEvent {
  final bool isLocationEnabled;
  final String locationData;

  const SaveLocationEvent({
    required this.isLocationEnabled,
    this.locationData = '',
  });

  @override
  List<Object> get props => [isLocationEnabled, locationData];
}

// 保留原有的完整保存事件（用于兼容）
class SaveJournalEvent extends JournalEditEvent {
  final String content;
  final String mood;
  final String moodEmoji;
  final bool isLocationEnabled;
  final List<String> imagePaths;
  final String locationData;

  const SaveJournalEvent({
    required this.content,
    required this.mood,
    required this.moodEmoji,
    required this.isLocationEnabled,
    required this.imagePaths,
    this.locationData = '',
  });

  @override
  List<Object> get props => [content, mood, moodEmoji, isLocationEnabled, imagePaths, locationData];
}

class RequestSaveEvent extends JournalEditEvent {}

// States
abstract class JournalEditState extends Equatable {
  const JournalEditState();

  @override
  List<Object> get props => [];
}

class JournalLoadingState extends JournalEditState {}

// 简化状态：只保留查看状态，移除编辑状态
class JournalViewState extends JournalEditState {
  final WeeklyJournalData? journalData;
  final String content;
  final String mood;
  final String moodEmoji;
  final bool isLocationEnabled;
  final List<String> imagePaths;
  final int weekNumber;
  final int year;

  JournalViewState({
    this.journalData,
    this.content = '',
    String? mood,
    String? moodEmoji,
    this.isLocationEnabled = false,
    this.imagePaths = const [],
    required this.weekNumber,
    required this.year,
  })  : mood = mood ?? MoodUtils.defaultMoodName,
        moodEmoji = moodEmoji ?? MoodUtils.defaultMoodEmojiAsset;

  @override
  List<Object> get props =>
      [journalData?.id ?? 0, content, mood, moodEmoji, isLocationEnabled, imagePaths, weekNumber, year];
}

// 新增：保存中状态（显示加载指示器）
class JournalSavingState extends JournalEditState {
  final int weekNumber;
  final int year;
  final WeeklyJournalData? journalData;
  final String savingType; // 标识正在保存的内容类型

  const JournalSavingState({
    required this.weekNumber,
    required this.year,
    this.journalData,
    this.savingType = 'journal',
  });

  @override
  List<Object> get props => [weekNumber, year, journalData?.id ?? 0, savingType];
}

class JournalErrorState extends JournalEditState {
  final String message;

  const JournalErrorState(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class JournalEditBloc extends Bloc<JournalEditEvent, JournalEditState> {
  late final WeeklyJournalDao _journalDao;
  late final JournalWriterDao _writerDao;

  JournalEditBloc() : super(JournalLoadingState()) {
    // 初始化 DAO
    final database = DatabaseManager.instance.database;
    _journalDao = WeeklyJournalDao(database);
    _writerDao = JournalWriterDao(database);

    on<LoadJournalEvent>(_onLoadJournal);
    on<SaveJournalContentEvent>(_onSaveJournalContent);
    on<SaveMoodEvent>(_onSaveMood);
    on<SavePhotosEvent>(_onSavePhotos);
    on<SaveLocationEvent>(_onSaveLocation);
    on<SaveJournalEvent>(_onSaveJournal);
    on<RequestSaveEvent>(_onRequestSave);
  }

  void _onLoadJournal(LoadJournalEvent event, Emitter<JournalEditState> emit) async {
    try {
      emit(JournalLoadingState());

      // 获取当前作者
      final currentWriter = await _writerDao.getCurrentWriter();
      if (currentWriter.id == null) {
        emit(const JournalErrorState('当前作者ID为空'));
        return;
      }

      // 根据周数和年份查找周记
      final journalData = await _journalDao.getWeeklyJournalByWeek(
        currentWriter.id!,
        event.weekNumber,
        event.year,
      );

      if (journalData != null) {
        // 解析图片路径
        List<String> imagePaths = [];
        if (journalData.pics.isNotEmpty) {
          try {
            final List<dynamic> pics = jsonDecode(journalData.pics);
            imagePaths = pics.cast<String>();
          } catch (e) {
            print('解析图片路径失败: $e');
          }
        }

        // 解析心情信息
        String mood = MoodUtils.defaultMoodName;
        String moodEmoji = MoodUtils.defaultMoodEmojiAsset;
        try {
          // 使用MoodUtils统一处理心情映射
          mood = MoodUtils.getMoodName(journalData.mood);
          moodEmoji = MoodUtils.getMoodEmojiAsset(journalData.mood);
        } catch (e) {
          print('解析心情信息失败: $e');
        }

        emit(JournalViewState(
          journalData: journalData,
          content: journalData.content,
          mood: mood,
          moodEmoji: moodEmoji,
          isLocationEnabled: journalData.geo.isNotEmpty,
          imagePaths: imagePaths,
          weekNumber: event.weekNumber,
          year: event.year,
        ));
      } else {
        // 没有找到周记，创建新的空状态
        emit(JournalViewState(
          weekNumber: event.weekNumber,
          year: event.year,
        ));
      }
    } catch (e) {
      emit(JournalErrorState('加载周记失败: $e'));
    }
  }

  void _onSaveJournalContent(SaveJournalContentEvent event, Emitter<JournalEditState> emit) {
    // 这个事件用于从底部栏请求保存
    // 实际的保存逻辑将在 JournalContent 中处理
    if (state is JournalViewState) {
      final viewState = state as JournalViewState;
      emit(JournalSavingState(
        weekNumber: viewState.weekNumber,
        year: viewState.year,
        journalData: viewState.journalData,
        savingType: 'content',
      ));
    }
  }

  void _onSaveMood(SaveMoodEvent event, Emitter<JournalEditState> emit) {
    // 这个事件用于从底部栏请求保存
    // 实际的保存逻辑将在 JournalContent 中处理
    if (state is JournalViewState) {
      final viewState = state as JournalViewState;
      emit(JournalSavingState(
        weekNumber: viewState.weekNumber,
        year: viewState.year,
        journalData: viewState.journalData,
        savingType: 'mood',
      ));
    }
  }

  void _onSavePhotos(SavePhotosEvent event, Emitter<JournalEditState> emit) {
    // 这个事件用于从底部栏请求保存
    // 实际的保存逻辑将在 JournalContent 中处理
    if (state is JournalViewState) {
      final viewState = state as JournalViewState;
      emit(JournalSavingState(
        weekNumber: viewState.weekNumber,
        year: viewState.year,
        journalData: viewState.journalData,
        savingType: 'photos',
      ));
    }
  }

  void _onSaveLocation(SaveLocationEvent event, Emitter<JournalEditState> emit) {
    // 这个事件用于从底部栏请求保存
    // 实际的保存逻辑将在 JournalContent 中处理
    if (state is JournalViewState) {
      final viewState = state as JournalViewState;
      emit(JournalSavingState(
        weekNumber: viewState.weekNumber,
        year: viewState.year,
        journalData: viewState.journalData,
        savingType: 'location',
      ));
    }
  }

  void _onSaveJournal(SaveJournalEvent event, Emitter<JournalEditState> emit) async {
    try {
      print('🔄 开始保存周记...');

      // 在发出 JournalSavingState 之前，先保存当前状态的信息
      int weekNumber = 1;
      int year = DateTime.now().year;
      WeeklyJournalData? existingJournal;

      // 从当前状态获取周数和年份信息
      if (state is JournalViewState) {
        final viewState = state as JournalViewState;
        weekNumber = viewState.weekNumber;
        year = viewState.year;
        existingJournal = viewState.journalData;
        print('📅 从查看状态获取: $year年第$weekNumber周');
        print('📝 现有周记: ${existingJournal != null ? "存在(ID: ${existingJournal.id})" : "不存在"}');
      } else if (state is JournalSavingState) {
        final savingState = state as JournalSavingState;
        weekNumber = savingState.weekNumber;
        year = savingState.year;
        existingJournal = savingState.journalData;
        print('📅 从保存状态获取: $year年第$weekNumber周');
        print('📝 现有周记: ${existingJournal != null ? "存在(ID: ${existingJournal.id})" : "不存在"}');
      } else {
        print('⚠️ 当前状态不是有效状态: ${state.runtimeType}');
        emit(const JournalErrorState('无法获取当前周记信息'));
        return;
      }

      // 状态信息已经获取，无需再次发出保存状态

      // 获取当前作者
      print('👤 正在获取当前作者...');
      final currentWriter = await _writerDao.getCurrentWriter();
      if (currentWriter.id == null) {
        print('❌ 当前作者ID为空');
        emit(const JournalErrorState('当前作者ID为空'));
        return;
      }
      print('✅ 获取到当前作者: ${currentWriter.username} (ID: ${currentWriter.id})');

      // 转换心情为数字
      int moodValue = _getMoodValue(event.mood);
      print('😊 心情值: ${event.mood} -> $moodValue');

      // 序列化图片路径
      String picsJson = '';
      if (event.imagePaths.isNotEmpty) {
        picsJson = jsonEncode(event.imagePaths);
        print('📸 图片路径: ${event.imagePaths.length} 张');
      }

      // 地理位置信息
      String geoInfo = '';
      if (event.isLocationEnabled && event.locationData.isNotEmpty) {
        geoInfo = event.locationData;
        print('📍 位置信息: 已启用，保存位置数据');
      } else {
        geoInfo = event.isLocationEnabled ? '{}' : '';
        print('📍 位置信息: ${event.isLocationEnabled ? "已启用但无位置数据" : "未启用"}');
      }

      WeeklyJournalData savedJournal;

      if (existingJournal != null) {
        // 更新现有周记
        print('🔄 更新现有周记 (ID: ${existingJournal.id})...');
        final success = await _journalDao.updateWeeklyJournal(
          existingJournal.id!,
          {
            'title': '第$weekNumber周',
            'content': event.content,
            'mood': moodValue,
            'moodColor': _getMoodColor(event.mood),
            'pics': picsJson,
            'geo': geoInfo,
          },
        );

        if (!success) {
          print('❌ 更新周记失败');
          emit(const JournalErrorState('更新周记失败'));
          return;
        }
        print('✅ 周记更新成功');

        // 重新获取更新后的周记
        savedJournal = (await _journalDao.getWeeklyJournalById(existingJournal.id!))!;
        print('✅ 重新获取更新后的周记成功');
      } else {
        // 创建新周记
        print('🆕 创建新周记...');
        print('📊 创建参数: writerId=${currentWriter.id}, year=$year, weekNumber=$weekNumber');
        final journalId = await _journalDao.createWeeklyJournal(
          writerId: currentWriter.id!,
          year: year,
          weekNumber: weekNumber,
          title: '第$weekNumber周',
          content: event.content,
          mood: moodValue,
          moodColor: _getMoodColor(event.mood),
          pics: picsJson,
          geo: geoInfo,
        );
        print('✅ 周记创建成功 (ID: $journalId)');

        // 获取创建的周记
        savedJournal = (await _journalDao.getWeeklyJournalById(journalId))!;
        print('✅ 获取创建的周记成功');
      }

      print('🎉 周记保存完成，切换到查看状态');
      emit(JournalViewState(
        journalData: savedJournal,
        content: event.content,
        mood: event.mood,
        moodEmoji: event.moodEmoji,
        isLocationEnabled: event.isLocationEnabled,
        imagePaths: event.imagePaths,
        weekNumber: weekNumber,
        year: year,
      ));
    } catch (e, stackTrace) {
      print('❌ 保存周记失败: $e');
      print('📊 错误堆栈: $stackTrace');
      emit(JournalErrorState('保存周记失败: $e'));
    }
  }

  void _onRequestSave(RequestSaveEvent event, Emitter<JournalEditState> emit) {
    // 这个事件用于从底部栏请求保存
    // 实际的保存逻辑将在 JournalContent 中处理
    if (state is JournalViewState) {
      final viewState = state as JournalViewState;
      emit(JournalSavingState(
        weekNumber: viewState.weekNumber,
        year: viewState.year,
        journalData: viewState.journalData,
        savingType: 'request',
      ));
    }
  }

  /// 将心情名称转换为数字值
  int _getMoodValue(String mood) {
    return MoodUtils.getMoodId(mood);
  }

  /// 获取心情对应的颜色
  String _getMoodColor(String mood) {
    return MoodUtils.getMoodColorHex(mood);
  }
}
