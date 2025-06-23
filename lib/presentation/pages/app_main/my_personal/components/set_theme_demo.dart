import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:WeekLife/presentation/blocs/theme/theme_bloc.dart';
import 'package:WeekLife/presentation/blocs/theme/theme_event.dart';
import 'package:WeekLife/presentation/blocs/global/global_bloc.dart';
import 'package:WeekLife/presentation/blocs/global/global_event.dart';
import 'package:WeekLife/presentation/blocs/global/global_state.dart';
import 'package:WeekLife/core/constants/themes/index_theme.dart';

class SetThemeDemo extends StatefulWidget {
  @override
  State<SetThemeDemo> createState() => _SetThemeDemoState();
}

class _SetThemeDemoState extends State<SetThemeDemo> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: <Widget>[
                const Text('全局主题色切换', style: TextStyle(fontSize: 30)),
                btnWidget('切换粉色主题', themePink, Colors.pink),
                btnWidget('切换蓝灰主题', themeBlueGrey, Colors.blueGrey),
                btnWidget('切换天空蓝主题', themeLightBlue, Colors.lightBlue),
                btnWidget('暗模式', ThemeData.dark(), ThemeData.dark().colorScheme.surface),
                grayBtn(state.isGrayTheme),
              ],
            ),
          ],
        );
      },
    );
  }

  /// 灰度按钮
  Widget grayBtn(bool isGray) {
    return ElevatedButton(
      child: Text(
        '灰度模式--${isGray ? "开启" : "关闭"}',
        style: const TextStyle(fontSize: 22),
      ),
      onPressed: () {
        HapticFeedback.selectionClick();
        context.read<GlobalBloc>().add(ToggleGrayThemeEvent(isGray: !isGray));
      },
    );
  }

  Widget btnWidget(String title, ThemeData themeData, Color color) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.selectionClick();
        context.read<ThemeBloc>().add(ThemeChangedEvent(themeData));
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(color),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, color: Colors.white70),
      ),
    );
  }
}
