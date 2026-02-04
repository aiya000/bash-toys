#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`pomodoro-timer --help` should show help message' {
  run pomodoro-timer --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^pomodoro-timer - '
}

@test '`pomodoro-timer -h` should show help message' {
  run pomodoro-timer -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^pomodoro-timer - '
}
