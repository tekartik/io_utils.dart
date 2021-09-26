import 'package:pub_semver/pub_semver.dart';
import 'package:tekartik_io_utils/process_cmd_utils.dart';
import 'package:test/test.dart';

void main() {
  group('process_cmd_utils', () {
    test('dart_cmd', () async {
      final result = await runCmd(ProcessCmd('dart', ['--version']));
      if (dartVersion >= Version(2, 15, 0, pre: '0')) {
        expect(result.stdout.toString().toLowerCase(), contains('dart'));
        expect(result.stdout.toString().toLowerCase(), contains('version'));
      } else {
        expect(result.stderr.toString().toLowerCase(), contains('dart'));
        expect(result.stderr.toString().toLowerCase(), contains('version'));
      }
      // Dart VM version: 2.2.1-dev.0.0 (Wed Feb 27 18:37:05 2019 +0100) on 'linux_x64'
    });
  });
}
