import 'dart:io';

const _off = "1";
const _on = "0";

Future<void> toggleScreen() async {
  if (await isScreenOff()) {
    turnOncreen();
  } else {
    turnOffScreen();
  }
}

Future<void> turnOffScreen() async {
  await setBlFile(_off);
}

Future<void> turnOncreen() async {
  await setBlFile(_on);
}

File blFile() {
  return File("/sys/class/backlight/10-0045/bl_power");
}

Future<bool> isScreenOff() async {
  final status = await blFile().readAsString();
  if (status.startsWith(_on)) return false;
  return true;
}

Future<void> setBlFile(String content) async {
  await blFile().writeAsString(content);
}
