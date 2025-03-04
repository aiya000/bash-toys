#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`bak --help` should show help message' {
  run bak --help
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "bak - Toggle backup (.bak) extension for files" ]
  [ "${lines[1]}" = "" ]
  [ "${lines[2]}" = "Usage:" ]
}

@test '`bak` with no arguments should show error' {
  run bak
  [ "$status" -eq 1 ]
  [ "$output" = 'Error: 1 or more arguments required' ]
}