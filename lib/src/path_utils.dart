import 'package:path/path.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';

///
/// checking recursively the parent
///
Future<String?> pathFindTopLevelDirPath(
  String path, {
  required FutureOr<bool> Function(String path) pathIsTopLevel,
}) async {
  path = normalize(absolute(path));
  String parent;
  while (true) {
    if (FileSystemEntity.isDirectorySync(path)) {
      if (await pathIsTopLevel(path)) {
        return path;
      }
    }
    parent = dirname(path);
    if (parent == path) {
      break;
    }
    path = parent;
  }
  return null;
}
