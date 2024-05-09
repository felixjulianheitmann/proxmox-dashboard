
class ProxmoxVM {
  const ProxmoxVM({
    this.id = 0,
    this.name = "",
    this.isRunning = true,
  });

  final int id;
  final String name;
  final bool isRunning;
}