import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeViewModel(String? savedTheme)
    : _themeMode = switch (savedTheme) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  Future<void> changeTheme(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.themeKey, mode.name);
    notifyListeners();
  }

  bool get isSystem => _themeMode == ThemeMode.system;
  bool get isLight => _themeMode == ThemeMode.light;
  bool get isDark => _themeMode == ThemeMode.dark;
}
