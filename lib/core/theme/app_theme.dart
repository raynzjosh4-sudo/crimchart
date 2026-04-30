import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => theme(brightness: Brightness.light);
  static ThemeData get darkTheme => theme(brightness: Brightness.dark);

  static ThemeData theme({
    required Brightness brightness,
    Color primaryColor = const Color(0xFFFFD700),
    String fontFamily = 'Comic Relief',
  }) {
    final isDark = brightness == Brightness.dark;
    final scaffoldColor = isDark
        ? const Color(0xFF121212)
        : const Color.fromARGB(255, 245, 245, 245);
    final textColor = isDark ? Colors.white : Colors.black;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldColor,
      primaryColor: primaryColor,
      fontFamily: fontFamily,
      textTheme: Typography.englishLike2021.apply(
        fontFamily: fontFamily,
        fontSizeFactor: 1.15,
        bodyColor: textColor,
        displayColor: textColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
        ),
      ),
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primaryColor,
        onPrimary: Colors.black,
        secondary: primaryColor,
        onSecondary: Colors.black,
        secondaryContainer: primaryColor.withOpacity(0.2),
        error: Colors.red,
        onError: Colors.white,
        surface: isDark ? const Color(0xFF1F1F1F) : Colors.white,
        onSurface: textColor,
        surfaceContainerHighest: isDark
            ? const Color(0xFF2C2C2C)
            : const Color(0xFFE0E0E0),
        onSurfaceVariant: textColor.withOpacity(0.7),
      ),
    );
  }
}
