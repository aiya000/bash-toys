#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`docker-kill-menu --help` should show help message' {
  run docker-kill-menu --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^docker-kill-menu - '
}

@test '`docker-kill-menu -h` should show help message' {
  run docker-kill-menu -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^docker-kill-menu - '
}
