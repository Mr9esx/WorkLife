import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WeekLife/core/constants/cache_constants.dart';
import 'package:WeekLife/routes/route_name.dart';
import 'package:WeekLife/core/config/app_config.dart' show AppConfig;
import 'package:WeekLife/core/utils/tool/sp_util.dart';
import 'package:WeekLife/presentation/pages/splash/components/ad_page.dart';
import 'components/welcome_page.dart';

/// 闪屏页。
class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Widget? child;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _initAsync();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  _initAsync() async {
    var isNew = await SpUtil.getData<bool>(CacheConstants.guideKey,
        defValue: !AppConfig.isShowWelcome);
    setState(() {
      /// 是否显示引导页。
      if (isNew) {
        SpUtil.setData(CacheConstants.guideKey, false);
        child = WelcomePage();
      } else {
        child = AdPage();
      }
    });

    /// 调试阶段，直接跳过此组件
    if (AppConfig.notSplash && context.mounted) {
      Navigator.pushReplacementNamed(context, RouteName.appMain);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      resizeToAvoidBottomInset: false,
    );
  }
}
