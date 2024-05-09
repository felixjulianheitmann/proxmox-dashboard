import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'model.dart';

class ProxmoxWebService {
  ProxmoxWebService({
    this.hostname = "",
    this.username = "",
    this.password = "",
  });

  final String hostname;
  final String username;
  final String password;

  String? _csrfToken;
  String? _ticket;

  bool _authenticated = false;

  Future<bool> authenticate() async {
    final resp = await http.post(
      Uri.https(
        hostname,
        "/api2/json/access/ticket",
        {
          'username': username,
          'password': password,
        },
      ),
    );

    if (resp.statusCode == 200) {
      final body = convert.jsonDecode(resp.body) as Map<String, dynamic>;
      final data = body["data"] as Map<String, dynamic>;
      _csrfToken = data["CSRFPreventionToken"];
      _ticket = data["ticket"];

      _authenticated = true;
    } else {
      _authenticated = false;
    }

    return _authenticated;
  }

  Future<Map<String, dynamic>?> _doGet(String endpoint, {debug = false}) async {
    if (!_authenticated) return null;
    final resp = await http.get(
        Uri.https(
          hostname,
          endpoint,
        ),
        headers: {
          "CSRFPreventionToken": _csrfToken as String,
          "Cookie": "PVEAuthCookie=$_ticket"
        });
    if (debug) print(resp.body);

    if (resp.statusCode != 200) return null;

    return convert.jsonDecode(resp.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> _doPost(
      String endpoint, Map<String, dynamic> payload,
      {debug = false}) async {
    if (!_authenticated) return null;

    final resp = await http.post(
      Uri.https(
        hostname,
        endpoint,
      ),
      headers: {
        "CSRFPreventionToken": _csrfToken as String,
        "Cookie": "PVEAuthCookie=$_ticket"
      },
      body: payload,
    );
    if (debug) print(resp.body);

    if (resp.statusCode != 200) return null;

    return convert.jsonDecode(resp.body) as Map<String, dynamic>;
  }

  Future<List<ProxmoxNode>> listNodes() async {
    List<ProxmoxNode> nodes = [];

    final resp = await _doGet("/api2/json/nodes");
    if (resp == null) return [];

    for (final nodeJson in resp["data"]) {
      nodes.add(ProxmoxNode.fromJson(nodeJson as Map<String, dynamic>));
    }

    return nodes;
  }

  Future<List<ProxmoxVm>> listVms(String node) async {
    List<ProxmoxVm> vms = [];
    final resp = await _doGet("/api2/json/nodes/$node/qemu");
    if (resp == null) return [];

    for (final vmJson in resp["data"]) {
      vms.add(ProxmoxVm.fromJson(vmJson as Map<String, dynamic>));
    }

    vms.sort((a, b) => a.vmid.compareTo(b.vmid));
    return vms;
  }

  Future<bool> toggleVm(ProxmoxNode node, ProxmoxVm vm) async {
    if (!_authenticated) return false;

    final endpoint =
        "/api2/json/nodes/${node.node}/qemu/${vm.vmid}/status/${vm.status == "running" ? "stop" : "start"}";

    final resp = await _doPost(endpoint, {}, debug: true);
    if (resp == null) return false;

    return true;
  }

}