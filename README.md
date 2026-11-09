# tekartik_io_utils

Small `dart:io` helpers for Dart VM tools (CLI, build scripts, tests):
directory size, empty scratch directory, executable permission, project root
finder, the running Dart version and a verbose command runner. Dart VM only
(every library imports `dart:io`, nothing compiles for the web).

## Getting started

The package is not on pub.dev, add it as a git dependency (default branch):

```yaml
dependencies:
  tekartik_io_utils:
    git:
      url: https://github.com/tekartik/io_utils.dart
```

```dart
import 'package:path/path.dart';
import 'package:tekartik_io_utils/directory_utils.dart';
import 'package:tekartik_io_utils/file_utils.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';
import 'package:tekartik_io_utils/path_utils.dart';

Future<void> main() async {
  // A scratch directory, emptied (deleted then created again).
  var dir = join('.dart_tool', 'my_tool', 'work');
  await createEmptyDir(dir);
  var script = File(join(dir, 'run.sh'));
  await script.writeAsString('#!/bin/sh\necho hello\n');
  await setExecutablePermission(script.path); // chmod +x, nothing on Windows
  print(await dirSize(dir)); // 21 (bytes, links skipped)

  // The closest parent holding a pubspec.yaml.
  var packageDir = await pathFindTopLevelDirPath(
    dir,
    pathIsTopLevel: (path) => File(join(path, 'pubspec.yaml')).existsSync(),
  );
  print(packageDir);
}
```

## Libraries

* `io_utils_import.dart`: `dart:io` (without its blocking `sleep`) plus
  `tekartik_common_utils` (async `sleep(ms)`, `devPrint`...).
* `directory_utils.dart`: `dirSize`, `createEmptyDir`.
* `file_utils.dart`: `setExecutablePermission`, `hasExecutablePermission(Sync)`,
  `supportsFilePermission`.
* `path_utils.dart`: `pathFindTopLevelDirPath`.
* `dart_version.dart`: `dartVersion` (the running Dart, a `pub_semver`
  `Version`).
* `process_cmd_utils.dart`: `runCmd(ProcessCmd)`, a verbose runner for
  scripts, plus `package:process_run/cmd_run.dart`.

## Common pitfalls

* `runCmd` calls `exit()` when the command fails: scripts only, never in a
  library, a server or a test. Elsewhere use process_run `Shell` or
  `runExecutableArguments`.
* `setExecutablePermission` ignores a `chmod` failure (a missing file gives no
  error) and does nothing on Windows.
* `dirSize` throws when a directory cannot be listed (missing, no
  permission).
* `dart_version.dart` and `process_cmd_utils.dart` both expose `dartVersion`:
  do not import both in one file.
* `createEmptyDir` deletes the directory first: give it a scratch path.

Agent skill: [skills/tekartik-io-utils-setup](skills/tekartik-io-utils-setup/SKILL.md).
