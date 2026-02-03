#!/usr/bin/env bats

# shellcheck disable=SC2016

# shellcheck disable=SC1091
source ./source-all.sh

@test '`cd-finddir --help` should show help message' {
  run cd-finddir --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^cd-finddir - '
}

@test '`cd-finddir -h` should show help message' {
  run cd-finddir -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^cd-finddir - '
}
