import 'package:process_run/shell.dart';
import 'package:pub_semver/pub_semver.dart';

Version parsePlatformVersion(String text) {
  return Version.parse(text.split(' ').first);
}

Future main() async {
  var shell = Shell();

  await shell.run('''
  dartanalyzer --fatal-warnings --fatal-infos .
  dartfmt -n --set-exit-if-changed .
  pub run build_runner test
  pub run test

  ''');
}
