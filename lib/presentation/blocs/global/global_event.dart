import 'package:flutter/material.dart';

abstract class GlobalEvent {}

class SaveControllerEvent extends GlobalEvent {
  final PageController controller;
  SaveControllerEvent(this.controller);
}

class ToggleGrayThemeEvent extends GlobalEvent {
  final bool isGray;

  ToggleGrayThemeEvent({required this.isGray});
}

class SavePageControllerEvent extends GlobalEvent {
  final PageController pageController;

  SavePageControllerEvent({required this.pageController});
} 