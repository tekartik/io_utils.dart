@TestOn('vm')
library;

import 'package:dev_test/test.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:tekartik_io_utils/dart_version.dart';

void main() {
  //useVMConfiguration();
  group('dart_version', () {
    test('dartVersion', () {
      expect(dartVersion, greaterThanOrEqualTo(Version(1, 24, 3)));
    });
  });
}
