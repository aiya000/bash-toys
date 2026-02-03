#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`docker-attach-menu --help` should show help message' {
  run docker-attach-menu --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^docker-attach-menu - '
}

@test '`docker-attach-menu -h` should show help message' {
  run docker-attach-menu -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^docker-attach-menu - '
}
