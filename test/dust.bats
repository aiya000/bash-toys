#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`dust --help` should show help message' {
  run dust --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^dust - '
  expects "${lines[1]}" to_equal 'Usage:'
}

@test '`dust -h` should show help message' {
  run dust -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^dust - '
}

@test '`dust` with no arguments should do nothing' {
  run dust
  expects "$status" to_be 0
  expects "$output" to_equal ''  # No error message, just silently succeed
}
