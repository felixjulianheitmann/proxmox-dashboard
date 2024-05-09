import 'dart:io';

import 'package:logger/logger.dart';

class Log {
  static final Log _instance = Log._internal();

  static Logger _logger = Logger();

  factory Log() {
    final logFile = File("/var/log/proxmox-dash/proxmox-dash.log");
    if (!logFile.existsSync()) {
      logFile.createSync(recursive: true);
    }

    _logger = Logger(
      output: FileOutput(file: logFile),
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
