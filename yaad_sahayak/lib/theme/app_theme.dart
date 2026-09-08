import 'package:flutter/material.dart';

class AppTheme {
  // ================= COLORS =================

  static const Color backgroundColor = Color(0xFF080B14);
  static const Color cardColor = Color(0xFF111827);
  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFF3B82F6);

  static const Color borderColor = Color(0xFF263548);
  static const Color secondaryTextColor = Color(0xFF9CA3AF);

  // ================= DARK THEME =================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,

      // ================= COLOR SCHEME =================

      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
        surface: cardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),

      // ================= SCAFFOLD =================

      scaffoldBackgroundColor: backgroundColor,

      // ================= APP BAR =================

      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,

        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),

        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),

      // ================= CARDS =================

      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: borderColor,
          ),
        ),
      ),

      // ================= ELEVATED BUTTON =================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          elevation: 0,

          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================= FLOATING ACTION BUTTON =================

      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),

      // ================= INPUT FIELDS =================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,

        hintStyle: const TextStyle(
          color: secondaryTextColor,
        ),

        labelStyle: const TextStyle(
          color: secondaryTextColor,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: borderColor,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: borderColor,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: accentColor,
            width: 1.5,
          ),
        ),
      ),

      // ================= TEXT THEME =================

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        headlineMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        titleLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        titleMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),

        bodyLarge: TextStyle(
          color: Colors.white,
        ),

        bodyMedium: TextStyle(
          color: secondaryTextColor,
        ),
      ),

      // ================= SNACKBAR =================

      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardColor,
        contentTextStyle: const TextStyle(
          color: Colors.white,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}