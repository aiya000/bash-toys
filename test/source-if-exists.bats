#!/usr/bin/env bats

# shellcheck disable=SC2016

# shellcheck disable=SC1091
source ./source-all.sh

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`source-if-exists --help` should show help message' {
  run source-if-exists --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^source-if-exists - '
}

@test '`source-if-exists -h` should show help message' {
  run source-if-exists -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^source-if-exists - '
}
