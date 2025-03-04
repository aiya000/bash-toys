#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`cat-which --help` should show help message' {
  run cat-which --help
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "cat-which - Display contents of executable files in PATH" ]
  [ "${lines[1]}" = "" ]
  [ "${lines[2]}" = "Usage:" ]
}

@test '`cat-which` with no arguments should show error' {
  run cat-which
  [ "$status" -eq 1 ]
  [ "$output" = 'Error: 1 or more arguments required' ]
}

@test '`cat-which` with binary file should show error' {
  run cat-which bash
  [ "$status" -eq 1 ]
  [[ $output == "Not a plain text:"* ]]
}