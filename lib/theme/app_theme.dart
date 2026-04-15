import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF2D6A4F);
  static const Color secondary = Color(0xFF52B788);
  static const Color accent = Color(0xFFD8F3DC);
  static const Color earth = Color(0xFF8B6F47);
  static const Color sky = Color(0xFF87CEEB);
  static const Color sunlight = Color(0xFFFFE066);
  static const Color background = Color(0xFFF0F7EE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1B4332);
  static const Color textLight = Color(0xFF6B8C6B);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          surface: surface,
        ),
        textTheme: GoogleFonts.nunitoTextTheme().copyWith(
          titleLarge: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
          bodyLarge: GoogleFonts.nunito(
            fontSize: 16,
            color: textDark,
          ),
          bodyMedium: GoogleFonts.nunito(
            fontSize: 14,
            color: textLight,
          ),
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: background,
          elevation: 0,
          titleTextStyle: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
      );
}
