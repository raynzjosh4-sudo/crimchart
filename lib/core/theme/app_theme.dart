import 'package:flutter/material.dart';
import 'design_system.dart';

class AppTheme {
  static ThemeData get lightTheme => theme(brightness: Brightness.light);
  static ThemeData get darkTheme => theme(brightness: Brightness.dark);

  static BoxDecoration globalBackgroundDecoration(
    BuildContext context, {
    bool isDark = true,
  }) {
    if (!isDark) {
      return const BoxDecoration(color: Color.fromARGB(255, 245, 245, 245));
    }
    return const BoxDecoration(
      color: Color(0xFF110E0D), // Fallback
      gradient: RadialGradient(
        center: Alignment(-0.8, -1.0), // Top left corner
        radius: 1.5,
        colors: [
          Color(0xFF4A1A10), // Reddish brown shader at the corner
          Color(0xFF110E0D), // Main dark color
          Color(0xFF0A0A0A), // Fades to deeper black
        ],
        stops: [0.0, 0.4, 1.0],
      ),
    );
  }

  static ThemeData theme({
    required Brightness brightness,
    Color primaryColor = const Color(0xFFFFB300), // Warmer gold to match UI
    String fontFamily = 'Comic Relief',
  }) {
    final isDark = brightness == Brightness.dark;
    final scaffoldColor = isDark
        ? const Color(0xFF110E0D) // 👑 SOLID BACKGROUND
        : const Color.fromARGB(255, 245, 245, 245);
    final textColor = isDark ? Colors.white : Colors.black;

    // Soft Shadow Helper
    final softShadow = AppShadows.diffused(
      color: isDark
          ? Colors.black.withValues(alpha: 0.4)
          : Colors.black.withValues(alpha: 0.08),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldColor,
      primaryColor: primaryColor,
      fontFamily: fontFamily,

      // Card Theme with Squircles and Soft Shadows
      cardTheme: CardThemeData(
        shape: AppShapes.cardSquircle,
        elevation: 0,
        color: isDark ? const Color(0xFF1E1C1B) : Colors.white,
        clipBehavior: Clip.antiAlias,
      ),

      // Button Themes with Squircles
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: AppShapes.buttonSquircle,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(shape: AppShapes.buttonSquircle),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: AppShapes.buttonSquircle,
          side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
        ),
      ),

      // Dialog & Sheet Themes
      dialogTheme: DialogThemeData(
        shape: AppShapes.squircle(radius: 28),
        elevation: 8,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: AppShapes.squircle(radius: 32),
        clipBehavior: Clip.antiAlias,
        backgroundColor: isDark ? const Color(0xFF1E1C1B) : Colors.white,
      ),

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
        onPrimary: isDark ? Colors.black : Colors.white,
        secondary: primaryColor,
        onSecondary: isDark ? Colors.black : Colors.white,
        secondaryContainer: primaryColor.withValues(alpha: 0.2),
        error: Colors.redAccent,
        onError: Colors.white,
        surface: isDark ? const Color(0xFF141110) : Colors.white,
        onSurface: textColor,
        surfaceContainerHighest: isDark
            ? const Color(0xFF231D1C) // Warmer dark brown
            : const Color(0xFFF5F0EE), // Warmer light surface
        onSurfaceVariant: textColor.withValues(alpha: 0.7),
      ),
    );
  }
}
