@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_io_utils/dev_utils.dart';

void main() => defineTests(true);

void defineTests([bool disableOutput = true]) {
  //useVMConfiguration();
  group('dev_utils', () {
    setUp(() {
      if (disableOutput) {
        debugDevOutEnabled = false;
        debugDevErrEnabled = false;
      }
    });
    tearDown(() {
      if (disableOutput) {
        debugDevOutEnabled = true;
        debugDevErrEnabled = true;
      }
    });

    test('devOut', () {
      debugDevOut('dev print message');
    });
    test('devErr', () {
      debugDevErr('from test not supported');
    });
  });
}
