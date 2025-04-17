import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Color(AppConstants.primaryColor),
    colorScheme: ColorScheme.light(
      primary: Color(AppConstants.primaryColor),
      secondary: Color(AppConstants.secondaryColor),
      error: Color(AppConstants.errorColor),
    ),
    appBarTheme: AppBarTheme(
      color: Color(AppConstants.primaryColor),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.grey[800],
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(AppConstants.primaryColor),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(AppConstants.primaryColor)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(AppConstants.errorColor)),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(
      primary: Color(AppConstants.secondaryColor),
      secondary: Color(AppConstants.accentColor),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.grey[900],
    ),
  );
}