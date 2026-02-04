#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`notify --help` should show help message' {
  run notify --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^Usage: notify '
}

@test '`notify -h` should show help message' {
  run notify -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^Usage: notify '
}
