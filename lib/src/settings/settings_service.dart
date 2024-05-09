import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final themeIdx = prefs.getInt("theme");
    if (themeIdx == null) return ThemeMode.system;

    return ThemeMode.values[themeIdx];
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("theme", theme.index);
  }

  Future<String> keyStr(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final res = prefs.getString(key);
    if (res == null) return "";
    return res;
  }
  Future<void> setKeyStr(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
