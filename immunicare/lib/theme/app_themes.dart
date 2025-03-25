import 'package:flutter/material.dart';

// These color constants will be used for both light and dark themes
final Color primaryBlue = Color(0xFF407CE2);
final Color lightBlue = Color(0xFF80A3F0); 
final Color veryLightBlue = Color(0xFFB3C8F6);
final Color ultraLightBlue = Color(0xFFE6EEFB);
final Color darkBlue = Color(0xFF2A5CD0);
final Color veryDarkBlue = Color(0xFF1D45AB);

// Define dark colors
final Color darkBackground = Color(0xFF121212);
final Color darkSurface = Color(0xFF1E1E1E);
final Color darkCardColor = Color(0xFF2C2C2C);
final Color darkAccent = Color(0xFF5E92E4); // Lighter blue for dark theme

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: darkBlue, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: darkBlue),
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    iconTheme: IconThemeData(
      color: darkBlue,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return primaryBlue;
          }
          return Colors.white;
        },
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
    ),
    dividerColor: Colors.grey[300],
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkAccent,
    scaffoldBackgroundColor: darkBackground,
    cardColor: darkCardColor,
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkAccent,
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white70),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    iconTheme: IconThemeData(
      color: darkAccent,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return darkAccent;
          }
          return darkSurface;
        },
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkAccent,
        foregroundColor: Colors.white,
      ),
    ),
    dividerColor: Colors.grey[800],
  );
}