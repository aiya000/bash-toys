#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`start --help` should show help message' {
  run start --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^start - '
}

@test '`start -h` should show help message' {
  run start -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^start - '
}
