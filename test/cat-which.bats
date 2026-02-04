#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`cat-which --help` should show help message' {
  run cat-which --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^cat-which - '
  expects "${lines[1]}" to_equal 'Usage:'
}

@test '`cat-which -h` should show help message' {
  run cat-which -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^cat-which - '
}

@test '`cat-which` with no arguments should show error' {
  run cat-which
  expects "$status" to_be 1
  expects "$output" to_equal 'Error: 1 or more arguments required'
}

@test '`cat-which` with binary file should show error' {
  run cat-which bash
  expects "$status" to_be 1
  expects "$output" to_match "^Not a plain text:"
}
