import 'package:flutter/material.dart';
import 'package:pi_dashboard/src/proxmox_lister/proxmox_lister_list_view.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',

          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case ProxmoxListerView.routeName:
                    return ProxmoxListerView(settings: settingsController);
                  default:
                    return ProxmoxListerView(settings: settingsController);
                }
              },
            );
          },
        );
      },
    );
  }
}
