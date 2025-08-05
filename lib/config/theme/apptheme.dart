import 'package:flutter/material.dart';

class AppTheme {
  // Universal
  static const Color universalColor = Colors.white;

  // Brand Colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Color.fromARGB(255, 100, 34, 206);

  // Backgrounds
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF1B1E28);

  // Button and Borders
  static const Color buttonBackground = Color(0xFF7E22CE);
  static const Color borderColor = Color(0xFF9333EA);
  static const Color secondaryBackground = Color(0xFF6B21A8);

  // Accent
  static const Color accentColor = Color(0xFFD8B4FE);

  // Error
  static const Color errorColor = Colors.red;

  // Text
  static const Color textPrimary = Colors.black;
  static const Color textOnPrimary = Colors.white;
}
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Roboto',

  scaffoldBackgroundColor: AppTheme.backgroundLight,
  splashColor: AppTheme.primaryColor,

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      backgroundColor: AppTheme.buttonBackground,
      foregroundColor: AppTheme.textOnPrimary,
      elevation: 0,
    ),
  ),

  colorScheme: const ColorScheme.light(
    primary: AppTheme.primaryColor,
    secondary: AppTheme.backgroundLight,
    surface: Colors.white,
    error: AppTheme.errorColor,
    onPrimary: AppTheme.textOnPrimary,
    onSecondary: AppTheme.textPrimary,
    onSurface: AppTheme.textPrimary,
    onError: AppTheme.textOnPrimary,
    brightness: Brightness.light,
  ),

  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 72.0,
      fontWeight: FontWeight.bold,
      color: AppTheme.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.w300,
      color: AppTheme.textPrimary,
    ),
    bodySmall: TextStyle(
      fontSize: 12.0,
      color: AppTheme.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 15.0,
      color: AppTheme.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
      color: AppTheme.textPrimary,
    ),
  ),
);
