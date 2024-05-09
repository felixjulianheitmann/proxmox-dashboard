import 'package:flutter/material.dart';
import 'package:pi_dashboard/src/proxmox_lister/proxomx_vm.dart';

class RunningIndicator extends StatelessWidget {
  const RunningIndicator({
    super.key,
    this.isRunning = false,
  });
  final bool isRunning;

  @override
  Widget build(BuildContext ctx) {
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
  ProxmoxVmCard({
    super.key,
    this.vm = const ProxmoxVM(),
  });

  final ProxmoxVM vm;

  @override
  Widget build(_) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.dns),
            title: Row(
              children: [
                Text(vm.name),
                const Spacer(),
                RunningIndicator(isRunning: vm.isRunning),
              ]
            ),
            subtitle: Row(
              children: [
                Text("ID: ${vm.id.toString()}"),
                const Spacer(),
                TextButton(onPressed: () => {}, child: const Icon(Icons.power_settings_new)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}