import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunicare/theme/theme_event.dart';
import 'package:immunicare/theme/theme_state.dart';
import 'package:immunicare/theme/app_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Bloc responsible for managing the application's theme.
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<InitializeThemeEvent>(_onInitializeTheme);
    on<ToggleThemeEvent>(_onToggleTheme);

    // Initialize theme on creation
    add(InitializeThemeEvent());
  }
  // Handler for initializing the theme.
  Future<void> _onInitializeTheme(
    InitializeThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    // Fetch the shared preferences instance.
    final prefs = await SharedPreferences.getInstance();
    // Retrieve the theme mode from preferences, defaulting to false (light mode) if not set.
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
     // Emit the theme state based on the retrieved preference.
    emit(ThemeState(
      isDarkMode: isDarkMode,
      themeData: isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme,
    ));
  }
// Handler for toggling the theme.
  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    // Toggle the current theme mode.
    final newIsDarkMode = !state.isDarkMode;
    // Fetch the shared preferences instance.
    final prefs = await SharedPreferences.getInstance();
    // Save the new theme mode in preferences.
    await prefs.setBool('isDarkMode', newIsDarkMode);
    // Emit the new theme state based on the toggled preference.
    emit(ThemeState(
      isDarkMode: newIsDarkMode,
      themeData: newIsDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme,
    ));
  }
}
