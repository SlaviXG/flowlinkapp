import 'package:flutter/material.dart';

const Color accentColor = Color(0xFF8E94F2);
const Color backgroundBodyColorStart = Color.fromARGB(255, 145, 206, 255);
const Color backgroundBodyColorEnd = Color.fromARGB(255, 61, 120, 197);
const Color titleTextColor = Color.fromARGB(255, 244, 251, 255);
const Color shadowColor = Color.fromARGB(255, 0, 29, 46);
const Color circularIndicatorColor = Color.fromARGB(255, 226, 227, 247);

ThemeData buildThemeData() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
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
