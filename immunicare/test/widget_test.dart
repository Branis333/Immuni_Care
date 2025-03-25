import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immunicare/theme/theme_state.dart';

void main() {
  group('ThemeState tests', () {
    test('should have correct default values', () {
      final state = ThemeState(isDarkMode: false, themeData: ThemeData.light());
      expect(state.isDarkMode, false);
    });
    
    test('should properly handle state changes', () {
      final state1 = ThemeState(isDarkMode: false, themeData: ThemeData.light());
      final state2 = ThemeState(isDarkMode: true, themeData: ThemeData.dark());
      
      expect(state1.isDarkMode, false);
      expect(state2.isDarkMode, true);
    });
  });
}