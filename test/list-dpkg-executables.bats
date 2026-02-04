#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`list-dpkg-executables --help` should show help message' {
  run list-dpkg-executables --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^list-dpkg-executables - '
}

@test '`list-dpkg-executables -h` should show help message' {
  run list-dpkg-executables -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^list-dpkg-executables - '
}
