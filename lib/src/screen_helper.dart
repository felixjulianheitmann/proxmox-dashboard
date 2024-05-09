import 'dart:io';
import 'package:flutter/material.dart';

const _off = "1";
const _on = "0";

bool _screenStatus = true;

Future<void> toggleScreen() async {
  if (_screenStatus) {
    turnOffScreen();
  } else {
    turnOncreen();
  }
}

Future<void> turnOffScreen() async {
  await setBlFile(_off);
  _screenStatus = false;
}

Future<void> turnOncreen() async {
  await setBlFile(_on);
  _screenStatus = true;
}

File blFile() {
  return File("/sys/class/backlight/10-0045/bl_power");
}

Future<void> setBlFile(String content) async {
  await blFile().writeAsString(content);
}

Widget screenActivator() {
  // only show when screen is dark
  return Visibility(
    visible: !_screenStatus,
    child: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Material(
        color: Colors.black,
        child: InkWell(onTap: () async {
          await turnOncreen();
        }),
      ),
    ),
  );
}
