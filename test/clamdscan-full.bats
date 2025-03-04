#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`clamdscan-full --help` should show help message' {
  run clamdscan-full --help
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "clamdscan-full - Full system virus scan using ClamAV" ]
  [ "${lines[1]}" = "" ]
  [ "${lines[2]}" = "Usage:" ]
}

@test '`clamdscan-full` with no arguments should use root directory' {
  function fdfind() { echo "mocked-fdfind $*"; }
  function clamdscan() { echo "mocked-clamdscan $*"; }
  export -f fdfind clamdscan

  run clamdscan-full
  [ "$status" -eq 0 ]
  [[ ${lines[0]} == *"scale=5; (1 / 1) * 100"* ]]  # Progress calculation
}