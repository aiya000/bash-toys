#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`pathshorten --help` should show help message' {
  run pathshorten --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^pathshorten - '
}

@test '`pathshorten -h` should show help message' {
  run pathshorten -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^pathshorten - '
}
