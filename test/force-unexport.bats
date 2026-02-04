#!/usr/bin/env bats

# shellcheck disable=SC2016

# shellcheck disable=SC1091
source ./source-all.sh

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`force-unexport --help` should show help message' {
  run force-unexport --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^force-unexport - '
}

@test '`force-unexport -h` should show help message' {
  run force-unexport -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^force-unexport - '
}
