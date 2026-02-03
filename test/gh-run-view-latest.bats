#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`gh-run-view-latest --help` should show help message' {
  run gh-run-view-latest --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^gh-run-view-latest - '
}

@test '`gh-run-view-latest -h` should show help message' {
  run gh-run-view-latest -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^gh-run-view-latest - '
}
