import 'package:WeekLife/core/utils/index.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:WeekLife/common/ui/color/color_light.dart';

class Hot extends StatefulWidget {
  const Hot({super.key, this.params});
  final dynamic params;

  @override
  State<Hot> createState() => _HotState();
}

class _HotState extends State<Hot> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    LogUtil.d(widget.params);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('hot页面'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.appBackground.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: List.generate(1, (index) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'hot页面',
                  style: TextStyle(fontSize: 32),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
