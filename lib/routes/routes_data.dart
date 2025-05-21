import 'package:flutter/material.dart';
import 'package:WeekLife/routes/route_name.dart';
import 'package:WeekLife/presentation/pages/error_page/error_page.dart';
import 'package:WeekLife/presentation/pages/app_main/app_main.dart';
import 'package:WeekLife/presentation/pages/splash/splash.dart';
import 'package:WeekLife/presentation/pages/test_demo/test_demo.dart';
import 'package:WeekLife/presentation/pages/Login/Login.dart';

final String initialRoute = RouteName.splashPage; // 初始默认显示的路由

final Map<String,
        StatefulWidget Function(BuildContext context, {dynamic params})>
    routesData = {
  // 页面路由定义...
  RouteName.appMain: (context, {params}) => AppMain(params: params),
  RouteName.splashPage: (context, {params}) => SplashPage(),
  RouteName.error: (context, {params}) => ErrorPage(params: params),
  RouteName.testDemo: (context, {params}) => TestDemo(params: params),
  RouteName.login: (context, {params}) => Login(params: params),
};
