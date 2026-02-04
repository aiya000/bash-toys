#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`date-diff-seconds --help` should show help message' {
  run date-diff-seconds --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^date-diff-seconds - '
  expects "${lines[1]}" to_equal 'Usage:'
}

@test '`date-diff-seconds -h` should show help message' {
  run date-diff-seconds -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^date-diff-seconds - '
}

@test '`date-diff-seconds` with no arguments should show error' {
  run date-diff-seconds
  expects "$status" to_be 1
  expects "$output" to_equal 'Error: TIME1 and TIME2 arguments are required'
}
