#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings \
  lib/io_utils_import.dart \
  lib/dev_utils.dart \

pub run test -p vm