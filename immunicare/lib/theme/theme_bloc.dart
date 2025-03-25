import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunicare/theme/theme_event.dart';
import 'package:immunicare/theme/theme_state.dart';
import 'package:immunicare/theme/app_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<InitializeThemeEvent>(_onInitializeTheme);
    on<ToggleThemeEvent>(_onToggleTheme);

    // Initialize theme on creation
    add(InitializeThemeEvent());
  }

  Future<void> _onInitializeTheme(
    InitializeThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;

    emit(ThemeState(
      isDarkMode: isDarkMode,
      themeData: isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme,
    ));
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final newIsDarkMode = !state.isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newIsDarkMode);

    emit(ThemeState(
      isDarkMode: newIsDarkMode,
      themeData: newIsDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme,
    ));
  }
}
