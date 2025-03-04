import 'package:flutter/material.dart';
import 'package:pi_dashboard/src/proxmox_webservice/model.dart';
import 'package:pi_dashboard/src/proxmox_webservice/service.dart';

class RunningIndicator extends StatelessWidget {
  const RunningIndicator({
    super.key,
    this.isRunning = false,
  });
  final bool isRunning;

  @override
  Widget build(context) {
    return Text(
      isRunning ? "RUNNING" : "STOPPED",
      style: TextStyle(
        color: isRunning ? Colors.lightGreen[800] : Colors.blueGrey[600],
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ProxmoxVmCard extends StatelessWidget {
  const ProxmoxVmCard({
    super.key,
    required this.node,
    required this.vm,
    required this.pmService,
  });

  final ProxmoxNode node;
  final ProxmoxVm vm;
  final ProxmoxWebService pmService;

  @override
  Widget build(context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.dns),
            title: Row(
              children: [
              Text(vm.name ?? ""),
                const Spacer(),
              RunningIndicator(isRunning: vm.status == "running"),
              ]
            ),
            subtitle: Row(
              children: [
                Text("ID: ${vm.vmid.toString()}"),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.power_settings_new),
                  onPressed: () => pmService.toggleVm(node, vm),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}