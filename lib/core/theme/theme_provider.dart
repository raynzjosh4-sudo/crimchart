import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  Color _currentColor = AppTheme.darkTheme.primaryColor;
  String _currentFontFamily = 'Inter'; // Default font
  double _displayScale = 1.0; // Accessibility scale factor
  ThemeMode _themeMode = ThemeMode.dark;

  Color get currentColor => _currentColor;
  String get currentFontFamily => _currentFontFamily;
  double get displayScale => _displayScale;
  ThemeMode get themeMode => _themeMode;

  void updateColor(Color newColor) {
    if (_currentColor != newColor) {
      _currentColor = newColor;
      notifyListeners();
    }
  }

  void updateFontFamily(String newFontFamily) {
    if (_currentFontFamily != newFontFamily) {
      _currentFontFamily = newFontFamily;
      notifyListeners();
    }
  }

  void updateDisplayScale(double newScale) {
    if (_displayScale != newScale) {
      _displayScale = newScale;
      notifyListeners();
    }
  }

  void updateThemeMode(ThemeMode newMode) {
    if (_themeMode != newMode) {
      _themeMode = newMode;
      notifyListeners();
    }
  }
}





























