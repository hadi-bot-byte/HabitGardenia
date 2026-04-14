import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GradeCalculatorApp());
}

class GradeCalculatorApp extends StatelessWidget {
  const GradeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Grade Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6D1A2A),
          brightness: Brightness.light,
        ).copyWith(
          primary: const Color(0xFF6D1A2A),
          secondary: const Color(0xFF3E1A0E),
          surface: const Color(0xFFFDF6F0),
        ),
        scaffoldBackgroundColor: const Color(0xFFFDF6F0),
        fontFamily: 'Georgia',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6D1A2A),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: const Color(0xFF6D1A2A).withOpacity(0.15),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6D1A2A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFB08070)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD4A89A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF6D1A2A), width: 2),
          ),
          filled: true,
          fillColor: const Color(0xFFFFF8F5),
          labelStyle: const TextStyle(color: Color(0xFF8B3A3A)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
