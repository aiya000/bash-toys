#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`date-diff-seconds --help` should show help message' {
  run date-diff-seconds --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'date-diff-seconds - Calculate time difference in minutes'
  expects "${lines[1]}" to_equal ''
  expects "${lines[2]}" to_equal 'Usage:'
}

@test '`date-diff-seconds` with no arguments should show error' {
  run date-diff-seconds
  expects "$status" to_be 1
  expects "$output" to_equal 'Error: TIME1 and TIME2 arguments are required'
}