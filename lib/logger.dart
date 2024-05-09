import 'dart:io';

import 'package:logger/logger.dart';

class Log {
  static final Log _instance = Log._internal();

  static Logger _logger = Logger();

  factory Log() {
    _logger = Logger(
      output: MultiOutput([
        ConsoleOutput(),
        FileOutput(file: File("/var/log/proxmox-dash/proxmox-dash.log")),
      ]),
      level: Level.info,
    );
    return _instance;
  }

  void debug(m) => _logger.d(m);
  void info(m) => _logger.i(m);
  void warn(m) => _logger.w(m);
  void error(m) => _logger.e(m);

  Log._internal();
}
