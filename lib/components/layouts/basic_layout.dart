import 'package:flutter/material.dart';

class BasicLayout extends StatelessWidget {
  final Widget child;

  const BasicLayout({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child
    );
  }
} 