#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`slice --help` should show help message' {
  run slice --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^slice - '
}

@test '`slice -h` should show help message' {
  run slice -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^slice - '
}
