import 'package:flutter/material.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double widthMultiplier;
  static late double heightMultiplier;

  // Change from 360 / 800 to a modern baseline (iPhone 13/14)
  static const double _designWidth = 390.0;
  static const double _designHeight = 844.0;

  static void init(BuildContext context, {double userScaleFactor = 1.0}) {
    if (context.mounted) {
      final Size size = MediaQuery.of(context).size;
      screenWidth = size.width;
      screenHeight = size.height;

      // Calculate the raw multiplier
      double rawWidthMultiplier = (screenWidth / _designWidth);

      // Clamp the multiplier so it doesn't get ridiculously huge on tablets/large phones.
      // E.g., it can shrink infinitely, but won't grow larger than 1.1x the normal size.
      widthMultiplier = rawWidthMultiplier.clamp(0.0, 1.1) * userScaleFactor;

      // Calculate true height multiplier
      double rawHeightMultiplier = (screenHeight / _designHeight);

      // Clamp height multiplier so it never compresses vertically much more than horizontally
      heightMultiplier =
          (rawHeightMultiplier < (widthMultiplier * 0.85)
              ? (widthMultiplier * 0.85)
              : rawHeightMultiplier) *
          userScaleFactor;
    }
  }
}

extension ResponsiveSize on num {
  /// Scales the dimension proportionally to the screen width.
  /// Use this for horizontal dimensions: width, padding right/left, margins.
  double get w {
    try {
      return this * SizeConfig.widthMultiplier;
    } catch (e) {
      // Fallback if accessed before init
      return toDouble();
    }
  }

  /// Scales the dimension proportionally to the screen height.
  double get h {
    try {
      return this * SizeConfig.heightMultiplier;
    } catch (e) {
      // Fallback if accessed before init
      return toDouble();
    }
  }

  /// Scales font sizes based on a balanced multiplier (width is usually safer for text)
  double get sp {
    try {
      return this * SizeConfig.widthMultiplier;
    } catch (e) {
      return toDouble();
    }
  }

  /// Scales the radius based on width multiplier.
  double get r {
    try {
      return this * SizeConfig.widthMultiplier;
    } catch (e) {
      return toDouble();
    }
  }
}
