import 'dart:io' show Platform;

import 'package:path/path.dart';

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
