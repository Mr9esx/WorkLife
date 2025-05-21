import 'package:flutter/material.dart';

abstract class ThemeEvent {}

class ThemeChangedEvent extends ThemeEvent {
  final ThemeData themeData;

  ThemeChangedEvent(this.themeData);
} 