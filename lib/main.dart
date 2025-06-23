import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WeekLife/components/layouts/basic_layout.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jh_debug/jh_debug.dart' show DebugMode, jhDebug, jhDebugMain;
import 'routes/generate_route.dart' show generateRoute;
import 'routes/routes_data.dart'; // 路由配置
import 'providers_config.dart' show providersConfig; // providers配置文件
import 'package:WeekLife/presentation/blocs/theme/theme_bloc.dart'; // 主题 Bloc
import 'package:WeekLife/presentation/blocs/theme/theme_state.dart'; // 主题状态
import 'package:WeekLife/presentation/blocs/global/global_bloc.dart'; // 全局 Bloc
import 'package:WeekLife/core/config/common_config.dart' show commonConfig;
import 'package:ana_page_loop/ana_page_loop.dart' show anaAllObs;
import 'package:WeekLife/core/utils/app_setup/index.dart' show appSetupInit;
import 'package:WeekLife/core/utils/database/database_manager.dart'; // 添加数据库管理器导入
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:WeekLife/core/config/app_config.dart';
// forui 样式系统
import 'package:forui/forui.dart';
import 'package:WeekLife/theme/theme.dart';

import 'package:WeekLife/data/mock/app_initialization_helper.dart';
import 'package:WeekLife/data/dao/journal_writer/journal_writer_dao.dart';
import 'package:WeekLife/data/dao/app_global_info/app_global_info_dao.dart';
import 'package:flutter/foundation.dart';
import 'package:WeekLife/presentation/widgets/debug/debug_panel.dart';
import 'package:WeekLife/core/utils/logger.dart';
import 'package:WeekLife/core/services/reminder_service.dart';
import 'package:WeekLife/core/services/location_manager.dart';

void main() async {
  // 设置Zone错误为致命错误（可选，用于调试）
  // BindingBase.debugZoneErrorsAreFatal = true;

  WidgetsFlutterBinding.ensureInitialized(); // 必须第一行

  // 初始化日志配置
  _initLogger();

  // 创建应用实例
  final app = MultiProvider(
    providers: providersConfig,
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => GlobalBloc()),
      ],
      child: const App(),
    ),
  );

  // 运行应用
  runApp(app);

  // 在应用启动后异步初始化其他服务
  Future.microtask(() async {
    try {
      // 初始化数据库
      await DatabaseManager.initialize();
      AppLogger.success('数据库初始化成功', tag: 'App');

      // 在调试模式下生成测试数据
      if (kDebugMode) {
        final database = DatabaseManager.instance.database;
        final journalWriterDao = JournalWriterDao(database);
        final appGlobalInfoDao = AppGlobalInfoDao(database);

        await DevMockDataHelper.generateDefaultTestData(
          journalWriterDao: journalWriterDao,
          appGlobalInfoDao: appGlobalInfoDao,
          appVersion: '1.0.0',
          dbVersion: 3,
          checkFirstLaunch: true,
        );
      }

      // 异步初始化其他服务
      await Future.wait([
        ReminderService().initialize().then((_) {
          AppLogger.success('提醒服务初始化成功', tag: 'App');
        }),
        LocationManager().initialize().then((_) {
          AppLogger.success('定位管理器初始化成功', tag: 'App');
        }),
      ]);

      // 启动后台定位服务
      final locationStarted = await LocationManager().startBackgroundLocation();
      if (locationStarted) {
        AppLogger.success('后台定位服务启动成功', tag: 'App');
      } else {
        AppLogger.warning('后台定位服务启动失败', tag: 'App');
      }
    } catch (e) {
      AppLogger.error('应用初始化失败', tag: 'App', error: e);
    }
  });
}

/// 初始化日志配置
void _initLogger() {
  if (kDebugMode) {
    // 开发环境：启用所有日志
    AppLogger.setLevel(LogLevel.debug);
    AppLogger.setConsoleOutput(true);
  } else {
    // 生产环境：只显示错误和警告
    AppLogger.setLevel(LogLevel.warning);
    AppLogger.setConsoleOutput(false);
  }
}

class App extends StatelessWidget {
  const App({super.key});

  static final theme = zincLight;

  // 静态变量跟踪调试面板状态
  static bool _isDebugModalShowing = false;

  /// 检查是否为调试模式
  bool _isDebugMode() {
    return kDebugMode;
  }

  /// 显示调试面板 Modal
  void _showDebugModal(BuildContext context) {
    // 防止重复弹出
    if (_isDebugModalShowing) return;

    // 使用 navigatorKey 获取正确的 context
    final navigatorContext = jhDebug.getNavigatorKey.currentContext;
    if (navigatorContext == null) return;

    _isDebugModalShowing = true;
    // 使用统一的 DebugBottomSheet
    DebugBottomSheet.show(navigatorContext);

    // 延迟重置状态，确保弹窗已经显示
    Future.delayed(const Duration(milliseconds: 500), () {
      _isDebugModalShowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    jhDebug.setGlobalKey = commonConfig.getGlobalKey;
    appSetupInit();

    // 输出调试数据
    // AppDebugger.printAllDebugInfo();

    return ScreenUtilInit(
      designSize: AppConfig.screenSize, // 按你的设计稿尺寸调整
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              navigatorKey: jhDebug.getNavigatorKey,
              showPerformanceOverlay: false,
              locale: const Locale('zh', 'CH'),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('zh', 'CH'),
                Locale('en', 'US'),
              ],
              // theme: state.themeData!,

              theme: theme.toApproximateMaterialTheme(),
              initialRoute: initialRoute,
              onGenerateRoute: generateRoute, // 路由处理
              debugShowCheckedModeBanner: false,
              navigatorObservers: [...anaAllObs()],
              builder: (context, child) {
                return FTheme(
                  data: theme,
                  child: Stack(
                    children: [
                      BasicLayout(child: child ?? Container()),
                      // 全局调试按钮
                      if (_isDebugMode())
                        Positioned(
                          right: 172,
                          top: 60,
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor: Colors.red.withValues(alpha: 0.8),
                            foregroundColor: Colors.white,
                            heroTag: "global_debug_fab",
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              _showDebugModal(context);
                            },
                            child: const Icon(
                              Icons.bug_report,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
