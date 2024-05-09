import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pi_dashboard/src/proxmox_webservice/model.dart';
import 'package:pi_dashboard/src/proxmox_webservice/service.dart';
import 'package:pi_dashboard/src/screen_helper.dart';
import 'package:pi_dashboard/src/settings/settings_controller.dart';
import '../settings/settings_view.dart';
import 'vm_card.dart';

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
      syncVMs();
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

    ProxmoxNodeMap map = {};
    final nodes = await _service.listNodes();
    for (final node in nodes) {
      map[node] = await _service.listVms(node.node);
    }
    return map;
  }

  void syncVMs() async {
    nodes = getVms();
    await nodes;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // infinite touch container to turn screen back on
    return Stack(
      children: [
        Scaffold(
          appBar: appbar(context),
          body: bodyBuilder(context),
        ),
        screenActivator(),
      ],
    );
  }

  PreferredSizeWidget? appbar(BuildContext context) {
    return AppBar(
      title: const Text("Proxmox VMs"),
      actions: [
        IconButton(
          icon: const Icon(Icons.nightlight),
          onPressed: () {
            toggleScreen();
          },
        ),
        IconButton(
          icon: const Icon(Icons.sync),
          onPressed: () {
            syncVMs();
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
                pm_service: _service,
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
