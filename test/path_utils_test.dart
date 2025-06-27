@TestOn('vm')
library;

import 'package:path/path.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';
import 'package:tekartik_io_utils/path_utils.dart';
import 'package:test/test.dart';

void main() {
  group('path_utils', () {
    test('pathFindTopLevelDirPath', () async {
      var projectDir = normalize(absolute('.'));
      expect(
        await pathFindTopLevelDirPath(
          'test',
          pathIsTopLevel: (path) =>
              File(join(path, 'pubspec.yaml')).existsSync(),
        ),
        projectDir,
      );
      expect(
        await pathFindTopLevelDirPath(
          '.',
          pathIsTopLevel: (path) =>
              File(join(path, 'pubspec.yaml')).existsSync(),
        ),
        projectDir,
      );
      expect(
        await pathFindTopLevelDirPath(
          'test',
          pathIsTopLevel: (path) =>
              // ignore: avoid_slow_async_io
              File(join(path, 'pubspec.yaml')).exists(),
        ),
        projectDir,
      );
      expect(
        await pathFindTopLevelDirPath(
          'test',
          pathIsTopLevel: (path) =>
              File(join(path, 'path_utils_test.dart')).existsSync(),
        ),
        join(projectDir, 'test'),
      );
    });
  });
}
