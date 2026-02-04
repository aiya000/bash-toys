#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`slice --help` should show help message' {
  run slice --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^slice - '
}

@test '`slice -h` should show help message' {
  run slice -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^slice - '
}
