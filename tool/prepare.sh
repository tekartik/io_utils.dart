#!/bin/bash

# Fast fail the script on failures.
set -e

dartfmt -w .
dartanalyzer --fatal-warnings .
