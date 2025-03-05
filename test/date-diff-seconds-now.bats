#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`date-diff-seconds-now --help` should show help message' {
  run date-diff-seconds-now --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^date-diff-seconds-now - '
  expects "${lines[1]}" to_equal ''
  expects "${lines[3]}" to_equal 'Usage:'
}

@test '`date-diff-seconds-now` with no arguments should show error' {
  run date-diff-seconds-now
  expects "$status" to_be 1
  expects "$output" to_equal 'Error: TIME argument is required'
}
