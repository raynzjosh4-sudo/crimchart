import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_strings.dart';

class LocalizationProvider extends ChangeNotifier {
  String _currentLocale = 'en';

  String get currentLocale => _currentLocale;

  void setLocale(String locale) {
    if (AppStrings.translations.containsKey(locale)) {
      _currentLocale = locale;
      notifyListeners();
    }
  }

  String tr(String key, {Map<String, String>? args}) {
    String value = AppStrings.translations[_currentLocale]?[key] ?? 
                  AppStrings.translations['en']?[key] ?? 
                  key;
    
    if (args != null) {
      args.forEach((k, v) {
        value = value.replaceAll('{$k}', v);
      });
    }
    
    return value;
  }
}

extension LocalizationExtension on BuildContext {
  String tr(String key, {Map<String, String>? args, bool listen = true}) => 
      Provider.of<LocalizationProvider>(this, listen: listen).tr(key, args: args);
}





























