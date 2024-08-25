import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: Colors.lightBlueAccent, // Off-white text color for large body text
          fontSize: 16, // Adjust as needed
        ),
        bodyMedium: TextStyle(
          color: Color(0xFFFAFAFA),
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: Color(0xFFFAFAFA),
          fontSize: 12,
        ),
        headlineLarge: TextStyle(
          color: Color(0xFFFAFAFA),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Color(0xFFFAFAFA),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: Color(0xFFFAFAFA),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[850],
        labelStyle: TextStyle(color: Color(0xFFFAFAFA)),
        hintStyle: TextStyle(color: Color(0xFFFAFAFA)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueAccent,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: Color(0xFF333333), // Dark text color for light mode
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF333333),
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: Color(0xFF333333),
          fontSize: 12,

        ),
        headlineLarge: TextStyle(
          color: Color(0xFF333333),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Color(0xFF333333),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: Color(0xFF333333),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[200],
        labelStyle: TextStyle(color: Color(0xFF333333)),
        hintStyle: TextStyle(color: Color(0xFF333333)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueAccent,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
