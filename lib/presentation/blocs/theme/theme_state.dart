import 'package:flutter/material.dart';

class ThemeState {
  final ThemeData? themeData;

  ThemeState({this.themeData});

  ThemeState copyWith({
    ThemeData? themeData,
  }) {
    return ThemeState(
      themeData: themeData ?? this.themeData,
    );
  }
} 