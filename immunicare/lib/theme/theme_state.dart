import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:immunicare/theme/app_themes.dart';

class ThemeState extends Equatable {
  final bool isDarkMode;
  final ThemeData themeData;

  const ThemeState({
    required this.isDarkMode,
    required this.themeData,
  });

  factory ThemeState.initial() {
    return ThemeState(
      isDarkMode: false,
      themeData: AppThemes.lightTheme,
    );
  }

  ThemeState copyWith({
    bool? isDarkMode,
    ThemeData? themeData,
  }) {
    return ThemeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      themeData: themeData ?? this.themeData,
    );
  }

  @override
  List<Object> get props => [isDarkMode, themeData];
}