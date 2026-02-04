#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`vim-configure-macos --help` should show help message' {
  run vim-configure-macos --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^vim-configure-macos - '
}

@test '`vim-configure-macos -h` should show help message' {
  run vim-configure-macos -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^vim-configure-macos - '
}
