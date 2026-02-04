#!/usr/bin/env bats

# shellcheck disable=SC2016

# shellcheck disable=SC1091
source ./source-all.sh

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`cd-to-node-root --help` should show help message' {
  run cd-to-node-root --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^cd-to-node-root - '
}

@test '`cd-to-node-root -h` should show help message' {
  run cd-to-node-root -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^cd-to-node-root - '
}
