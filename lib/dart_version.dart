import 'dart:io';

import 'package:pub_semver/pub_semver.dart';

Version get dartVersion {
  final version = Platform.version.split(' ').first;
  return Version.parse(version);
}
