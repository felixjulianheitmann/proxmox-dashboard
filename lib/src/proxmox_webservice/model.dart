import 'dart:ffi';

typedef ProxmoxNodeMap = Map<ProxmoxNode, List<ProxmoxVm>>;

class ProxmoxNode {
  final String node;
  final String status;
  final double? cpu;
  final String? level;
  final int? maxcpu;
  final int? maxmem;
  final int? mem;
  final String? sslFingerprint;
  final int? uptime;
  final String? id;
  final String? type;
  final int? disk;

  ProxmoxNode({
    required this.node,
    required this.status,
    this.cpu,
    this.level,
    this.maxcpu,
    this.maxmem,
    this.mem,
    this.sslFingerprint,
    this.uptime,
    this.id,
    this.type,
    this.disk,
  });

  factory ProxmoxNode.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'node': String node,
        'status': String status,
        'cpu': double? cpu,
        'level': String? level,
        'maxcpu': int? maxcpu,
        'maxmem': int? maxmem,
        'mem': int? mem,
        'ssl_fingerprint': String? sslFingerprint,
        'uptime': int? uptime,
        'id': String? id,
        'type': String? type,
        'disk': int? disk,
      } =>
        ProxmoxNode(
          node: node,
          status: status,
          cpu: cpu,
          level: level,
          maxcpu: maxcpu,
          maxmem: maxmem,
          mem: mem,
          sslFingerprint: sslFingerprint,
          uptime: uptime,
          id: id,
          type: type,
          disk: disk,
        ),
      _ => throw FormatException(
          "failed to parse proxmox node into object: $json"),
    };
  }
}

class ProxmoxVm {
  final String status;
  final num vmid;
  final num? cpus;
  final num? mem;
  final String? name;
  final num? diskwrite;
  final num? netout;
  final num? uptime;
  final num? cpu;
  final num? maxdisk;
  final num? netin;
  final num? diskread;
  final num? disk;
  final num? maxmem;

  ProxmoxVm({
    required this.status,
    required this.vmid,
    this.cpus,
    this.mem,
    this.name,
    this.diskwrite,
    this.netout,
    this.uptime,
    this.cpu,
    this.maxdisk,
    this.netin,
    this.diskread,
    this.disk,
    this.maxmem,
  });

  factory ProxmoxVm.fromJson(Map<String, dynamic> json) {
    return ProxmoxVm(
      status: json['status'],
      vmid: json['vmid'],
      cpus: json['cpus'],
      mem: json['mem'],
      name: json['name'],
      diskwrite: json['diskwrite'],
      netout: json['netout'],
      uptime: json['uptime'],
      cpu: json['cpu'],
      maxdisk: json['maxdisk'],
      netin: json['netin'],
      diskread: json['diskread'],
      disk: json['disk'],
      maxmem: json['maxmem'],
    );
    return switch (json) {
      {
        'status': String status,
        'vmid': num vmid,
        'cpus': num? cpus,
        'mem': num? mem,
        'name': String? name,
        'diskwrite': num? diskwrite,
        'netout': num? netout,
        'uptime': num? uptime,
        'cpu': num? cpu,
        'maxdisk': num? maxdisk,
        'netin': num? netin,
        'diskread': num? diskread,
        'disk': num? disk,
        'maxmem': num? maxmem,
      } =>
        ProxmoxVm(
          status: status,
          vmid: vmid,
          cpus: cpus,
          mem: mem,
          name: name,
          diskwrite: diskwrite,
          netout: netout,
          uptime: uptime,
          cpu: cpu,
          maxdisk: maxdisk,
          netin: netin,
          diskread: diskread,
          disk: disk,
          maxmem: maxmem,
        ),
      _ => throw FormatException(
          "failed to parse proxmox node into object: $json"),
    };
  }
}
