import 'package:flutter/material.dart';
import '../settings/settings_view.dart';
import 'vm_card.dart';
import 'proxomx_vm.dart';

class ProxmoxListerView extends StatelessWidget {
  ProxmoxListerView({
    super.key,
    this.vms = const [ProxmoxVM(id: 1, name: "template")],
  });

  static const routeName = '/proxmox_lister';

  List<ProxmoxVM> vms;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Proxmox VMs"),
          actions: [
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView.builder(
          restorationId: "proxmoxVMLister",
          itemCount: vms.length,
          itemBuilder: (BuildContext ctx, int index) {
            final vm = vms[index];

            return ProxmoxVmCard(vm: vm);
          },
        ));
  }
}
