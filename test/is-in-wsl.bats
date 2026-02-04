#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`is-in-wsl --help` should show help message' {
  run is-in-wsl --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^is-in-wsl - '
}

@test '`is-in-wsl -h` should show help message' {
  run is-in-wsl -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^is-in-wsl - '
}
