import 'dart:async';
import 'dart:io';

import 'package:process_run/cmd_run.dart' as cmd_run;
import 'package:process_run/cmd_run.dart' hide runCmd;

export 'package:process_run/cmd_run.dart' hide runCmd;

/// Verbose run of command
Future<ProcessResult> runCmd(
  ProcessCmd cmd, {
  bool? dryRun,
  bool? oneByOne,
}) async {
  void writeWorkingDirectory() {
    if (cmd.workingDirectory != '.' && cmd.workingDirectory != null) {
      stdout.writeln('[${cmd.workingDirectory}]');
    }
  }

  if (dryRun == true) {
    writeWorkingDirectory();
    stdout.writeln('\$ $cmd');
    return ProcessResult(0, 0, null, null);
  }
  ProcessResult result;
  if (oneByOne == true) {
    writeWorkingDirectory();
    result = await cmd_run.runCmd(cmd, verbose: true);
    if (result.exitCode != 0) {
      exit(result.exitCode);
    }
  } else {
    result = await cmd_run.runCmd(cmd);
    writeWorkingDirectory();
    stdout.writeln('\$ $cmd');
    stdout.write(result.stdout);
    stderr.write(result.stderr);
    if (result.exitCode != 0) {
      exit(result.exitCode);
    }
  }
  return result;
}
