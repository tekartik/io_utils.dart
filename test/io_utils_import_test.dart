@TestOn('vm')
library;

import 'package:dev_test/test.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';

// Simply test that it exports well
void main() {
  group('io_utils_import', () {
    test('sleep', () async {
      await sleep(1);
    });
  });
}
