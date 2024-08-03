import 'package:flutter/material.dart';

const Color accentColor = Color(0xFF8E94F2);
const Color backgroundBodyColorStart = Color(0xFF9FA0FF);
const Color backgroundBodyColorEnd = Color.fromARGB(255, 102, 95, 204);
const Color titleTextColor = Color.fromARGB(255, 244, 251, 255);
const Color shadowColor = Color.fromARGB(255, 0, 53, 84);

ThemeData buildThemeData() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent, // Set to transparent to allow the gradient to show

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent, // Set to transparent to allow gradient to show
      elevation: 0,
      titleTextStyle: TextStyle(
        color: titleTextColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
        shadows: [
          Shadow(
            color: shadowColor,
            blurRadius: 2.5,
            offset: Offset(2.5, 2.0),
          ),
        ],
      ),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: titleTextColor,
        shadows: [
          Shadow(
            color: shadowColor,
            blurRadius: 2.5,
            offset: Offset(2.5, 2.0),
          ),
        ],
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: shadowColor,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
  );
}
