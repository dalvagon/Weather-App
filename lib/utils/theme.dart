import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomColors {
  static const int primary = 0xFF4831D4;
}

class Palette {
  static const MaterialColor primary = MaterialColor(
    CustomColors.primary,
    <int, Color>{
      50: Color(0xFFEDEBFF),
      100: Color(0xFFC7C2FF),
      200: Color(0xFFA19AFF),
      300: Color(0xFF7B73FF),
      400: Color(0xFF655CFF),
      500: Color(CustomColors.primary),
      600: Color(0xFF3E2ED4),
      700: Color(0xFF3728B2),
      800: Color(0xFF2F2291),
      900: Color(0xFF271C70),
    },
  );
}

ThemeData theme = ThemeData(
    primarySwatch: Palette.primary,
    primaryColor: Palette.primary,
    colorScheme: ColorScheme.dark(
      primary: Palette.primary,
      secondary: Palette.primary,
      surface: Palette.primary[800]!,
      background: Palette.primary[900]!,
      error: Colors.red,
      onPrimary: Palette.primary[50]!,
      onSecondary: Palette.primary[50]!,
      onSurface: Palette.primary[50]!,
      onBackground: Palette.primary[50]!,
      onError: Colors.red[50]!,
    ),
    primaryColorDark: Palette.primary[900],
    primaryColorLight: Palette.primary[50],
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(elevation: 0, color: Palette.primary),
    scaffoldBackgroundColor: Palette.primary[900],
    cardColor: Palette.primary[800],
    textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme));
