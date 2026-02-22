#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`clamdscan-full --help` should show help message' {
  run clamdscan-full --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^clamdscan-full - '
  expects "${lines[1]}" to_equal 'Usage:'
}

@test '`clamdscan-full -h` should show help message' {
  run clamdscan-full -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^clamdscan-full - '
}

@test 'clamdscan-full with no arguments should use root directory' {
  function fdfind() { echo "/mock-dir"; }
  function clamdscan() { echo "scanned: $*"; }
  export -f fdfind clamdscan

  run clamdscan-full
  expects "$status" to_be 0
  expects "$output" to_contain 'scanned:'
}
