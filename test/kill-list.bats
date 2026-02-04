#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`kill-list --help` should show help message' {
  run kill-list --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^kill-list - '
}

@test '`kill-list -h` should show help message' {
  run kill-list -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^kill-list - '
}
