import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:WeekLife/common/ui/color/color_light.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Search页面'),
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
      body: Container(
        color: Colors.green,
        width: double.infinity,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('搜索内容'),
          ],
        ),
      ),
    );
  }
}
