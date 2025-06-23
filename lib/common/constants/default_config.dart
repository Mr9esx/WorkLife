import 'package:WeekLife/presentation/pages/app_main/journal/singleview/components/widgets/common/common_widgets.dart';
import 'package:WeekLife/common/utils/mood_utils.dart';

/// 默认配置
class DefaultConfig {
  // 心情相关默认配置
  static List<MoodOption> get defaultMoodOptions => MoodUtils.defaultMoodOptions;
  
  static String get defaultMood => MoodUtils.defaultMoodName;
  static String get defaultMoodEmoji => MoodUtils.defaultMoodEmojiAsset;
  
  // TODO相关默认配置
  static const int defaultTodoPriority = 1;
  static const bool defaultTodoCompleted = false;
  static const int defaultTodoSortOrder = 0;
  static const int minTodoPriority = 1;
  static const int maxTodoPriority = 3;
  
  // 周记相关默认配置
  static const String defaultJournalContent = '';
  static const bool defaultLocationEnabled = false;
  static const String defaultMoodColor = '#FFD600';
  
  // 照片相关默认配置
  static const int defaultPhotoQuality = 80;
  static const int maxPhotoSize = 1920; // 最大宽度或高度
  
  // 用户界面默认配置
  static const bool defaultDarkMode = false;
  static const String defaultLanguage = 'zh_CN';
  
  // 权限相关默认配置
  static const List<String> requiredPermissions = [
    'camera',
    'storage',
    'location',
  ];
  
  // 缓存相关默认配置
  static const int defaultCacheMaxAge = 7; // 天数
  static const int defaultImageCacheSize = 100; // MB
  
  // 网络相关默认配置
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const int defaultRetryCount = 3;
} 