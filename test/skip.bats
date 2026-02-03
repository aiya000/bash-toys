#!/usr/bin/env bats

# shellcheck disable=SC2016

# NOTE: `skip` is a bats built-in, so we use `command skip`
@test '`skip --help` should show help message' {
  run command skip --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^skip - '
}

@test '`skip -h` should show help message' {
  run command skip -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^skip - '
}
