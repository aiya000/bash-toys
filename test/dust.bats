#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`dust --help` should show help message' {
  run dust --help
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "dust - Alternative to rm that moves files to dustbox instead of deletion" ]
  [ "${lines[1]}" = "" ]
  [ "${lines[2]}" = "Usage:" ]
}

@test '`dust` with no arguments should do nothing' {
  run dust
  [ "$status" -eq 0 ]
  [ "$output" = "" ]  # No error message, just silently succeed
}