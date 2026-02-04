#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`git-root --help` should show help message' {
  run git-root --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^git-root - '
}

@test '`git-root -h` should show help message' {
  run git-root -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^git-root - '
}
