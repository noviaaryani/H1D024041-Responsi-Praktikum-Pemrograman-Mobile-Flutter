import 'package:flutter/material.dart';

class AppTheme {
  // Palet Warna: Pink Pastel, Soft Sky Blue, & Pure White
  static const Color primaryPink = Color(0xFFFF85A2);
  static const Color softPink = Color(0xFFFFD1DC);
  static const Color backgroundLightPink = Color(0xFFFFF0F5);
  
  static const Color primaryBlue = Color(0xFF64B5F6);
  static const Color softBlue = Color(0xFFB3E5FC);
  static const Color deepBlue = Color(0xFF2B3A67);
  
  static const Color white = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF2D3142);
  static const Color textMuted = Color(0xFF9098B1);

  // Gradient Aesthetic Langit Cantik (Pink to Sky Blue)
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFB6C1), // Light pink
      Color(0xFFE0C3FC), // Soft lavender
      Color(0xFF8EC5FC), // Sky blue
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF9F9FF),
    ],
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF8F9FE),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPink,
        primary: primaryPink,
        secondary: primaryBlue,
        surface: white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 4,
        shadowColor: primaryPink.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
