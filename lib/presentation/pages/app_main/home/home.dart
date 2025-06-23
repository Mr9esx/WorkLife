import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';
import 'package:WeekLife/common/ui/week_selector/week_selector.dart';
import 'package:WeekLife/core/utils/index.dart';

/// Home 页面组件
/// StatefulWidget 表示这是一个有状态的组件，可以动态更新UI
/// 与 StatelessWidget 的区别：StatefulWidget 可以保存状态，而 StatelessWidget 是无状态的
class Home extends StatelessWidget {
  const Home({super.key, this.params});
  final dynamic params;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()
        ..add(InitDatabaseEvent())
        ..add(RefreshWriterEvent()),
      child: const HomeView(),
    );
  }
}

/// Home 页面的状态类
/// 继承自 State<Home>，表示这是 Home 组件的状态类
/// with AutomaticKeepAliveClientMixin 表示保持页面状态，防止切换时重建
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedWeek = 1;

  @override
  void initState() {
    super.initState();
    _selectedWeek = DateUtil.getCurrentWeekNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildOriginalContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOriginalContent(BuildContext context) {
    final blankNode = FocusNode();
    return Stack(
      children: [
        GestureDetector(
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
                      // 周选择器
                      Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 24),
                        child: WeekSelector(
                          currentWeek: _selectedWeek,
                          onWeekSelected: (week) {
                            setState(() {
                              _selectedWeek = week;
                            });

                            // 触发数据刷新或其他业务逻辑
                            bloc.add(RefreshWriterEvent());

                            // 可选：显示选择反馈
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('已切换到第$week周'),
                                duration: const Duration(milliseconds: 800),
                              ),
                            );
                          },
                        ),
                      ),

                      // 其他内容区域
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // 这里可以添加基于选中周份的内容
                            Card(
                              color: AppColors.cardBackground,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '第$_selectedWeek周',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '这里可以显示该周的具体内容和数据',
                                      style: TextStyle(
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
