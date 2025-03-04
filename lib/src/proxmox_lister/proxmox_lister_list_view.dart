import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pi_dashboard/logger.dart';
import 'package:pi_dashboard/src/proxmox_webservice/model.dart';
import 'package:pi_dashboard/src/proxmox_webservice/service.dart';
import 'package:pi_dashboard/src/screen_helper.dart';
import 'package:pi_dashboard/src/settings/settings_controller.dart';
import '../settings/settings_view.dart';
import 'vm_card.dart';
import 'dart:io' show Platform;

class ProxmoxListerView extends StatefulWidget {
  const ProxmoxListerView({
    super.key,
    required this.settings,
  });

  static const routeName = '/proxmox_lister';

  final SettingsController settings;

  @override
  State<ProxmoxListerView> createState() => _ProxmoxListerState();
}

class _ProxmoxListerState extends State<ProxmoxListerView> {
  late Future<ProxmoxNodeMap> nodes;
  late SettingsController settings;

  late ProxmoxWebService _service;

  @override
  void initState() {
    super.initState();
    settings = super.widget.settings;

    nodes = Future<ProxmoxNodeMap>.delayed(Duration.zero, () => getVms());

    Timer.periodic(const Duration(seconds: 3), (_) {
      syncVMs((_) {});
    });
  }

  Future<ProxmoxNodeMap> getVms() async {
    await settings.loadSettings();
    _service = ProxmoxWebService(
      hostname: settings.hostname,
      username: settings.username,
      password: settings.password,
    );
    final success = await _service.authenticate();
    if (!success) {
      return Future.error(Exception("couldn't authenticate against Proxmox"));
    }
    Log().info("Server auth successful");

    ProxmoxNodeMap map = {};
    final nodes = await _service.listNodes();
    for (final node in nodes) {
      map[node] = await _service.listVms(node.node);
      Log().debug("received node [${node.node}] with ${map[node]?.length} vms");
    }
    return map;
  }

  void syncVMs(Function(Exception) onExcept) async {
    nodes = getVms();
    try {
      await nodes;
    } on Exception catch (e) {
      onExcept(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // infinite touch container to turn screen back on
    var widget = Stack(
      children: [
        Scaffold(
          appBar: appbar(context),
          body: bodyBuilder(context),
        ),
      ],
    );

    if (Platform.isLinux) {
      widget.children.add(screenActivator());
      return IdleTurnOff(
        timeout: const Duration(seconds: 60),
        onExpire: () async {
          await turnOffScreen();
          Log().info("No input for 60 seconds. Screen turned off");
        },
        child: widget,
      );
    } else {
      return widget;
    }
  }

  PreferredSizeWidget? appbar(BuildContext context) {
    var app = AppBar(
      title: const Text("Proxmox VMs"),
      actions: [
        IconButton(
          icon: const Icon(Icons.sync),
          onPressed: () {
            syncVMs((e) {
              showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: const Text("Error"),
                      content: Text(e.toString()),
                    );
                  });
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.restorablePushNamed(context, SettingsView.routeName);
          },
        ),
      ],
    );

    if (Platform.isLinux) {
      app.actions?.insert(
        0,
        IconButton(
          icon: const Icon(Icons.nightlight),
          onPressed: () {
            toggleScreen();
          },
        ),
      );
    }

    return app;
  }

  Widget bodyBuilder(BuildContext context) {
    return FutureBuilder<ProxmoxNodeMap>(
      future: nodes,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.requireData.isEmpty) {
            return const Center(child: Icon(Icons.block));
          }

          final nodeEntry = snapshot.requireData.entries.first;
          return ListView.builder(
            restorationId: "proxmoxVMLister",
            itemCount: nodeEntry.value.length,
            itemBuilder: (BuildContext ctx, int index) {
              return ProxmoxVmCard(
                node: nodeEntry.key,
                vm: nodeEntry.value[index],
                pmService: _service,
              );
            },
          );
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: const Text("error"),
            content: Text(snapshot.error.toString()),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
