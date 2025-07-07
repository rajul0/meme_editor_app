import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meme_editor_app/core/theme/app_theme.dart';

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final Box settingsBox = Hive.box('settings');

  ThemeBloc()
      : super(ThemeState(
          themeData: Hive.box('settings').get('isDarkMode', defaultValue: false)
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
          isDarkMode:
              Hive.box('settings').get('isDarkMode', defaultValue: false),
        )) {
    on<ToggleTheme>((event, emit) {
      final isDark = !state.isDarkMode;
      final newTheme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

      settingsBox.put('isDarkMode', isDark);

      emit(ThemeState(
        themeData: newTheme,
        isDarkMode: isDark,
      ));
    });
  }
}

// Event
abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

// State
class ThemeState {
  final ThemeData themeData;
  final bool isDarkMode;

  ThemeState({required this.isDarkMode, required this.themeData});
}
