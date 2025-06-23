import 'package:WeekLife/data/models/app_global_info/app_global_info_data.dart';

/// App Global Info 数据访问对象接口
/// 定义所有业务级别的数据操作方法
abstract class IAppGlobalInfoDao {
  /// 初始化应用全局信息
  /// 
  /// [appVersion] 应用版本号（必填）
  /// [dbVersion] 数据库版本号（必填）
  /// [appLanguage] 应用语言设置（可选，默认为'zh_CN'）
  /// [themeMode] 主题设置（可选，默认为'system'）
  /// [extendedConfig] 扩展配置（可选，JSON格式）
  /// 
  /// 返回新创建的 App Global Info 的 ID
  Future<int> initializeAppGlobalInfo({
    required String appVersion,
    required int dbVersion,
    String appLanguage = 'zh_CN',
    String themeMode = 'system',
    String? extendedConfig,
  });

  /// 获取应用全局信息
  /// 
  /// 返回应用全局信息，如果不存在则返回 null
  Future<AppGlobalInfoData?> getAppGlobalInfo();

  /// 检查是否首次启动
  /// 
  /// 返回是否首次启动
  Future<bool> isFirstLaunch();

  /// 标记应用已启动（更新启动次数和最后启动时间）
  /// 
  /// 返回是否更新成功
  Future<bool> markAppLaunched();

  /// 检查是否已初始化默认数据
  /// 
  /// 返回是否已初始化默认数据
  Future<bool> isDefaultDataInitialized();

  /// 标记默认数据已初始化
  /// 
  /// 返回是否更新成功
  Future<bool> markDefaultDataInitialized();

  /// 更新应用版本
  /// 
  /// [appVersion] 新的应用版本号
  /// [dbVersion] 新的数据库版本号（可选）
  /// 返回是否更新成功
  Future<bool> updateAppVersion(String appVersion, {int? dbVersion});

  /// 更新用户协议状态
  /// 
  /// [version] 用户协议版本
  /// [accepted] 是否同意用户协议
  /// 返回是否更新成功
  Future<bool> updatePrivacyPolicyStatus(String version, bool accepted);

  /// 更新应用设置
  /// 
  /// [appLanguage] 应用语言设置（可选）
  /// [themeMode] 主题设置（可选）
  /// [extendedConfig] 扩展配置（可选）
  /// 返回是否更新成功
  Future<bool> updateAppSettings({
    String? appLanguage,
    String? themeMode,
    String? extendedConfig,
  });

  /// 获取启动次数
  /// 
  /// 返回应用启动次数
  Future<int> getLaunchCount();

  /// 获取最后启动时间
  /// 
  /// 返回最后启动时间，如果从未启动则返回 null
  Future<DateTime?> getLastLaunchTime();

  /// 重置应用全局信息（用于测试或重置应用状态）
  /// 
  /// 返回是否重置成功
  Future<bool> resetAppGlobalInfo();
} 