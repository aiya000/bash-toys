#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`notify-ntfy --help` should show help message' {
  run notify-ntfy --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^Usage: notify-ntfy '
}

@test '`notify-ntfy -h` should show help message' {
  run notify-ntfy -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^Usage: notify-ntfy '
}
