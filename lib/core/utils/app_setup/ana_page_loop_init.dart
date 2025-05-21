import 'package:ana_page_loop/ana_page_loop.dart' show anaPageLoop;
import 'package:WeekLife/core/config/app_config.dart' show AppConfig;
import 'package:WeekLife/routes/route_name.dart' show RouteName;
import 'package:WeekLife/core/utils/tool/log_util.dart';

/// 初始化埋点统计插件
void anaPageLoopInit() {
  anaPageLoop.init(
    beginPageFn: (name) {
      // TODO: 第三方埋点统计开始
      LogUtil.d('待添加：埋点统计开始$name');
    },
    endPageFn: (name) {
      // TODO: 第三方埋点统计结束
      LogUtil.d('待添加：埋点统计结束$name');
    },
    routeRegExp: [RouteName.appMain], // 过滤路由
    debug: AppConfig.DEBUG, // 路由调试
  );
}
