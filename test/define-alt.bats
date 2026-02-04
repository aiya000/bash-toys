#!/usr/bin/env bats

# shellcheck disable=SC2016

# shellcheck disable=SC1091
source ./source-all.sh

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`define-alt --help` should show help message' {
  run define-alt --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^define-alt - '
}

@test '`define-alt -h` should show help message' {
  run define-alt -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^define-alt - '
}
