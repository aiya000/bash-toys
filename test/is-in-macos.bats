#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`is-in-macos --help` should show help message' {
  run is-in-macos --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^is-in-macos - '
}

@test '`is-in-macos -h` should show help message' {
  run is-in-macos -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^is-in-macos - '
}

@test '`is-in-macos` should exit with the status matching `uname`' {
  run is-in-macos
  if [[ $(uname) == 'Darwin' ]] ; then
    expects "$status" to_be 0
  else
    expects "$status" to_be 1
  fi
}
