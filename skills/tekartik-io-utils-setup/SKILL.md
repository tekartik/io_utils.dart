---
name: tekartik-io-utils-setup
description: >-
  Use when writing Dart VM / CLI code with package:tekartik_io_utils: the
  io_utils_import.dart one-stop import (dart:io plus tekartik_common_utils,
  async sleep, devPrint), dirSize and createEmptyDir from directory_utils.dart,
  supportsFilePermission / hasExecutablePermissionSync /
  setExecutablePermission / executablePermissionModeMask from file_utils.dart,
  pathFindTopLevelDirPath from path_utils.dart, dartVersion from
  dart_version.dart, the verbose runCmd(ProcessCmd) wrapper of
  process_cmd_utils.dart, and debugDevOut / debugDevErr / debugDevOutEnabled
  from dev_utils.dart.
---

# tekartik_io_utils: small dart:io helpers

`tekartik_io_utils` is a thin, VM-only utility package: directory size, empty
directory creation, executable file permissions, a project-root finder, the
running Dart `Version`, and a verbose `runCmd` wrapper over `process_run`.
Every library imports `dart:io`, so nothing here compiles for the web.

## Guidelines

* Dependency (git only, not published on pub.dev):
  ```yaml
  dependencies:
    tekartik_io_utils:
      git:
        url: https://github.com/tekartik/io_utils.dart
      version: '>=0.8.0'
  ```
  The README shows an additional `ref: dart3a` pinning; only use it if you must
  stay on that legacy branch, `master` is the current 0.8.x code.
* Import only the library you need; there is no single umbrella library:
  * `package:tekartik_io_utils/io_utils_import.dart` — re-exports `dart:io`
    (hiding its blocking `sleep`), `package:tekartik_common_utils/common_utils_import.dart`
    (`dart:async`, `dart:convert`, `devPrint`, the async `sleep(int ms)`,
    `Version` helpers, `synchronized`) and this package's `dev_utils.dart`.
    Use it instead of `import 'dart:io'` in an app of this ecosystem, and do
    not import `dart:io` beside it (duplicate names).
  * `directory_utils.dart` — `Future<int> dirSize(String path)`,
    `Future createEmptyDir(String path)`.
  * `file_utils.dart` — `bool get supportsFilePermission`,
    `bool hasExecutablePermissionSync(String path)`,
    `Future<bool> hasExecutablePermission(String path)`,
    `Future setExecutablePermission(String path)`,
    `const int executablePermissionModeMask` (`0x49`).
  * `path_utils.dart` — `Future<String?> pathFindTopLevelDirPath(String path,
    {required FutureOr<bool> Function(String path) pathIsTopLevel})`.
  * `dart_version.dart` — `Version get dartVersion` (`package:pub_semver`).
  * `process_cmd_utils.dart` — the verbose `runCmd`, plus a re-export of
    `package:process_run/cmd_run.dart` (`ProcessCmd`, `runExecutableArguments`,
    `dartExecutable`, ...) with `process_run`'s own `runCmd` hidden.
  * `dev_utils.dart` — `debugDevOut(Object)`, `debugDevErr(Object)` and the
    setters `debugDevOutEnabled`, `debugDevErrEnabled`. `devOut`/`devErr` are
    deprecated; so are `envVars`, `userDirectory` and `userDataDirectory` in
    `directory_utils.dart` (use `package:process_run`'s environment/user paths
    instead).
* `dart_version.dart` and `process_cmd_utils.dart` both provide a `dartVersion`
  (the second one comes from `process_run`'s `dartbin`). Importing both in the
  same file is an ambiguous import: keep one, or add `show`/`as`.
* `runCmd(ProcessCmd cmd, {bool? dryRun, bool? oneByOne})` is a CLI helper, not
  a library function: it prints `$ <cmd>` (and `[workingDirectory]`), dumps
  stdout/stderr, and calls `exit(result.exitCode)` when the command fails.
  Never call it from a test, a server or any long-lived process; use
  `runExecutableArguments` or a `Shell` from `process_run` there.
  `dryRun: true` only prints the command and returns an exit code 0
  `ProcessResult`; `oneByOne: true` streams the output live instead of
  buffering it.
* `createEmptyDir(path)` deletes the directory recursively before recreating
  it. Point it at a scratch path (`.dart_tool/<pkg>/...`), never at a source
  directory.
* `dirSize(path)` sums file sizes recursively in bytes, skipping symbolic
  links; it throws if the directory does not exist.
* `setExecutablePermission` shells out to `chmod +x` and silently does nothing
  on Windows (`supportsFilePermission` is `false` there); guard assertions with
  `supportsFilePermission`. `hasExecutablePermissionSync` tests
  `stat.mode & executablePermissionModeMask != 0` (any of user/group/other).
* `pathFindTopLevelDirPath` walks from the absolute, normalized `path` up to
  the filesystem root and returns the first directory for which
  `pathIsTopLevel` is true (`null` if none). The callback may be sync or async
  (`FutureOr<bool>`); the start path itself is tested when it is a directory.
* Testing: mark files `@TestOn('vm')`. Silence the dev output with
  `debugDevOutEnabled = false;` / `debugDevErrEnabled = false;` in `setUp` and
  restore it in `tearDown`.

## Examples

### One-stop import for a VM app

```dart
import 'package:path/path.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';

Future<void> main() async {
  // dart:io through the re-export
  var file = File(join('.dart_tool', 'demo', 'out.txt'));
  await file.parent.create(recursive: true);
  await file.writeAsString('hello');

  // async sleep (dart:io's blocking sleep is hidden) + devPrint
  await sleep(100);
  devPrint('wrote ${file.path} (${Platform.operatingSystem})');
}
```

### Scratch directory and size

```dart
import 'package:path/path.dart';
import 'package:tekartik_io_utils/directory_utils.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';

Future<void> main() async {
  var dir = join('.dart_tool', 'my_pkg', 'work');
  // Deletes the directory if it exists, then recreates it empty.
  await createEmptyDir(dir);
  await File(join(dir, 'data.bin')).writeAsBytes(List.filled(1024, 0));
  print('${await dirSize(dir)} bytes'); // 1024 bytes
}
```

### Find the package root from any path

```dart
import 'package:path/path.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';
import 'package:tekartik_io_utils/path_utils.dart';

Future<String> findPackageRoot([String from = '.']) async {
  var path = await pathFindTopLevelDirPath(
    from,
    pathIsTopLevel: (path) => File(join(path, 'pubspec.yaml')).existsSync(),
  );
  if (path == null) {
    throw StateError('no pubspec.yaml above ${absolute(from)}');
  }
  return path;
}
```

### Make a generated script executable

```dart
import 'package:path/path.dart';
import 'package:tekartik_io_utils/file_utils.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';

Future<void> writeScript(String dir) async {
  var path = join(dir, 'run.sh');
  await File(path).writeAsString('#!/bin/sh\necho hello\n', flush: true);
  await setExecutablePermission(path); // no-op on Windows
  if (supportsFilePermission) {
    print(hasExecutablePermissionSync(path)); // true
    print(File(path).statSync().mode & executablePermissionModeMask != 0);
  }
}
```

### Command line tool running sub commands

```dart
import 'package:tekartik_io_utils/process_cmd_utils.dart';

Future<void> main(List<String> args) async {
  var dryRun = args.contains('--dry-run');
  // Prints `$ dart --version`, exits with the child exit code on failure.
  await runCmd(ProcessCmd('dart', ['--version']), dryRun: dryRun);
  await runCmd(
    ProcessCmd('dart', ['test'])..workingDirectory = 'packages/app',
    dryRun: dryRun,
    oneByOne: true, // live output
  );
  print('dart $dartVersion'); // from process_run's dartbin re-export
}
```

### Quiet dev output in a test

```dart
@TestOn('vm')
library;

import 'package:tekartik_io_utils/dev_utils.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    debugDevOutEnabled = false;
    debugDevErrEnabled = false;
  });
  tearDown(() {
    debugDevOutEnabled = true;
    debugDevErrEnabled = true;
  });

  test('no output', () {
    debugDevOut('swallowed');
    debugDevErr('swallowed');
  });
}
```

## Common mistakes

* Importing `dart:io` next to `io_utils_import.dart`, or expecting `sleep` to
  be the blocking `dart:io` one (it is the async `sleep(int milliseconds)`).
* Importing both `dart_version.dart` and `process_cmd_utils.dart` in one file
  (`dartVersion` is ambiguous).
* Calling `runCmd` in a test or a server: a failing command kills the process
  with `exit()`.
* Using `createEmptyDir` on a directory that holds real data.
* Relying on `setExecutablePermission` on Windows, or asserting on file modes
  without checking `supportsFilePermission`.
* Using the deprecated `userDirectory` / `userDataDirectory` / `envVars` /
  `devOut` / `devErr` in new code.
* Importing any of these libraries from web or Flutter web code (`dart:io`).
