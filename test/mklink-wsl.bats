#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`mklink-wsl --help` should show help message' {
  run mklink-wsl --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^mklink-wsl - '
  expects "${lines[1]}" to_equal 'Usage:'
}

@test '`mklink-wsl -h` should show help message' {
  run mklink-wsl -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^mklink-wsl - '
}

@test '`mklink-wsl` with no arguments should exit 1' {
  run mklink-wsl
  expects "$status" to_be 1
  expects "$output" to_contain 'Usage:'
}

@test '`mklink-wsl` with only one argument should exit 1' {
  run mklink-wsl MyLink
  expects "$status" to_be 1
  expects "$output" to_contain 'Usage:'
}

@test '`mklink-wsl --type` with unknown type should exit 1' {
  run mklink-wsl --type X MyLink MyTarget
  expects "$status" to_be 1
  expects "$output" to_contain 'Unknown link type'
}

@test '`mklink-wsl -t` with unknown type should exit 1' {
  run mklink-wsl -t X MyLink MyTarget
  expects "$status" to_be 1
  expects "$output" to_contain 'Unknown link type'
}
