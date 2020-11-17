@TestOn('vm')
library tekartik_io_utils.directory_utils_test;

import 'package:dev_test/test.dart';
import 'package:tekartik_io_utils/directory_utils.dart';

void main() {
  //useVMConfiguration();
  group('directory_utils', () {
    test('userDataDirectory', () async {
      /*
      if (Platform.isLinux || Platform.isMacOS) {
        expect(userDirectory, (await run('pwd', [], workingDirectory: userDirectory)).stdout as String);
      }
      devPrint('userDirectory ${userDirectory}');
      devPrint('userDirectory ${userDataDirectory}');
      */
      // userDirectory;
      // userDataDirectory;
    });

    test('dirSize', () async {
      final size =
          await dirSize('lib') + await dirSize('test') + await dirSize('tool');
      // devPrint('size $size');
      // allow for changes for some time
      expect(size, greaterThan(5000));
      expect(size, lessThan(10000));
    });
  });
}
