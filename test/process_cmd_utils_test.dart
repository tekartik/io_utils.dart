import 'package:tekartik_io_utils/process_cmd_utils.dart';
import 'package:test/test.dart';

void main() {
  group('process_cmd_utils', () {
    test('dart_cmd', () async {
      final result = await runCmd(ProcessCmd('dart', ['--version']));
      // Since Dart 2.15, the version is written to stdout.
      expect(result.stdout.toString().toLowerCase(), contains('dart'));
      expect(result.stdout.toString().toLowerCase(), contains('version'));
      // Dart SDK version: 3.12.0 (stable) (...) on "linux_x64"
    });
  });
}
