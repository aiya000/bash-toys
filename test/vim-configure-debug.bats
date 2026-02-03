#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`vim-configure-debug --help` should show help message' {
  run vim-configure-debug --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^vim-configure-debug - '
}

@test '`vim-configure-debug -h` should show help message' {
  run vim-configure-debug -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^vim-configure-debug - '
}
