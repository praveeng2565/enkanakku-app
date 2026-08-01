import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeViewModel() {
    loadTheme();
  }

  static const String _themeKey = 'app_theme';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final theme = prefs.getString(_themeKey);

    switch (theme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;

      case 'dark':
        _themeMode = ThemeMode.dark;
        break;

      case 'system':
      default:
        _themeMode = ThemeMode.system;
    }
  }

  Future<void> changeTheme(ThemeMode mode) async {
    _themeMode = mode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);

    notifyListeners();
  }

  bool get isSystem => _themeMode == ThemeMode.system;

  bool get isLight => _themeMode == ThemeMode.light;

  bool get isDark => _themeMode == ThemeMode.dark;
}
