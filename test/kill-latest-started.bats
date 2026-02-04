#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`kill-latest-started --help` should show help message' {
  run kill-latest-started --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^kill-latest-started - '
}

@test '`kill-latest-started -h` should show help message' {
  run kill-latest-started -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^kill-latest-started - '
}
