import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // 🌙 Dark / Light mode
  bool _isDark = false;
  bool get isDark => _isDark;

  void themeOnChanged() {
    _isDark = !_isDark;
    notifyListeners();
  }

  // 🌍 Locale (Language)
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  void changeLocale(String langCode) {
    _locale = Locale(langCode);
    notifyListeners();
  }
}