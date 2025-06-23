import 'package:flutter/material.dart';
import 'dart:async';
import 'package:WeekLife/routes/route_name.dart';
import 'package:WeekLife/common/ui/icon/app_icon.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/core/utils/database/database_manager.dart';
import 'package:WeekLife/presentation/widgets/animate/animated_grid_pattern_optimized.dart';

/// APP入口全屏广告页面
class AdPage extends StatefulWidget {
  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  late Timer? _timer;
  int timeCount = 0;

  @override
  void initState() {
    _initSplash();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// App广告页逻辑。
  void _initSplash() {
    const timeDur = Duration(seconds: 1); // 1秒

    _timer = Timer.periodic(timeDur, (Timer t) {
      if (timeCount <= 0) {
        _timer?.cancel();
        Navigator.pushReplacementNamed(context, RouteName.intro);
        return;
      }
      timeCount--;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return PopScope(
      canPop: false,
      child: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(0, -100),
            child: AnimatedGridPatternOptimized(
              squares: [[0, 0], [1, 2], [2, 3]],
              gridSize: screenWidth * 0.1, // 响应式网格大小
              blinkFrequency: 2.0, // 闪动频率：2秒一个周期
              blinkRange: 0.8, // 闪动范围：从0.1到0.9的透明度
              minOpacity: 0.1, // 最小透明度
              maxOpacity: 0.9, // 最大透明度
              enableTapInteraction: false, // 启用点击交互
              gridLineColor: AppColors.secondary.withAlpha((0.5 * 255).round()), // 网格线条颜色
              squareColor: AppColors.secondary, // 方块颜色
              tapSquareColor: AppColors.secondary, // 点击方块颜色
            ),
          ),
          // 居中显示 Logo
          Center(
            child: Transform.translate(
              offset: Offset(5, -50), // 可以调整这里的值进行微调
              child: AppIcon(
                assetName: 'logo2',
                size: 80,
                color: AppColors.primary,
              ),
            ),
          ),
          // 使用FutureBuilder来处理异步数据
          FutureBuilder<List<dynamic>>(
            future: DatabaseManager.instance.database.select(DatabaseManager.instance.database.journalWriterTable).get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('writerCount: ${snapshot.data!.length}');
              }
              return SizedBox.shrink(); // 不显示任何内容，只用于调试
            },
          ),
          // flotSkipWidget(),
        ],
      ),
    );
  }

  Widget flotSkipWidget() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      right: 20,
      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(context, RouteName.appMain);
        },
        child: Container(
          alignment: Alignment.center,
          width: 70,
          height: 30,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 2.0),
                blurRadius: 2.0,
              ),
            ],
          ),
          child: const Text('跳过', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

