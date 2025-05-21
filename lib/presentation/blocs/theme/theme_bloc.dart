import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:WeekLife/core/constants/themes/index_theme.dart';
import 'package:WeekLife/presentation/blocs/theme/theme_event.dart';
import 'package:WeekLife/presentation/blocs/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: themeBlueGrey)) {
    on<ThemeChangedEvent>(_onThemeChanged);
  }

  void _onThemeChanged(ThemeChangedEvent event, Emitter<ThemeState> emit) {
    emit(state.copyWith(themeData: event.themeData));
  }
} 