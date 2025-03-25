import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunicare/theme/theme_state.dart';

// A simple class to replace ThemeBloc for testing
class TestThemeBloc extends Cubit<ThemeState> {
  TestThemeBloc() : super(ThemeState(isDarkMode: false, themeData: ThemeData.light()));
  
  void toggleTheme() {
    emit(ThemeState(
      isDarkMode: !state.isDarkMode,
      themeData: state.isDarkMode ? ThemeData.light() : ThemeData.dark()
    ));
  }
}

// Skip Firebase setup entirely
Future<void> setupFirebaseForTesting() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  // No Firebase initialization - we'll mock what we need
}

// Create a test app with the necessary providers
Widget createTestApp(Widget child) {
  return BlocProvider<TestThemeBloc>(
    create: (context) => TestThemeBloc(),
    child: MaterialApp(
      home: child,
    ),
  );
}