#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`is-in-wsl --help` should show help message' {
  run is-in-wsl --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^is-in-wsl - '
}

@test '`is-in-wsl -h` should show help message' {
  run is-in-wsl -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^is-in-wsl - '
}
