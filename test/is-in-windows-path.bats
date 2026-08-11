#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`is-in-windows-path --help` should show help message' {
  run is-in-windows-path --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^is-in-windows-path - '
}

@test '`is-in-windows-path -h` should show help message' {
  run is-in-windows-path -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^is-in-windows-path - '
}
