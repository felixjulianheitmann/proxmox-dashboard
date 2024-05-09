import 'dart:io';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

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

class IdleTurnOff extends StatefulWidget {
  const IdleTurnOff({
    super.key,
    required this.child,
    required this.timeout,
    required this.onExpire,
  });

  final Widget child;
  final Duration timeout;
  final Function() onExpire;

  @override
  State<IdleTurnOff> createState() => _IdleTurnOffState();
}

class _IdleTurnOffState extends State<IdleTurnOff> {
  late RestartableTimer _timer;

  @override
  void initState() {
    super.initState();
    _timer = RestartableTimer(widget.timeout, widget.onExpire);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(
        onKeyEvent: (_1, _2) {
          _timer.reset();
          return KeyEventResult.ignored;
        },
      ),
      child: Listener(
        child: widget.child,
        onPointerDown: (_) => _timer.reset(),
      ),
    );
  }
}
