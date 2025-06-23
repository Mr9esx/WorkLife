import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ana_page_loop/ana_page_loop.dart';
import 'package:flutter/rendering.dart';
import 'package:WeekLife/presentation/blocs/global/global_bloc.dart';
import 'package:WeekLife/presentation/blocs/global/global_state.dart';
import 'package:WeekLife/presentation/blocs/global/global_event.dart';
import 'package:WeekLife/core/config/app_config.dart';
import 'package:WeekLife/routes/route_name.dart';
import 'package:WeekLife/presentation/widgets/common/update_app/check_app_version.dart';
import 'package:WeekLife/presentation/widgets/common/exit_app_interceptor/exit_app_interceptor.dart';
import 'package:WeekLife/presentation/pages/app_main/home/home.dart';
import 'package:WeekLife/presentation/pages/app_main/hot/hot.dart';
import 'package:WeekLife/presentation/pages/app_main/search/search.dart';
import 'package:WeekLife/presentation/pages/app_main/my_personal/my_personal.dart';
import 'package:WeekLife/presentation/pages/app_main/journal/journal_main.dart';
import 'package:WeekLife/presentation/pages/app_main/custom_bottom_bar.dart';
import 'package:WeekLife/presentation/widgets/toast/toast.dart';
import 'package:WeekLife/presentation/blocs/journal/journal_edit_bloc.dart';

/// [params] 别名路由传递的参数
/// [params.pageId] 跳转到指定tab页面（0第一页），如果不是别名路由跳转的话，又想实现跳转到指定tab页面，推荐别名路由跳转方式。
///```dart
/// // 手动传入参数跳转路由方式如下：
/// Navigator.of(context).push(
///   MaterialPageRoute(
///     builder: (context) => BarTabs(
///       params: {'pageId': 2}, // 跳转到tabs的第三个页面
///     ),
///   )
/// );
///
/// // 别名路由跳转方式如下：
/// Navigator.pushNamed(context, '/testDemo', arguments: {
///   'pageId': 2,
/// });
/// ```
class AppMain extends StatefulWidget {
  final Map<String, dynamic>? params;

  const AppMain({super.key, this.params});

  @override
  State<AppMain> createState() => _AppMainState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('params', params));
  }
}

class _AppMainState extends State<AppMain> with PageViewListenerMixin, AutomaticKeepAliveClientMixin {
  int currentIndex = 0; // 接收bar当前点击索引
  bool physicsFlag = true; // 是否禁止左右滑动跳转tab
  late PageController pageController;
  String _currentJournalViewType = '单周视角'; // 当前周记视图类型

  @override
  bool get wantKeepAlive => true;

  // app主页底部bar
  List<Map<String, dynamic>> get appBottomBar => [
        {
          'title': '首页',
          'icon': Icons.home,
          'body': const Home(),
        },
        {
          'title': '周记',
          'icon': Icons.book,
          'body': JournalMain(viewType: _currentJournalViewType),
        },
        {
          'title': '热门',
          'icon': Icons.whatshot,
          'body': const Hot(),
        },
        {
          'title': '搜索',
          'icon': Icons.search,
          'body': Search(),
        },
        {
          'title': '我的',
          'icon': Icons.person,
          'body': MyPersonal(),
        },
      ];

  @override
  void initState() {
    super.initState();

    handleCurrentIndex();
    initTools();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GlobalBloc>().add(SavePageControllerEvent(pageController: pageController));

      // if (AppConfig.showJhDebugBtn) {
      //   jhDebug.showDebugBtn(); // jhDebug 调试按钮
      // }

      checkAppVersion(); // 更新APP版本检查

      /// 调试阶段，直接跳过此组件
      if (AppConfig.notSplash && AppConfig.directPageName.isNotEmpty && AppConfig.directPageName != RouteName.appMain) {
        Navigator.pushNamed(context, AppConfig.directPageName);
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    FocusScope.of(context).requestFocus(FocusNode()); // 选择焦点，收起键盘效果
    super.dispose();
  }

  /// 处理tab默认显示索引
  handleCurrentIndex() {
    if (widget.params != null) {
      // 默认加载页面
      if ((widget.params!["pageId"] ?? 0) as int >= appBottomBar.length) {
        currentIndex = (appBottomBar.length - 1);
      } else {
        currentIndex = widget.params!['pageId'] as int;
      }
    }

    // 初始化tab控制器
    pageController = PageController(initialPage: currentIndex, keepPage: true);
  }

  /// 初始化第三方插件插件
  initTools() {
    // // jhDebug插件初始化
    // jhDebug.init(
    //   context: context,
    //   btnTitle1: '开发',
    //   btnTap1: () {
    //     appEnv.setEnv = ENV.DEV;
    //     // AppConfig.host = appEnv.baseUrl;
    //   },
    //   btnTitle2: '定位测试',
    //   btnTap2: () {
    //     // 定位测试页面已移除
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('定位测试页面已移除')),
    //     );
    //   },
    //   btnTitle3: '生产',
    //   btnTap3: () {
    //     appEnv.setEnv = ENV.PROD;
    //     // AppConfig.host = appEnv.baseUrl;
    //   },
    // );
  }

  /// 实现PageViewListenerMixin类上的方法，供页面埋点使用
  @override
  PageViewMixinData initPageViewListener() {
    return PageViewMixinData(
      controller: pageController,
      tabsData: appBottomBar.map((data) => data['title'] as String).toList(),
    );
  }

  @override
  void didPopNext() {
    super.didPopNext();
  }

  @override
  // ignore: unnecessary_overrides
  void didPop() {
    super.didPop();
  }

  @override
  // ignore: unnecessary_overrides
  void didPush() {
    super.didPush();
  }

  @override
  // ignore: unnecessary_overrides
  void didPushNext() {
    super.didPushNext();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider(
      create: (context) => JournalEditBloc(),
      child: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, state) {
          return ColorFiltered(
            colorFilter: ColorFilter.mode(
              state.isGrayTheme ? const Color(0xff757575) : Colors.transparent,
              BlendMode.color,
            ),
            child: _scaffoldBody(),
          );
        },
      ),
    );
  }

  /// 页面Scaffold层组件
  Widget _scaffoldBody() {
    return Scaffold(
      extendBody: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            controller: pageController,
            physics: physicsFlag ? const NeverScrollableScrollPhysics() : null,
            children: bodyWidget(), // tab页面主体
            // 监听滑动
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          const Positioned(
            bottom: 30,
            child: ExitAppInterceptor(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex,
        onTap: (idx) {
          setState(() {
            currentIndex = idx;
          });
          // pageController.jumpToPage(idx);
        },
        onViewTypeChanged: (viewType) {
          setState(() {
            _currentJournalViewType = viewType;
          });
          ToastManager.show(context,
              title: '视图类型切换成功', type: ToastType.success, position: ToastPosition.bottom, showIcon: false);
          debugPrint('视图类型切换: $viewType');
        },
        backgroundColor: AppColors.appBackground,
      ),
    );
  }

  /// tab视图内容区域
  List<Widget> bodyWidget() {
    try {
      return appBottomBar.map((itemData) => itemData['body'] as Widget).toList();
    } catch (e) {
      throw Exception('appBottomBar变量缺少body参数，errorMsg:$e');
    }
  }
}
