import 'package:flutter_bloc/flutter_bloc.dart';
import 'global_event.dart';
import 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(GlobalState(isGrayTheme: false)) {
    on<SaveControllerEvent>(_onSaveController);
    on<ToggleGrayThemeEvent>(_onToggleGrayTheme);
    on<SavePageControllerEvent>(_onSavePageController);
  }

  void _onSaveController(SaveControllerEvent event, Emitter<GlobalState> emit) {
    emit(state.copyWith(barTabsController: event.controller));
  }

  void _onToggleGrayTheme(ToggleGrayThemeEvent event, Emitter<GlobalState> emit) {
    emit(state.copyWith(isGrayTheme: event.isGray));
  }

  void _onSavePageController(SavePageControllerEvent event, Emitter<GlobalState> emit) {
    emit(state.copyWith(pageController: event.pageController));
  }
} 