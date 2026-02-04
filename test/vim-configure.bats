#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`vim-configure --help` should show help message' {
  run vim-configure --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^vim-configure - '
}

@test '`vim-configure -h` should show help message' {
  run vim-configure -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^vim-configure - '
}
