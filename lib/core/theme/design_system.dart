import 'package:flutter/material.dart';

class AppShapes {
  static const double defaultRadius = 24.0;
  static const double buttonRadius = 16.0;
  static const double cardRadius = 20.0;

  static OutlinedBorder squircle({double radius = defaultRadius}) {
    return ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static OutlinedBorder buttonSquircle = squircle(radius: buttonRadius);
  static OutlinedBorder cardSquircle = squircle(radius: cardRadius);
}

class AppShadows {
  static List<BoxShadow> diffused({
    Color? color,
    double blurRadius = 20,
    Offset offset = const Offset(0, 4),
    double opacity = 0.08,
  }) {
    return [
      BoxShadow(
        color: color ?? Colors.black.withValues(alpha: opacity),
        blurRadius: blurRadius,
        offset: offset,
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> cardShadow = diffused();
  static List<BoxShadow> floatingShadow = diffused(
    blurRadius: 30,
    offset: const Offset(0, 10),
    opacity: 0.12,
  );
}
