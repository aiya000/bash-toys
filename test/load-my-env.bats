#!/usr/bin/env bats

# shellcheck disable=SC2016

# shellcheck disable=SC1091
source ./source-all.sh

@test '`load-my-env --help` should show help message' {
  run load-my-env --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^load-my-env - '
}

@test '`load-my-env -h` should show help message' {
  run load-my-env -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^load-my-env - '
}
