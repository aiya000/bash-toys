#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`bak --help` should show help message' {
  run bak --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal "bak - Toggle backup (.bak) extension for files"
  expects "${lines[1]}" to_equal "Usage:"
}

@test '`bak` with no arguments should show error' {
  run bak
  expects "$status" to_be 1
  expects "$output" to_equal 'Error: 1 or more arguments required'
}