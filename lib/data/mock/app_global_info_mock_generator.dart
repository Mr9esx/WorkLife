import 'package:WeekLife/data/models/app_global_info/app_global_info_data.dart';

/// App Global Info Mock 数据生成器
/// 用于在调试模式下生成默认的应用全局信息，避免模拟器重启导致数据丢失
class AppGlobalInfoMockGenerator {
  
  /// 生成默认的 App Global Info 数据
  /// 
  /// [appVersion] 应用版本号（可选，默认为'1.0.0'）
  /// [dbVersion] 数据库版本号（可选，默认为1）
  /// 返回一个包含基本信息的默认应用全局信息数据
  static AppGlobalInfoData generateDefaultAppGlobalInfo({
    String appVersion = '1.0.0',
    int dbVersion = 1,
  }) {
    final now = DateTime.now();
    
    return AppGlobalInfoData(
      // id 为 null，让数据库自动生成
      id: null,
      
      // 应用版本号
      appVersion: appVersion,
      
      // 数据库版本号
      dbVersion: dbVersion,
      
      // 首次启动标记
      isFirstLaunch: true,
      
      // 默认数据初始化标记
      isDefaultDataInitialized: false,
      
      // 最后启动时间设为当前时间
      lastLaunchTime: now,
      
      // 启动次数设为1
      launchCount: 1,
      
      // 用户协议版本（暂未设置）
      privacyPolicyVersion: null,
      
      // 用户协议同意状态（默认未同意）
      isPrivacyPolicyAccepted: false,
      
      // 应用语言设置（默认中文）
      appLanguage: 'zh_CN',
      
      // 主题设置（默认跟随系统）
      themeMode: 'system',
      
      // 扩展配置（默认为空）
      extendedConfig: null,
      
      // 创建时间设为当前时间
      createdAt: now,
      
      // 更新时间为空
      updatedAt: null,
    );
  }
  
  /// 生成已启动过的 App Global Info 数据
  /// 
  /// [appVersion] 应用版本号（可选，默认为'1.0.0'）
  /// [dbVersion] 数据库版本号（可选，默认为1）
  /// [launchCount] 启动次数（可选，默认为5）
  /// [isDefaultDataInitialized] 是否已初始化默认数据（可选，默认为true）
  /// 返回一个模拟已使用过的应用全局信息数据
  static AppGlobalInfoData generateUsedAppGlobalInfo({
    String appVersion = '1.0.0',
    int dbVersion = 1,
    int launchCount = 5,
    bool isDefaultDataInitialized = true,
  }) {
    final now = DateTime.now();
    final createdAt = now.subtract(const Duration(days: 7)); // 7天前创建
    final lastLaunchTime = now.subtract(const Duration(hours: 2)); // 2小时前最后启动
    
    return AppGlobalInfoData(
      id: null,
      appVersion: appVersion,
      dbVersion: dbVersion,
      isFirstLaunch: false, // 已不是首次启动
      isDefaultDataInitialized: isDefaultDataInitialized,
      lastLaunchTime: lastLaunchTime,
      launchCount: launchCount,
      privacyPolicyVersion: '1.0',
      isPrivacyPolicyAccepted: true, // 已同意用户协议
      appLanguage: 'zh_CN',
      themeMode: 'light', // 设置为浅色主题
      extendedConfig: '{"theme_color": "blue", "auto_backup": true}', // 示例扩展配置
      createdAt: createdAt,
      updatedAt: now.subtract(const Duration(hours: 2)),
    );
  }
  
  /// 生成自定义的 App Global Info 数据
  /// 
  /// [appVersion] 应用版本号
  /// [dbVersion] 数据库版本号
  /// [isFirstLaunch] 是否首次启动
  /// [isDefaultDataInitialized] 是否已初始化默认数据
  /// [launchCount] 启动次数
  /// [appLanguage] 应用语言设置
  /// [themeMode] 主题设置
  /// [privacyPolicyVersion] 用户协议版本（可选）
  /// [isPrivacyPolicyAccepted] 是否同意用户协议
  /// [extendedConfig] 扩展配置（可选）
  /// 
  /// 返回自定义的应用全局信息数据
  static AppGlobalInfoData generateCustomAppGlobalInfo({
    required String appVersion,
    required int dbVersion,
    required bool isFirstLaunch,
    required bool isDefaultDataInitialized,
    required int launchCount,
    required String appLanguage,
    required String themeMode,
    String? privacyPolicyVersion,
    bool isPrivacyPolicyAccepted = false,
    String? extendedConfig,
  }) {
    final now = DateTime.now();
    
    return AppGlobalInfoData(
      id: null,
      appVersion: appVersion,
      dbVersion: dbVersion,
      isFirstLaunch: isFirstLaunch,
      isDefaultDataInitialized: isDefaultDataInitialized,
      lastLaunchTime: now,
      launchCount: launchCount,
      privacyPolicyVersion: privacyPolicyVersion,
      isPrivacyPolicyAccepted: isPrivacyPolicyAccepted,
      appLanguage: appLanguage,
      themeMode: themeMode,
      extendedConfig: extendedConfig,
      createdAt: now,
      updatedAt: null,
    );
  }
  
  /// 获取主题模式显示文本
  /// 
  /// [themeMode] 主题模式代码
  /// 返回主题模式的中文显示文本
  static String getThemeModeText(String themeMode) {
    switch (themeMode) {
      case 'light':
        return '浅色模式';
      case 'dark':
        return '深色模式';
      case 'system':
        return '跟随系统';
      default:
        return '未知';
    }
  }
  
  /// 获取语言显示文本
  /// 
  /// [language] 语言代码
  /// 返回语言的中文显示文本
  static String getLanguageText(String language) {
    switch (language) {
      case 'zh_CN':
        return '简体中文';
      case 'zh_TW':
        return '繁体中文';
      case 'en_US':
        return '英语';
      case 'ja_JP':
        return '日语';
      case 'ko_KR':
        return '韩语';
      default:
        return '未知语言';
    }
  }
  
  /// 验证生成的数据是否有效
  /// 
  /// [info] 要验证的应用全局信息数据
  /// 返回验证结果，true表示有效
  static bool validateAppGlobalInfoData(AppGlobalInfoData info) {
    // 检查必填字段
    if (info.appVersion.isEmpty) return false;
    if (info.dbVersion < 1) return false;
    if (info.launchCount < 0) return false;
    if (info.appLanguage.isEmpty) return false;
    if (info.themeMode.isEmpty) return false;
    
    // 检查主题模式是否有效
    final validThemeModes = ['light', 'dark', 'system'];
    if (!validThemeModes.contains(info.themeMode)) return false;
    
    // 检查语言代码是否有效
    final validLanguages = ['zh_CN', 'zh_TW', 'en_US', 'ja_JP', 'ko_KR'];
    if (!validLanguages.contains(info.appLanguage)) return false;
    
    // 检查时间是否合理
    if (info.lastLaunchTime != null && info.lastLaunchTime!.isAfter(DateTime.now())) {
      return false;
    }
    
    // 检查创建时间是否合理（不能是未来时间）
    if (info.createdAt.isAfter(DateTime.now())) return false;
    
    return true;
  }
  
  /// 生成多个测试场景的 App Global Info 数据
  /// 
  /// 返回包含不同测试场景的应用全局信息数据列表
  static List<AppGlobalInfoData> generateTestScenarios() {
    return [
      // 场景1：全新安装
      generateDefaultAppGlobalInfo(),
      
      // 场景2：已使用一段时间
      generateUsedAppGlobalInfo(),
      
      // 场景3：深色主题用户
      generateCustomAppGlobalInfo(
        appVersion: '1.2.0',
        dbVersion: 3,
        isFirstLaunch: false,
        isDefaultDataInitialized: true,
        launchCount: 15,
        appLanguage: 'zh_CN',
        themeMode: 'dark',
        privacyPolicyVersion: '1.1',
        isPrivacyPolicyAccepted: true,
        extendedConfig: '{"theme_color": "purple", "notifications": false}',
      ),
      
      // 场景4：英文用户
      generateCustomAppGlobalInfo(
        appVersion: '1.1.0',
        dbVersion: 1,
        isFirstLaunch: false,
        isDefaultDataInitialized: true,
        launchCount: 8,
        appLanguage: 'en_US',
        themeMode: 'light',
        privacyPolicyVersion: '1.0',
        isPrivacyPolicyAccepted: true,
      ),
      
      // 场景5：重度用户
      generateCustomAppGlobalInfo(
        appVersion: '1.3.0',
        dbVersion: 3,
        isFirstLaunch: false,
        isDefaultDataInitialized: true,
        launchCount: 100,
        appLanguage: 'zh_CN',
        themeMode: 'system',
        privacyPolicyVersion: '1.2',
        isPrivacyPolicyAccepted: true,
        extendedConfig: '{"advanced_features": true, "beta_tester": true}',
      ),
    ];
  }
} 