import 'dart:io';

import 'package:test/test.dart';
import 'package:tekartik_io_utils/process_cmd_utils.dart';

void main() {
  group('process_cmd_utils', () {
    test('dart_cmd', () async {
      ProcessResult result = await runCmd(ProcessCmd('dart', ['--version']));
      expect(result.stderr.toLowerCase(), contains("dart"));
      expect(result.stderr.toLowerCase(), contains("version"));
      // Dart VM version: 2.2.1-dev.0.0 (Wed Feb 27 18:37:05 2019 +0100) on "linux_x64"
    });
  });
}
