#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`peco-reverse --help` should show help message' {
  run peco-reverse --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^peco-reverse - '
}

@test '`peco-reverse -h` should show help message' {
  run peco-reverse -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^peco-reverse - '
}
