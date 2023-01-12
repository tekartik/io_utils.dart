import 'dart:async';
import 'dart:io' show Directory, FileSystemEntity, Platform;

import 'package:path/path.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';

@Deprecated('Do no use see process_run')
Map<String, String> envVars = Platform.environment;

@Deprecated('Do no use')
String get userDirectory {
  //String os = Platform.operatingSystem;
  String? home = '~';

  if (Platform.isMacOS) {
    home = envVars['HOME'];
  } else if (Platform.isLinux) {
    home = envVars['HOME'];
  } else if (Platform.isWindows) {
    home = envVars['UserProfile'];
  }
  return home!;
}

@Deprecated('Do no use see process_run')
String get userDataDirectory {
  String? dataDir = '.config';
  if (Platform.isMacOS) {
    dataDir = join('Library', 'Application Support');
  } else if (Platform.isWindows) {
    dataDir = envVars['LOCALAPPDATA'];
    return dataDir!;
  }
  return join(userDirectory, dataDir);
}

Future<int> dirSize(String path) async {
  var size = 0;
  final futures = <Future>[];

  Future handleFse(FileSystemEntity fse) async {
    var fseSize = 0;
    //devPrint('_handle ${fse}');
    // skip link
    if (!FileSystemEntity.isLinkSync(fse.path)) {
      if (FileSystemEntity.isFileSync(fse.path)) {
        fseSize = (await fse.stat()).size;
      } else if (FileSystemEntity.isDirectorySync(fse.path)) {
        fseSize = await dirSize(fse.path);
      }
    }
    size += fseSize;
    //devPrint('$size ${fseSize} f ${fse}');
  }

  await Directory(path)
      .list(recursive: false, followLinks: false)
      .listen((FileSystemEntity fse) {
    //devPrint(FileSystemEntity.type(fse.path));
    futures.add(handleFse(fse));
  }).asFuture<void>();

  await Future.wait(futures);

  return size;
}

/// Make sure the directory exists and is empty
Future createEmptyDir(String path) async {
  var dir = Directory(path);
  try {
    await dir.delete(recursive: true);
  } catch (_) {}
  await dir.create(recursive: true);
}
