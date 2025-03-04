import 'package:flutter/material.dart';
import 'package:pi_dashboard/logger.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());
  Future<void>.delayed(Duration.zero, () => settingsController.loadSettings());

  Log().info("Application started");
  runApp(MyApp(settingsController: settingsController));
  Log().info("Application stopped");
}
