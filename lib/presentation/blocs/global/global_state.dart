import 'package:flutter/material.dart';

class GlobalState {
  final PageController? barTabsController;
  final bool isGrayTheme;
  final PageController? pageController;

  GlobalState({
    this.barTabsController,
    this.isGrayTheme = false,
    this.pageController,
  });

  GlobalState copyWith({
    PageController? barTabsController,
    bool? isGrayTheme,
    PageController? pageController,
  }) {
    return GlobalState(
      barTabsController: barTabsController ?? this.barTabsController,
      isGrayTheme: isGrayTheme ?? this.isGrayTheme,
      pageController: pageController ?? this.pageController,
    );
  }
} 