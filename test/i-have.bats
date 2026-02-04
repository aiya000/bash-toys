#!/usr/bin/env bats

# shellcheck disable=SC2016

# shellcheck disable=SC1091
source ./source-all.sh

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`i-have --help` should show help message' {
  run i-have --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^i-have - '
}

@test '`i-have -h` should show help message' {
  run i-have -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^i-have - '
}
