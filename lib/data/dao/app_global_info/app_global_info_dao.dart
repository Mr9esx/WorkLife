import 'package:WeekLife/data/models/app_global_info/app_global_info_data.dart';
import 'package:WeekLife/data/dao/app_global_info/interfaces/app_global_info_dao_interface.dart';
import 'package:WeekLife/data/database/app_database.dart';
import 'package:drift/drift.dart';

/// App Global Info 数据访问对象
/// 提供 App Global Info 表的所有数据库操作方法
class AppGlobalInfoDao implements IAppGlobalInfoDao {
  final AppDatabase _db;

  AppGlobalInfoDao(AppDatabase db) : _db = db;

  /// 初始化应用全局信息
  @override
  Future<int> initializeAppGlobalInfo({
    required String appVersion,
    required int dbVersion,
    String appLanguage = 'zh_CN',
    String themeMode = 'system',
    String? extendedConfig,
  }) async {
    try {
      final now = DateTime.now();

      final id = await _db.into(_db.appGlobalInfoTable).insert(
            AppGlobalInfoTableCompanion(
              appVersion: Value(appVersion),
              dbVersion: Value(dbVersion),
              isFirstLaunch: const Value(true),
              isDefaultDataInitialized: const Value(false),
              lastLaunchTime: Value(now),
              launchCount: const Value(1),
              privacyPolicyVersion: const Value.absent(),
              isPrivacyPolicyAccepted: const Value(false),
              appLanguage: Value(appLanguage),
              themeMode: Value(themeMode),
              extendedConfig: Value(extendedConfig),
              createdAt: Value(now),
              updatedAt: const Value.absent(),
            ),
          );
      return id;
    } catch (e) {
      throw Exception('初始化应用全局信息失败: $e');
    }
  }

  /// 获取应用全局信息
  @override
  Future<AppGlobalInfoData?> getAppGlobalInfo() async {
    try {
      final results = await (_db.select(_db.appGlobalInfoTable)
            ..orderBy([(t) => OrderingTerm.asc(t.id)])
            ..limit(1))
          .get();
      return results.isNotEmpty ? _convertToAppGlobalInfoData(results.first) : null;
    } catch (e) {
      throw Exception('获取应用全局信息失败: $e');
    }
  }

  /// 检查是否首次启动
  @override
  Future<bool> isFirstLaunch() async {
    try {
      final info = await getAppGlobalInfo();
      return info?.isFirstLaunch ?? true;
    } catch (e) {
      throw Exception('检查首次启动状态失败: $e');
    }
  }

  /// 标记应用已启动（更新启动次数和最后启动时间）
  @override
  Future<bool> markAppLaunched() async {
    try {
      final info = await getAppGlobalInfo();
      if (info == null) {
        return false;
      }

      final now = DateTime.now();
      final result = await (_db.update(_db.appGlobalInfoTable)..where((t) => t.id.equals(info.id!)))
          .write(AppGlobalInfoTableCompanion(
        isFirstLaunch: const Value(false),
        lastLaunchTime: Value(now),
        launchCount: Value(info.launchCount + 1),
        updatedAt: Value(now),
      ));
      return result > 0;
    } catch (e) {
      throw Exception('标记应用启动失败: $e');
    }
  }

  /// 检查是否已初始化默认数据
  @override
  Future<bool> isDefaultDataInitialized() async {
    try {
      final info = await getAppGlobalInfo();
      return info?.isDefaultDataInitialized ?? false;
    } catch (e) {
      throw Exception('检查默认数据初始化状态失败: $e');
    }
  }

  /// 标记默认数据已初始化
  @override
  Future<bool> markDefaultDataInitialized() async {
    try {
      final info = await getAppGlobalInfo();
      if (info == null) {
        return false;
      }

      final now = DateTime.now();
      final result = await (_db.update(_db.appGlobalInfoTable)..where((t) => t.id.equals(info.id!)))
          .write(AppGlobalInfoTableCompanion(
        isDefaultDataInitialized: const Value(true),
        updatedAt: Value(now),
      ));
      return result > 0;
    } catch (e) {
      throw Exception('标记默认数据初始化失败: $e');
    }
  }

  /// 更新应用版本
  @override
  Future<bool> updateAppVersion(String appVersion, {int? dbVersion}) async {
    try {
      final info = await getAppGlobalInfo();
      if (info == null) {
        return false;
      }

      final now = DateTime.now();
      final result = await (_db.update(_db.appGlobalInfoTable)..where((t) => t.id.equals(info.id!)))
          .write(AppGlobalInfoTableCompanion(
        appVersion: Value(appVersion),
        dbVersion: dbVersion != null ? Value(dbVersion) : const Value.absent(),
        updatedAt: Value(now),
      ));
      return result > 0;
    } catch (e) {
      throw Exception('更新应用版本失败: $e');
    }
  }

  /// 更新用户协议状态
  @override
  Future<bool> updatePrivacyPolicyStatus(String version, bool accepted) async {
    try {
      final info = await getAppGlobalInfo();
      if (info == null) {
        return false;
      }

      final now = DateTime.now();
      final result = await (_db.update(_db.appGlobalInfoTable)..where((t) => t.id.equals(info.id!)))
          .write(AppGlobalInfoTableCompanion(
        privacyPolicyVersion: Value(version),
        isPrivacyPolicyAccepted: Value(accepted),
        updatedAt: Value(now),
      ));
      return result > 0;
    } catch (e) {
      throw Exception('更新用户协议状态失败: $e');
    }
  }

  /// 更新应用设置
  @override
  Future<bool> updateAppSettings({
    String? appLanguage,
    String? themeMode,
    String? extendedConfig,
  }) async {
    try {
      final info = await getAppGlobalInfo();
      if (info == null) {
        return false;
      }

      final now = DateTime.now();
      final result = await (_db.update(_db.appGlobalInfoTable)..where((t) => t.id.equals(info.id!)))
          .write(AppGlobalInfoTableCompanion(
        appLanguage: appLanguage != null ? Value(appLanguage) : const Value.absent(),
        themeMode: themeMode != null ? Value(themeMode) : const Value.absent(),
        extendedConfig: extendedConfig != null ? Value(extendedConfig) : const Value.absent(),
        updatedAt: Value(now),
      ));
      return result > 0;
    } catch (e) {
      throw Exception('更新应用设置失败: $e');
    }
  }

  /// 获取启动次数
  @override
  Future<int> getLaunchCount() async {
    try {
      final info = await getAppGlobalInfo();
      return info?.launchCount ?? 0;
    } catch (e) {
      throw Exception('获取启动次数失败: $e');
    }
  }

  /// 获取最后启动时间
  @override
  Future<DateTime?> getLastLaunchTime() async {
    try {
      final info = await getAppGlobalInfo();
      return info?.lastLaunchTime;
    } catch (e) {
      throw Exception('获取最后启动时间失败: $e');
    }
  }

  /// 重置应用全局信息（用于测试或重置应用状态）
  @override
  Future<bool> resetAppGlobalInfo() async {
    try {
      final info = await getAppGlobalInfo();
      if (info == null) {
        return false;
      }

      final result = await (_db.delete(_db.appGlobalInfoTable)..where((t) => t.id.equals(info.id!))).go();
      return result > 0;
    } catch (e) {
      throw Exception('重置应用全局信息失败: $e');
    }
  }

  // 私有方法：转换数据库实体到数据模型
  AppGlobalInfoData _convertToAppGlobalInfoData(AppGlobalInfo dbInfo) {
    return AppGlobalInfoData(
      id: dbInfo.id,
      appVersion: dbInfo.appVersion,
      dbVersion: dbInfo.dbVersion,
      isFirstLaunch: dbInfo.isFirstLaunch,
      isDefaultDataInitialized: dbInfo.isDefaultDataInitialized,
      lastLaunchTime: dbInfo.lastLaunchTime,
      launchCount: dbInfo.launchCount,
      privacyPolicyVersion: dbInfo.privacyPolicyVersion,
      isPrivacyPolicyAccepted: dbInfo.isPrivacyPolicyAccepted,
      appLanguage: dbInfo.appLanguage,
      themeMode: dbInfo.themeMode,
      extendedConfig: dbInfo.extendedConfig,
      createdAt: dbInfo.createdAt,
      updatedAt: dbInfo.updatedAt,
    );
  }
}
