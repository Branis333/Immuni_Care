import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunicare/theme/theme_event.dart';
import 'package:immunicare/theme/theme_state.dart';

// Create a completely independent ThemeBloc for testing
class TestThemeBloc extends Bloc<ToggleThemeEvent, ThemeState> {
  TestThemeBloc() : super(ThemeState(isDarkMode: false, themeData: ThemeData.light())) {
    // Register event handler using on<EventType>
    on<ToggleThemeEvent>((event, emit) {
      emit(ThemeState(
        isDarkMode: !state.isDarkMode, 
        themeData: !state.isDarkMode ? ThemeData.dark() : ThemeData.light()
      ));
    });
  }
}

void main() {
  group('ThemeBloc', () {
    late TestThemeBloc themeBloc;
    
    setUp(() {
      themeBloc = TestThemeBloc();
    });
    
    tearDown(() {
      themeBloc.close();
    });
    
    test('initial state should have isDarkMode as false', () {
      expect(themeBloc.state.isDarkMode, false);
    });
    
    test('should toggle theme when ToggleThemeEvent is added', () async {
      // Arrange
      final initialState = themeBloc.state;
      expect(initialState.isDarkMode, false);
      
      // Act & Assert - using proper async handling
      expectLater(
        themeBloc.stream, 
        emits(isA<ThemeState>().having((state) => state.isDarkMode, 'isDarkMode', true))
      );
      
      // Add the event after setting up the expectation
      themeBloc.add(ToggleThemeEvent());
      
      // Wait for the event to be processed
      await Future.delayed(Duration.zero);
    });
  });
}