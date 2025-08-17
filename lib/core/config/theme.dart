import 'package:flutter/material.dart';

ThemeData myTheme = ThemeData(
  primaryColor: const Color.fromARGB(255, 218, 165, 121),
  appBarTheme: AppBarTheme(backgroundColor: Colors.grey[50]),
  scaffoldBackgroundColor: Colors.grey[50],
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey[50],
  ),
  bottomAppBarTheme: BottomAppBarThemeData(color: Colors.grey[200]),
  unselectedWidgetColor: Colors.grey[500],
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color.fromARGB(255, 218, 165, 121),
    onPrimary: Colors.grey.shade300,
    secondary: Colors.deepOrange,
    onSecondary: Colors.black87,
    error: Colors.red,
    onError: Colors.grey.shade300,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
);
