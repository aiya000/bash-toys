#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`peco-reverse --help` should show help message' {
  run peco-reverse --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^peco-reverse - '
}

@test '`peco-reverse -h` should show help message' {
  run peco-reverse -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^peco-reverse - '
}
