import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomColors {
  static const int primary = 0x224193;
  static const int secondary = 0x6F9BD1;
}

class Palette {
  static const MaterialColor primary = MaterialColor(
    CustomColors.primary,
    <int, Color>{
      50: Color(0xFFE8EAF6),
      100: Color(0xFFC5CAE9),
      200: Color(0xFF9FA8DA),
      300: Color(0xFF7986CB),
      400: Color(0xFF5C6BC0),
      500: Color(0xFF3F51B5),
      600: Color(0xFF3949AB),
      700: Color(0xFF303F9F),
      800: Color(0xFF283593),
      900: Color(0xFF1A237E),
    },
  );

  static const MaterialColor secondary = MaterialColor(
    CustomColors.secondary,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF2196F3),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );
}

ThemeData theme = ThemeData(
    primarySwatch: Palette.primary,
    appBarTheme: const AppBarTheme(elevation: 0, centerTitle: false),
    colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Palette.secondary,
        brightness: Brightness.dark,
        primary: Palette.primary[900]!,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
        background: Colors.black,
        surface: Colors.black),
    textTheme: GoogleFonts.novaMonoTextTheme(ThemeData.dark().textTheme));
