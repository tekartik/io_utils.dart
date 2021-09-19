import 'dart:io';

void _devOut(Object object) {
  if (_devOutEnabled) {
    stdout.writeln(object);
  }
}

bool _devOutEnabled = true;
bool _devErrEnabled = true;

@Deprecated('Dev only')
void devOut(Object object) {
  if (_devOutEnabled) {
    _devOut(object);
  }
}

void _devErr(Object object) {
  if (_devErrEnabled) {
    stderr.writeln(object);
  }
}

@Deprecated('Dev only')
void devErr(Object object) {
  if (_devErrEnabled) {
    _devErr(object);
  }
}

// exported for testing
void debugDevOut(Object object) => _devOut(object);
void debugDevErr(Object object) => _devErr(object);
set debugDevOutEnabled(bool enabled) => _devOutEnabled = enabled;
set debugDevErrEnabled(bool enabled) => _devErrEnabled = enabled;
