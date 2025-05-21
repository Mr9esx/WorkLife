import 'package:flutter/material.dart';
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
import 'package:WeekLife/core/utils/database/database_manager.dart';  // 添加数据库管理器导入
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:WeekLife/core/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 必须第一行
  await _initApp();
  jhDebugMain(
    appChild: MultiProvider(
      providers: providersConfig,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc()),
          BlocProvider(create: (_) => GlobalBloc()),
        ],
        child: const MyApp(),
      ),
    ),
    debugMode: DebugMode.inConsole,
    errorCallback: (details) {},
  );
}

Future<void> _initApp() async {
  try {
    await DatabaseManager.initialize();
  } catch (e) {
    print('数据库初始化失败: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    jhDebug.setGlobalKey = commonConfig.getGlobalKey;
    appSetupInit();
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
              theme: state.themeData!,
              initialRoute: initialRoute,
              onGenerateRoute: generateRoute, // 路由处理
              debugShowCheckedModeBanner: false,
              navigatorObservers: [...anaAllObs()],
              builder: (context, child) => BasicLayout(child: child ?? Container()),
            );
          },
        );
      },
    );
  }
}
