#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`date-diff-seconds --help` should show help message' {
  run date-diff-seconds --help
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "date-diff-seconds - Calculate time difference in minutes" ]
  [ "${lines[1]}" = "" ]
  [ "${lines[2]}" = "Usage:" ]
}

@test '`date-diff-seconds` with no arguments should show error' {
  run date-diff-seconds
  [ "$status" -eq 1 ]
  [ "$output" = 'Error: TIME1 and TIME2 arguments are required' ]
}