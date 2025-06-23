import 'package:WeekLife/data/mock/journal_writer_mock_generator.dart';
import 'package:WeekLife/data/mock/app_global_info_mock_generator.dart';
import 'package:WeekLife/data/dao/journal_writer/interfaces/journal_writer_dao_interface.dart';
import 'package:WeekLife/data/dao/app_global_info/interfaces/app_global_info_dao_interface.dart';

/// 开发模式测试数据场景
enum DevMockScenario {
  /// 默认场景：新应用，创建默认AppGlobalInfo和一个默认用户
  defaultScenario,

  /// 已使用场景：模拟已使用过的应用，有历史数据
  existingUserScenario,

  /// 多用户场景：创建多个测试用户
  multipleUsersScenario,

  /// 空场景：只创建AppGlobalInfo，不创建用户
  emptyScenario,
}

/// 开发模式测试数据生成助手
///
/// 专门用于开发模式下生成测试数据，包括：
/// 1. AppGlobalInfo 测试数据
/// 2. JournalWriter 测试数据
/// 3. 数据清理和重置功能
/// 4. 快速数据生成场景
class DevMockDataHelper {
  /// 生成开发模式测试数据
  ///
  /// 在开发模式下快速生成测试数据，用于 main.dart 启动时调用
  ///
  /// [journalWriterDao] Journal Writer 数据访问对象
  /// [appGlobalInfoDao] App Global Info 数据访问对象
  /// [appVersion] 当前应用版本号
  /// [dbVersion] 当前数据库版本号
  /// [scenario] 测试场景（默认、已使用、多用户等）
  /// [forceReset] 是否强制重置现有数据
  /// [checkFirstLaunch] 是否检查初次启动（默认true）
  static Future<void> generateDevMockData({
    required IJournalWriterDao journalWriterDao,
    required IAppGlobalInfoDao appGlobalInfoDao,
    required String appVersion,
    required int dbVersion,
    DevMockScenario scenario = DevMockScenario.defaultScenario,
    bool forceReset = false,
    bool checkFirstLaunch = true,
  }) async {
    try {
      print('🧪 开始生成开发模式测试数据...');
      print('📋 场景: ${_getScenarioName(scenario)}');

      // 检查是否需要生成模拟数据
      if (checkFirstLaunch && !forceReset) {
        final needsGeneration = await _checkFirstLaunch(appGlobalInfoDao);
        if (!needsGeneration) {
          print('⚠️ 数据库已有数据，跳过测试数据生成');
          print('💡 如需强制生成，请设置 forceReset: true');
          return;
        }

        // 额外检查用户数据
        final hasUserData = await _checkExistingUserData(journalWriterDao);
        if (hasUserData && !forceReset) {
          print('⚠️ 已存在用户数据，跳过用户数据生成');
          print('💡 如需强制生成，请设置 forceReset: true');

          // 只标记默认数据已初始化，不生成新数据
          await _markDefaultDataInitialized(appGlobalInfoDao);
          return;
        }

        print('✅ 检测到需要生成模拟数据，继续执行');
      }

      // 如果强制重置，先清理所有数据
      if (forceReset) {
        await _resetAllData(journalWriterDao, appGlobalInfoDao);
      }

      // 根据场景生成不同的测试数据
      switch (scenario) {
        case DevMockScenario.defaultScenario:
          await _generateDefaultScenario(journalWriterDao, appGlobalInfoDao, appVersion, dbVersion);
          break;
        case DevMockScenario.existingUserScenario:
          await _generateExistingUserScenario(journalWriterDao, appGlobalInfoDao, appVersion, dbVersion);
          break;
        case DevMockScenario.multipleUsersScenario:
          await _generateMultipleUsersScenario(journalWriterDao, appGlobalInfoDao, appVersion, dbVersion);
          break;
        case DevMockScenario.emptyScenario:
          await _generateEmptyScenario(appGlobalInfoDao, appVersion, dbVersion);
          break;
      }

      print('✅ 测试数据生成完成');

      // 显示生成结果
      await _displayGenerationResult(appGlobalInfoDao, journalWriterDao);
    } catch (e) {
      print('❌ 测试数据生成失败: $e');
      rethrow;
    }
  }

  /// 检查是否需要生成模拟数据
  ///
  /// 返回 true 表示需要生成数据（数据库为空或没有模拟数据）
  /// 返回 false 表示已有数据，不需要生成
  static Future<bool> _checkFirstLaunch(IAppGlobalInfoDao appGlobalInfoDao) async {
    try {
      final appInfo = await appGlobalInfoDao.getAppGlobalInfo();

      // 如果没有AppGlobalInfo记录，说明是初次启动
      if (appInfo == null) {
        print('📋 未找到应用全局信息，判断为初次启动');
        return true;
      }

      // 检查isFirstLaunch标志
      if (appInfo.isFirstLaunch) {
        print('📋 应用全局信息显示为初次启动');
        return true;
      }

      // 检查是否已初始化默认数据
      if (!appInfo.isDefaultDataInitialized) {
        print('📋 默认数据未初始化，需要生成模拟数据');
        return true;
      }

      print('📋 应用已启动过且默认数据已初始化，跳过模拟数据生成');
      return false;
    } catch (e) {
      print('⚠️ 检查初次启动状态失败: $e，默认为初次启动');
      return true; // 出错时默认为初次启动
    }
  }

  /// 检查是否已有用户数据
  ///
  /// 返回 true 表示已有用户数据
  /// 返回 false 表示没有用户数据
  static Future<bool> _checkExistingUserData(IJournalWriterDao journalWriterDao) async {
    try {
      final userCount = await journalWriterDao.getWriterCount();
      print('📋 当前用户数量: $userCount');
      return userCount > 0;
    } catch (e) {
      print('⚠️ 检查用户数据失败: $e，默认为无用户数据');
      return false;
    }
  }

  /// 标记默认数据已初始化
  ///
  /// 当发现已有数据时，标记默认数据已初始化状态
  static Future<void> _markDefaultDataInitialized(IAppGlobalInfoDao appGlobalInfoDao) async {
    try {
      final success = await appGlobalInfoDao.markDefaultDataInitialized();
      if (success) {
        print('✅ 已标记默认数据为已初始化状态');
      } else {
        print('⚠️ 标记默认数据初始化状态失败');
      }
    } catch (e) {
      print('❌ 标记默认数据初始化状态时出错: $e');
    }
  }

  /// 获取场景名称
  static String _getScenarioName(DevMockScenario scenario) {
    switch (scenario) {
      case DevMockScenario.defaultScenario:
        return '默认场景';
      case DevMockScenario.existingUserScenario:
        return '已使用场景';
      case DevMockScenario.multipleUsersScenario:
        return '多用户场景';
      case DevMockScenario.emptyScenario:
        return '空场景';
    }
  }

  /// 生成默认场景数据
  static Future<void> _generateDefaultScenario(
    IJournalWriterDao journalWriterDao,
    IAppGlobalInfoDao appGlobalInfoDao,
    String appVersion,
    int dbVersion,
  ) async {
    print('📝 生成默认场景数据...');

    // 创建默认AppGlobalInfo
    final appGlobalInfo = AppGlobalInfoMockGenerator.generateDefaultAppGlobalInfo(
      appVersion: appVersion,
      dbVersion: dbVersion,
    );
    await _createAppGlobalInfo(appGlobalInfoDao, appGlobalInfo);

    // 创建默认用户
    final defaultWriter = JournalWriterMockGenerator.generateDefaultWriter();
    await _createJournalWriter(journalWriterDao, defaultWriter);

    // 标记默认数据已初始化
    await _markDefaultDataInitialized(appGlobalInfoDao);

    print('✅ 默认场景数据生成完成');
  }

  /// 生成已使用场景数据
  static Future<void> _generateExistingUserScenario(
    IJournalWriterDao journalWriterDao,
    IAppGlobalInfoDao appGlobalInfoDao,
    String appVersion,
    int dbVersion,
  ) async {
    print('📝 生成已使用场景数据...');

    // 创建已使用过的AppGlobalInfo
    final appGlobalInfo = AppGlobalInfoMockGenerator.generateUsedAppGlobalInfo(
      appVersion: appVersion,
      dbVersion: dbVersion,
    );
    await _createAppGlobalInfo(appGlobalInfoDao, appGlobalInfo);

    // 创建默认用户
    final defaultWriter = JournalWriterMockGenerator.generateDefaultWriter();
    await _createJournalWriter(journalWriterDao, defaultWriter);

    // 标记默认数据已初始化
    await _markDefaultDataInitialized(appGlobalInfoDao);

    print('✅ 已使用场景数据生成完成');
  }

  /// 生成多用户场景数据
  static Future<void> _generateMultipleUsersScenario(
    IJournalWriterDao journalWriterDao,
    IAppGlobalInfoDao appGlobalInfoDao,
    String appVersion,
    int dbVersion,
  ) async {
    print('📝 生成多用户场景数据...');

    // 创建已使用过的AppGlobalInfo
    final appGlobalInfo = AppGlobalInfoMockGenerator.generateUsedAppGlobalInfo(
      appVersion: appVersion,
      dbVersion: dbVersion,
    );
    await _createAppGlobalInfo(appGlobalInfoDao, appGlobalInfo);

    // 创建多个测试用户
    final testWriters = JournalWriterMockGenerator.generateMultipleWriters(count: 3);
    for (int i = 0; i < testWriters.length; i++) {
      await _createJournalWriter(journalWriterDao, testWriters[i]);
      print('✅ 测试用户 ${i + 1} 创建完成: ${testWriters[i].username}');
    }

    // 标记默认数据已初始化
    await _markDefaultDataInitialized(appGlobalInfoDao);

    print('✅ 多用户场景数据生成完成');
  }

  /// 生成空场景数据
  static Future<void> _generateEmptyScenario(
    IAppGlobalInfoDao appGlobalInfoDao,
    String appVersion,
    int dbVersion,
  ) async {
    print('📝 生成空场景数据...');

    // 只创建默认AppGlobalInfo，不创建用户
    final appGlobalInfo = AppGlobalInfoMockGenerator.generateDefaultAppGlobalInfo(
      appVersion: appVersion,
      dbVersion: dbVersion,
    );
    await _createAppGlobalInfo(appGlobalInfoDao, appGlobalInfo);

    // 标记默认数据已初始化（即使没有用户数据）
    await _markDefaultDataInitialized(appGlobalInfoDao);

    print('✅ 空场景数据生成完成');
  }

  /// 创建AppGlobalInfo数据
  static Future<void> _createAppGlobalInfo(
    IAppGlobalInfoDao appGlobalInfoDao,
    dynamic appGlobalInfo,
  ) async {
    try {
      final infoId = await appGlobalInfoDao.initializeAppGlobalInfo(
        appVersion: appGlobalInfo.appVersion,
        dbVersion: appGlobalInfo.dbVersion,
        appLanguage: appGlobalInfo.appLanguage,
        themeMode: appGlobalInfo.themeMode,
        extendedConfig: appGlobalInfo.extendedConfig,
      );
      print('✅ AppGlobalInfo 创建成功，ID: $infoId');
    } catch (e) {
      print('❌ AppGlobalInfo 创建失败: $e');
      rethrow;
    }
  }

  /// 创建JournalWriter数据
  static Future<void> _createJournalWriter(
    IJournalWriterDao journalWriterDao,
    dynamic writer,
  ) async {
    try {
      if (JournalWriterMockGenerator.validateWriterData(writer)) {
        final writerId = await journalWriterDao.createWriter(
          username: writer.username,
          currentWriter: writer.currentWriter,
          gender: writer.gender,
          birthDay: writer.birthDay,
          avatar: writer.avatar,
          birthPlace: writer.birthPlace,
        );
        print('✅ JournalWriter 创建成功: ${writer.username} (ID: $writerId)');
      } else {
        throw Exception('用户数据验证失败');
      }
    } catch (e) {
      final errorMsg = e.toString();
      if (errorMsg.contains('用户名已存在') || errorMsg.contains('username')) {
        print('⚠️ JournalWriter 创建跳过: ${writer.username} (用户名已存在)');
        // 不重新抛出异常，因为这是预期的情况
      } else {
        print('❌ JournalWriter 创建失败: ${writer.username}, 错误: $e');
        rethrow;
      }
    }
  }

  /// 显示生成结果
  static Future<void> _displayGenerationResult(
    IAppGlobalInfoDao appGlobalInfoDao,
    IJournalWriterDao journalWriterDao,
  ) async {
    try {
      print('=' * 50);
      print('📊 测试数据生成结果');
      print('=' * 50);

      // 显示应用全局信息
      final appInfo = await appGlobalInfoDao.getAppGlobalInfo();
      if (appInfo != null) {
        print('📱 应用信息:');
        print('  版本: ${appInfo.appVersion}');
        print('  数据库版本: ${appInfo.dbVersion}');
        print('  首次启动: ${appInfo.isFirstLaunch ? '是' : '否'}');
        print('  启动次数: ${appInfo.launchCount}');
        print('  最后启动: ${appInfo.lastLaunchTime}');
        print('  语言: ${AppGlobalInfoMockGenerator.getLanguageText(appInfo.appLanguage)}');
        print('  主题: ${AppGlobalInfoMockGenerator.getThemeModeText(appInfo.themeMode)}');
        print('  默认数据已初始化: ${appInfo.isDefaultDataInitialized ? '是' : '否'}');
      }

      // 显示用户信息
      final writers = await journalWriterDao.getAllWriters(limit: 10);
      print('👥 用户信息:');
      if (writers.isEmpty) {
        print('  暂无用户数据');
      } else {
        print('  用户数量: ${writers.length}');
        for (int i = 0; i < writers.length; i++) {
          final writer = writers[i];
          print('  用户 ${i + 1}: ${writer.username} (ID: ${writer.id})');
        }
      }

      print('=' * 50);
    } catch (e) {
      print('❌ 显示生成结果失败: $e');
    }
  }

  /// 快速生成默认测试数据
  ///
  /// 便捷方法，用于快速生成默认场景的测试数据
  /// [checkFirstLaunch] 是否检查初次启动（默认true）
  static Future<void> generateDefaultTestData({
    required IJournalWriterDao journalWriterDao,
    required IAppGlobalInfoDao appGlobalInfoDao,
    required String appVersion,
    required int dbVersion,
    bool forceReset = false,
    bool checkFirstLaunch = true,
  }) async {
    await generateDevMockData(
      journalWriterDao: journalWriterDao,
      appGlobalInfoDao: appGlobalInfoDao,
      appVersion: appVersion,
      dbVersion: dbVersion,
      scenario: DevMockScenario.defaultScenario,
      forceReset: forceReset,
      checkFirstLaunch: checkFirstLaunch,
    );
  }

  /// 快速生成多用户测试数据
  ///
  /// 便捷方法，用于快速生成多用户场景的测试数据
  /// [checkFirstLaunch] 是否检查初次启动（默认true）
  static Future<void> generateMultiUserTestData({
    required IJournalWriterDao journalWriterDao,
    required IAppGlobalInfoDao appGlobalInfoDao,
    required String appVersion,
    required int dbVersion,
    bool forceReset = false,
    bool checkFirstLaunch = true,
  }) async {
    await generateDevMockData(
      journalWriterDao: journalWriterDao,
      appGlobalInfoDao: appGlobalInfoDao,
      appVersion: appVersion,
      dbVersion: dbVersion,
      scenario: DevMockScenario.multipleUsersScenario,
      forceReset: forceReset,
      checkFirstLaunch: checkFirstLaunch,
    );
  }

  /// 在 main.dart 中调用的便捷方法
  ///
  /// 专门为 main.dart 启动时调用设计，自动检查初次启动
  /// 只在初次启动时生成测试数据，避免重复生成
  ///
  /// [journalWriterDao] Journal Writer 数据访问对象
  /// [appGlobalInfoDao] App Global Info 数据访问对象
  /// [appVersion] 当前应用版本号
  /// [dbVersion] 当前数据库版本号
  /// [scenario] 测试场景（默认为defaultScenario）
  /// [enableInDebugMode] 是否仅在调试模式下启用（默认true）
  static Future<void> initializeForMain({
    required IJournalWriterDao journalWriterDao,
    required IAppGlobalInfoDao appGlobalInfoDao,
    required String appVersion,
    required int dbVersion,
    DevMockScenario scenario = DevMockScenario.defaultScenario,
    bool enableInDebugMode = true,
  }) async {
    try {
      // 检查是否在调试模式
      if (enableInDebugMode) {
        // 这里可以添加 kDebugMode 检查，但为了避免导入依赖，暂时注释
        // if (!kDebugMode) {
        //   print('⚠️ 非调试模式，跳过测试数据生成');
        //   return;
        // }
      }

      print('🚀 main.dart 启动：检查是否需要生成测试数据');

      // 自动检查初次启动并生成数据
      await generateDevMockData(
        journalWriterDao: journalWriterDao,
        appGlobalInfoDao: appGlobalInfoDao,
        appVersion: appVersion,
        dbVersion: dbVersion,
        scenario: scenario,
        forceReset: false, // main.dart 调用时不强制重置
        checkFirstLaunch: true, // 必须检查初次启动
      );
    } catch (e) {
      print('❌ main.dart 测试数据初始化失败: $e');
      // 不重新抛出异常，避免影响应用启动
    }
  }

  /// 重置所有数据（仅调试模式使用）
  static Future<void> _resetAllData(
    IJournalWriterDao journalWriterDao,
    IAppGlobalInfoDao appGlobalInfoDao,
  ) async {
    try {
      print('🧹 正在重置所有数据...');

      // 重置应用全局信息
      await appGlobalInfoDao.resetAppGlobalInfo();
      print('✅ 应用全局信息已重置');

      // 获取所有用户并删除
      final allWriters = await journalWriterDao.getAllWriters();
      int deletedCount = 0;
      for (final writer in allWriters) {
        if (writer.id != null) {
          final success = await journalWriterDao.deleteWriter(writer.id!);
          if (success) {
            deletedCount++;
          }
        }
      }
      print('✅ 用户数据已重置，删除了 $deletedCount 个用户');
    } catch (e) {
      throw Exception('重置数据失败: $e');
    }
  }

  /// 检查应用状态
  ///
  /// 用于调试和监控应用状态
  static Future<AppStatus> checkAppStatus(
    IAppGlobalInfoDao appGlobalInfoDao,
    IJournalWriterDao journalWriterDao,
  ) async {
    try {
      final appInfo = await appGlobalInfoDao.getAppGlobalInfo();
      final writers = await journalWriterDao.getAllWriters();

      return AppStatus(
        hasAppGlobalInfo: appInfo != null,
        isFirstLaunch: appInfo?.isFirstLaunch ?? true,
        isDefaultDataInitialized: appInfo?.isDefaultDataInitialized ?? false,
        launchCount: appInfo?.launchCount ?? 0,
        userCount: writers.length,
        appVersion: appInfo?.appVersion ?? 'Unknown',
        dbVersion: appInfo?.dbVersion ?? 0,
      );
    } catch (e) {
      throw Exception('检查应用状态失败: $e');
    }
  }

  /// 清理所有测试数据
  ///
  /// 用于开发模式下清理所有测试数据
  static Future<void> clearAllTestData({
    required IJournalWriterDao journalWriterDao,
    required IAppGlobalInfoDao appGlobalInfoDao,
  }) async {
    try {
      print('🧹 正在清理所有测试数据...');
      await _resetAllData(journalWriterDao, appGlobalInfoDao);
      print('✅ 所有测试数据清理完成');
    } catch (e) {
      print('❌ 清理测试数据失败: $e');
      rethrow;
    }
  }
}

/// 应用状态信息
class AppStatus {
  final bool hasAppGlobalInfo;
  final bool isFirstLaunch;
  final bool isDefaultDataInitialized;
  final int launchCount;
  final int userCount;
  final String appVersion;
  final int dbVersion;

  const AppStatus({
    required this.hasAppGlobalInfo,
    required this.isFirstLaunch,
    required this.isDefaultDataInitialized,
    required this.launchCount,
    required this.userCount,
    required this.appVersion,
    required this.dbVersion,
  });

  @override
  String toString() {
    return 'AppStatus('
        'hasAppGlobalInfo: $hasAppGlobalInfo, '
        'isFirstLaunch: $isFirstLaunch, '
        'isDefaultDataInitialized: $isDefaultDataInitialized, '
        'launchCount: $launchCount, '
        'userCount: $userCount, '
        'appVersion: $appVersion, '
        'dbVersion: $dbVersion'
        ')';
  }
}
