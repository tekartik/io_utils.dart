import 'dart:io';

import 'package:pub_semver/pub_semver.dart';

Version get dartVersion {
  String version = Platform.version.split(" ").first;
  return new Version.parse(version);
}
