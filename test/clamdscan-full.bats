#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`clamdscan-full --help` should show help message' {
  run clamdscan-full --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^clamdscan-full - '
  expects "${lines[1]}" to_equal 'Usage:'
}

@test '`clamdscan-full` with no arguments should use root directory' {
  function fdfind() { echo "mocked-fdfind $*"; }
  function clamdscan() { echo "mocked-clamdscan $*"; }
  export -f fdfind clamdscan

  run clamdscan-full
  expects "$status" to_be 0
  expects "${lines[0]}" to_contain 'scale=5; (1 / 1) * 100'  # Progress calculation
}
