#!/usr/bin/env bats

# shellcheck disable=SC2016,SC2034,SC2181

# shellcheck disable=SC1091
source ./sources/get-var.sh

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`get-var --help` should show help message' {
  run get-var --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^get-var - '
}

@test '`get-var -h` should show help message' {
  run get-var -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^get-var - '
}

@test '`get-var name` should read a variable value of the name' {
  local name=10
  run get-var name
  expects "$output" to_equal 10
}

@test '`get-var name` should failure if the variable is not defined' {
  run get-var name
  expects "$status" to_be 1
  expects "$output" to_equal ''
}
