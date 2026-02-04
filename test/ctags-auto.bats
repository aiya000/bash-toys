#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`ctags-auto --help` should show help message' {
  run ctags-auto --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^ctags-auto - '
}

@test '`ctags-auto -h` should show help message' {
  run ctags-auto -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^ctags-auto - '
}
