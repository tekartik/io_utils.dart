@TestOn("vm")
import 'package:tekartik_io_utils/io_utils_import.dart';
import 'package:dev_test/test.dart';

// Simply test that it exports well
void main() {
  group('io_utils_import', () {
    test('sleep', () async {
      await sleep(1);
    });
  });
}
