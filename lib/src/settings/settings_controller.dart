import 'package:flutter/material.dart';

import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _hostname = await _settingsService.keyStr("hostname");
    _username = await _settingsService.keyStr("username");
    _password = await _settingsService.keyStr("password");
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;
  late String _hostname;
  String get hostname => _hostname;
  late String _username;
  String get username => _username;
  late String _password;
  String get password => _password;

  Future<void> _setKey(String key, String value) async {
    notifyListeners();
    await _settingsService.setKeyStr(key, value);
  }

  Future<void> setHostname(String newHostname) async {
    _hostname = newHostname;
    await _setKey("hostname", hostname);
  }
  Future<void> setUsername(String newUsername) async {
    _username = newUsername;
    await _setKey("username", username);
  }
  Future<void> setPassword(String newPassword) async {
    _password = newPassword;
    await _setKey("password", password);
  }
  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }
}
