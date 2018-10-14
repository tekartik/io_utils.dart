import 'dart:async';

import 'dart:io';

import 'package:process_run/process_run.dart';

bool get supportsFilePermission {
  return !Platform.isWindows;
}

Future setExecutablePermission(String path) async {
  if (supportsFilePermission) {
    // await devRun('ls', ['-l', path]);
    await run('chmod', ['+x', path]);
    // await devRun('ls', ['-l', path]);
  }
}
