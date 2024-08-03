import 'package:flutter/material.dart';

//https://coolors.co/palette/757bc8-8187dc-8e94f2-9fa0ff-ada7ff-bbadff-cbb2fe-dab6fc-ddbdfc-e0c3fc

ThemeData buildThemeData() {
  return ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: Color.fromARGB(255, 52, 209, 191),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 94, 178, 224),
      elevation: 0,
      titleTextStyle: TextStyle(
        // color: Color.fromARGB(255, 0, 53, 84),
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
        shadows: [
        Shadow(
          color: Color.fromARGB(255, 0, 53, 84),      
          blurRadius: 2.5,          
          offset: Offset(2.5, 2.0), 
        ),
      ],
      ),
    ),

    textTheme: const TextTheme(
      // displayLarge: TextStyle(
      //   color: Color.fromARGB(255, 244, 251, 255),
      // ),
      // titleLarge: TextStyle(
      //   color: Color.fromARGB(255, 244, 251, 255),
      // ),
      bodyMedium: TextStyle(
        color: Color.fromARGB(255, 244, 251, 255),
        shadows: [
        Shadow(
          color: Color.fromARGB(255, 0, 53, 84),      
          blurRadius: 2.5,          
          offset: Offset(2.5, 2.0), 
        ),
      ],
      ),
      // displaySmall: TextStyle(
      //   color: Color.fromARGB(255, 244, 251, 255),
      // ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 0, 53, 84),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
  );
}

