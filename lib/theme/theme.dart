import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: Colors.white,
      primary: Colors.white.withOpacity(0.8),
      secondary: Colors.white.withOpacity(0.6),
      tertiary: Colors.white.withOpacity(0.4),
      surfaceTint: Colors.black,
    ));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade800,
      primary: Colors.grey.shade800.withOpacity(0.8),
      secondary: Colors.grey.shade800.withOpacity(0.6),
      tertiary: Colors.grey.shade800.withOpacity(0.4),
      surfaceTint: Colors.white,
    ));
