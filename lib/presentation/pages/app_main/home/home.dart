import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:WeekLife/presentation/widgets/common/update_app/check_app_version.dart';
import 'package:WeekLife/routes/route_name.dart';
import 'package:WeekLife/core/config/app_env.dart' show appEnv;
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';

/// Home 页面组件
/// StatefulWidget 表示这是一个有状态的组件，可以动态更新UI
/// 与 StatelessWidget 的区别：StatefulWidget 可以保存状态，而 StatelessWidget 是无状态的
class Home extends StatelessWidget {
  const Home({Key? key, this.params}) : super(key: key);
  final dynamic params;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(InitDatabaseEvent())..add(RefreshWriterEvent()),
      child: const HomeView(),
    );
  }
}

/// Home 页面的状态类
/// 继承自 State<Home>，表示这是 Home 组件的状态类
/// with AutomaticKeepAliveClientMixin 表示保持页面状态，防止切换时重建
class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blankNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: const Text('home页面'),
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(blankNode);
        },
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.errorMsg != null && state.errorMsg!.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMsg!)),
              );
            }
          },
          builder: (context, state) {
            final bloc = context.read<HomeBloc>();
            return ListView(
              children: [
                Column(
                  children: <Widget>[
                    Text('App渠道：${appEnv.getAppChannel()}'),
                    _button(
                      '跳转test页',
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RouteName.testDemo,
                          arguments: {'data': '别名路由传参666'},
                        );
                      },
                    ),
                    if (state.isInitializing)
                      const Text('数据库初始化中...'),
                    if (!state.isDbInitialized)
                      const Text('数据库未初始化'),
                    if (state.isDbInitialized && state.writer == null)
                      const Text('加载中...'),
                    if (state.writer != null)
                      Text('作家: ${state.writer?.username ?? '未找到'}'),
                    Text('状态管理值：${state.counter}'),
                    _button(
                      '加+',
                      onPressed: state.isDbInitialized ? () {
                        bloc.add(IncrementEvent());
                      } : null,
                    ),
                    _button(
                      '减-',
                      onPressed: state.isDbInitialized ? () {
                        bloc.add(DecrementEvent());
                      } : null,
                    ),
                    _button(
                      '新增writer',
                      onPressed: state.isDbInitialized ? () {
                        bloc.add(CreateWriterEvent());
                      } : null,
                    ),
                    _button(
                      '修改writer名字',
                      onPressed: state.isDbInitialized ? () {
                        bloc.add(UpdateWriterNameEvent());
                      } : null,
                    ),
                    _button(
                      '强制更新App',
                      onPressed: () {
                        checkAppVersion(forceUpdate: true);
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 自定义按钮组件
  /// 参数：
  /// - text: 按钮文本
  /// - onPressed: 点击回调函数，VoidCallback? 表示可空的回调函数
  Widget _button(String text, {VoidCallback? onPressed}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 22.sp),
        ),
      ),
    );
  }
}
