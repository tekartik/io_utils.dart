import 'dart:async';

import 'dart:io';

import 'package:process_run/process_run.dart';

bool get supportsFilePermission {
  return !Platform.isWindows;
}

// 1001001 (bin)
const int executablePermissionModeMask = 0x49;

bool hasExecutablePermissionSync(String path) {
  var stat = File(path).statSync();
  //devPrint(stat.mode.toRadixString(16));
  // We want bit 0 3 or 6
  // 0x1
  // 0x8
  // 0x4
  return stat.mode & executablePermissionModeMask != 0;
}

Future<bool> hasExecutablePermission(String path) async {
  return hasExecutablePermissionSync(path);
}

Future setExecutablePermission(String path) async {
  if (supportsFilePermission) {
    // await devRun('ls', ['-l', path]);
    await run('chmod', ['+x', path]);
    // await devRun('ls', ['-l', path]);
  }
}
