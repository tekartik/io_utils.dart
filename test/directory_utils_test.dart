@TestOn('vm')
library tekartik_io_utils.directory_utils_test;

import 'package:tekartik_io_utils/directory_utils.dart';
import 'package:test/test.dart';

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
      //print('size $size');
      // 9926 on linux, 10310 on windows!
      // allow for changes for some time
      expect(size, greaterThan(9000));
      expect(size, lessThan(11000));
    });
  });
}
