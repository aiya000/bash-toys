#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`date-diff-seconds-now --help` should show help message' {
  run date-diff-seconds-now --help
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "date-diff-seconds-now - Calculate time difference between given time and now" ]
  [ "${lines[1]}" = "" ]
  [ "${lines[2]}" = "Usage:" ]
}

@test '`date-diff-seconds-now` with no arguments should show error' {
  run date-diff-seconds-now
  [ "$status" -eq 1 ]
  [ "$output" = 'Error: TIME argument is required' ]
}