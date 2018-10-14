@TestOn("vm")
import 'package:dev_test/test.dart';
import 'package:path/path.dart';
import 'package:tekartik_io_utils/directory_utils.dart';
import 'package:tekartik_io_utils/file_utils.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';

void main() {
  group('file_utils', () {
    test('supportsFilePermission', () {
      if (Platform.isWindows) {
        expect(supportsFilePermission, false);
      }
      if (Platform.isMacOS) {
        expect(supportsFilePermission, true);
      }
      if (Platform.isLinux) {
        expect(supportsFilePermission, true);
      }
    });
    test('setExecutablePermission', () async {
      var dir = Directory(join('.dart_tool', 'tekartik_io_utils', 'file_utils',
          'setExecutablePermission'));
      await createEmptyDir(dir.path);

      var file = File(join(dir.path, 'test.bin'));
      await file.writeAsString('test', flush: true);
      await Future.delayed(Duration(milliseconds: 500));
      await setExecutablePermission(file.path);
      if (supportsFilePermission) {
        var stat = await file.stat();
        //devPrint(stat.mode.toRadixString(16));
        expect(stat.mode & 0x19, 0x19);
      }
    });
  });
}
