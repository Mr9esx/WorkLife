import 'package:flutter/material.dart';

class BasicLayout extends StatelessWidget {
  final Widget child;

  const BasicLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
} 