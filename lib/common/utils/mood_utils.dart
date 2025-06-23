import 'package:flutter/material.dart';
import 'package:WeekLife/presentation/pages/app_main/journal/singleview/components/widgets/common/common_widgets.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';

/// 心情映射工具类
/// 统一管理心情名称、emoji资源名称、颜色等映射关系
class MoodUtils {
  // 私有构造函数，防止实例化
  MoodUtils._();

  /// 心情配置映射表
  /// Key: 心情ID, Value: 心情配置
  static const Map<int, _MoodConfig> _moodConfigs = {
    -1: _MoodConfig(
      name: '未记录',
      emojiAsset: '-',
      color: Color(0xFFBDBDBD),
      colorText: '灰',
      colorHex: '#BDBDBD',
    ),
    0: _MoodConfig(
      name: '开心',
      emojiAsset: 'beaming-face-with-smiling-eyes',
      color: JournalThemeColors.yellow,
      colorText: '黄',
      colorHex: '#FFD600',
    ),
    1: _MoodConfig(
      name: '难过',
      emojiAsset: 'crying-face',
      color: JournalThemeColors.blue,
      colorText: '蓝',
      colorHex: '#3A7DFF',
    ),
    2: _MoodConfig(
      name: '愤怒',
      emojiAsset: 'angry-face',
      color: JournalThemeColors.red,
      colorText: '红',
      colorHex: '#FF4B3E',
    ),
    3: _MoodConfig(
      name: '疲惫',
      emojiAsset: 'sleepy-face',
      color: JournalThemeColors.cyan,
      colorText: '青',
      colorHex: '#00C2C7',
    ),
    4: _MoodConfig(
      name: '思考',
      emojiAsset: 'thinking-face',
      color: JournalThemeColors.purple,
      colorText: '紫',
      colorHex: '#A259F7',
    ),
  };

  /// 反向映射：心情名称 -> ID
  static final Map<String, int> _nameToIdMap = {
    for (final entry in _moodConfigs.entries)
      if (entry.key >= 0) // 排除未记录状态
        entry.value.name: entry.key
  };

  /// 默认心情配置
  static const int defaultMoodId = 0;
  static String get defaultMoodName => _moodConfigs[defaultMoodId]!.name;
  static String get defaultMoodEmojiAsset => _moodConfigs[defaultMoodId]!.emojiAsset;

  /// 获取所有可用的心情数据（不包括未记录状态）
  static List<MoodData> get allMoods => _moodConfigs.entries
      .where((entry) => entry.key >= 0)
      .map((entry) => MoodData(
            id: entry.key,
            name: entry.value.name,
            emojiAsset: entry.value.emojiAsset,
            color: entry.value.color,
            colorText: entry.value.colorText,
            colorHex: entry.value.colorHex,
          ))
      .toList();

  /// 获取默认心情选项列表（用于UI选择器）
  static List<MoodOption> get defaultMoodOptions => allMoods
      .map((mood) => MoodOption(emoji: mood.emojiAsset, name: mood.name))
      .toList();

  // ==================== 核心查询方法 ====================

  /// 根据心情ID获取心情配置
  static _MoodConfig? _getConfig(int id) => _moodConfigs[id];

  /// 根据心情名称获取心情ID
  static int? _getIdByName(String name) => _nameToIdMap[name];

  // ==================== 公共API方法 ====================

  /// 根据心情ID获取心情名称
  static String getMoodName(int id) {
    return _getConfig(id)?.name ?? defaultMoodName;
  }

  /// 根据心情名称获取心情ID
  static int getMoodId(String name) {
    return _getIdByName(name) ?? defaultMoodId;
  }

  /// 根据心情ID获取emoji资源名称
  static String getMoodEmojiAsset(int id) {
    return _getConfig(id)?.emojiAsset ?? defaultMoodEmojiAsset;
  }

  /// 根据心情ID获取颜色
  static Color getMoodColorById(int id) {
    return _getConfig(id)?.color ?? _moodConfigs[defaultMoodId]!.color;
  }

  /// 根据心情名称获取颜色
  static Color getMoodColor(String name) {
    final id = getMoodId(name);
    return getMoodColorById(id);
  }

  /// 根据心情ID获取颜色文本描述
  static String getMoodColorTextById(int id) {
    return _getConfig(id)?.colorText ?? _moodConfigs[defaultMoodId]!.colorText;
  }

  /// 根据心情名称获取颜色文本描述
  static String getMoodColorText(String name) {
    final id = getMoodId(name);
    return getMoodColorTextById(id);
  }

  /// 根据心情ID获取颜色的十六进制字符串
  static String getMoodColorHexById(int id) {
    return _getConfig(id)?.colorHex ?? _moodConfigs[defaultMoodId]!.colorHex;
  }

  /// 根据心情名称获取颜色的十六进制字符串
  static String getMoodColorHex(String name) {
    final id = getMoodId(name);
    return getMoodColorHexById(id);
  }

  /// 解析颜色字符串为Color对象
  static Color parseColorFromHex(String hexColor) {
    try {
      if (hexColor.isNotEmpty && hexColor.startsWith('#')) {
        final hex = hexColor.substring(1);
        return Color(int.parse('FF$hex', radix: 16));
      }
    } catch (e) {
      // 解析失败时返回默认颜色
    }
    return _moodConfigs[defaultMoodId]!.color;
  }

  /// 根据心情ID获取完整的心情数据
  static MoodData? getMoodById(int id) {
    final config = _getConfig(id);
    if (config == null) return null;
    
    return MoodData(
      id: id,
      name: config.name,
      emojiAsset: config.emojiAsset,
      color: config.color,
      colorText: config.colorText,
      colorHex: config.colorHex,
    );
  }

  /// 根据心情名称获取完整的心情数据
  static MoodData? getMoodByName(String name) {
    final id = _getIdByName(name);
    if (id == null) return null;
    return getMoodById(id);
  }

  /// 检查心情ID是否有效
  static bool isValidMoodId(int id) => _moodConfigs.containsKey(id);

  /// 检查心情名称是否有效
  static bool isValidMoodName(String name) => _nameToIdMap.containsKey(name);

  /// 获取所有有效的心情ID列表
  static List<int> get allMoodIds => _moodConfigs.keys.where((id) => id >= 0).toList();

  /// 获取所有有效的心情名称列表
  static List<String> get allMoodNames => _nameToIdMap.keys.toList();
}

/// 私有心情配置类
class _MoodConfig {
  final String name;
  final String emojiAsset;
  final Color color;
  final String colorText;
  final String colorHex;

  const _MoodConfig({
    required this.name,
    required this.emojiAsset,
    required this.color,
    required this.colorText,
    required this.colorHex,
  });
}

/// 公共心情数据模型
class MoodData {
  final int id;
  final String name;
  final String emojiAsset;
  final Color color;
  final String colorText;
  final String colorHex;

  const MoodData({
    required this.id,
    required this.name,
    required this.emojiAsset,
    required this.color,
    required this.colorText,
    required this.colorHex,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MoodData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MoodData(id: $id, name: $name, emojiAsset: $emojiAsset)';
  }
} 