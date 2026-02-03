#!/usr/bin/env bats

# shellcheck disable=SC2016

# shellcheck disable=SC1091
source ./source-all.sh

@test '`cd-to-git-root --help` should show help message' {
  run cd-to-git-root --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^cd-to-git-root - '
}

@test '`cd-to-git-root -h` should show help message' {
  run cd-to-git-root -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^cd-to-git-root - '
}
