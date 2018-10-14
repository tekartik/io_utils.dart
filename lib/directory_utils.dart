import 'dart:async';
import 'dart:io' show Directory, FileSystemEntity, Platform;

import 'package:path/path.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';

Map<String, String> envVars = Platform.environment;

String get userDirectory {
  //String os = Platform.operatingSystem;
  String home = "~";

  if (Platform.isMacOS) {
    home = envVars['HOME'];
  } else if (Platform.isLinux) {
    home = envVars['HOME'];
  } else if (Platform.isWindows) {
    home = envVars['UserProfile'];
  }
  return home;
}

String get userDataDirectory {
  String dataDir = ".config";
  if (Platform.isMacOS) {
    dataDir = join("Library", "Application Support");
  } else if (Platform.isWindows) {
    dataDir = envVars['LOCALAPPDATA'];
    return dataDir;
  }
  return join(userDirectory, dataDir);
}

Future<int> dirSize(String path) async {
  int size = 0;
  List<Future> futures = [];

  Future _handle(FileSystemEntity fse) async {
    int fseSize = 0;
    //devPrint("_handle ${fse}");
    // skip link
    if (!await FileSystemEntity.isLink(fse.path)) {
      if (await FileSystemEntity.isFile(fse.path)) {
        fseSize = (await fse.stat()).size;
      } else if (await FileSystemEntity.isDirectory(fse.path)) {
        fseSize = await dirSize(fse.path);
      }
    }
    size += fseSize;
    //devPrint("$size ${fseSize} f ${fse}");
  }

  await Directory(path)
      .list(recursive: false, followLinks: false)
      .listen((FileSystemEntity fse) {
    //devPrint(FileSystemEntity.type(fse.path));
    futures.add(_handle(fse));
  }).asFuture();

  await Future.wait(futures);

  return size;
}

Future createEmptyDir(String path) async {
  var dir = Directory(path);
  try {
    await dir.deleteSync(recursive: true);
  } catch (_) {}
  await dir.create(recursive: true);
}
