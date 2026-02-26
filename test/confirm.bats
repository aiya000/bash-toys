#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`confirm --help` should show help message' {
  run confirm --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal "confirm - Ask a yes/no confirmation question"
  expects "${lines[1]}" to_equal "Usage:"
}

@test '`confirm -h` should show help message' {
  run confirm -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal "confirm - Ask a yes/no confirmation question"
}

@test '`confirm` with no arguments should show error and exit 2' {
  run confirm
  expects "$status" to_be 2
  expects "$output" to_equal 'Error: message is required'
}

@test '`confirm MESSAGE` with answer "y" should exit 0' {
  run bash -c "echo 'y' | confirm 'Continue?'"
  expects "$status" to_be 0
}

@test '`confirm MESSAGE` with answer "yes" should exit 0' {
  run bash -c "echo 'yes' | confirm 'Continue?'"
  expects "$status" to_be 0
}

@test '`confirm MESSAGE` with answer "n" should exit 1' {
  run bash -c "echo 'n' | confirm 'Continue?'"
  expects "$status" to_be 1
}

@test '`confirm MESSAGE` with other answer should exit 1' {
  run bash -c "echo 'nope' | confirm 'Continue?'"
  expects "$status" to_be 1
}

@test '`confirm --full-message MESSAGE` with answer "y" should exit 0' {
  run bash -c "echo 'y' | confirm --full-message 'Are you sure? '"
  expects "$status" to_be 0
}

@test '`confirm --full-message MESSAGE` with answer "n" should exit 1' {
  run bash -c "echo 'n' | confirm --full-message 'Are you sure? '"
  expects "$status" to_be 1
}

@test '`confirm --full-message` with no message should show error and exit 2' {
  run confirm --full-message
  expects "$status" to_be 2
  expects "$output" to_equal 'Error: message is required'
}

@test '`confirm --always-true MESSAGE` with answer "n" should exit 0' {
  run bash -c "echo 'n' | confirm --always-true 'Continue?'"
  expects "$status" to_be 0
}

@test '`confirm --always-true MESSAGE` with answer "no" should exit 0' {
  run bash -c "echo 'no' | confirm --always-true 'Continue?'"
  expects "$status" to_be 0
}

@test '`confirm --always-true` with no message should show error and exit 2' {
  run confirm --always-true
  expects "$status" to_be 2
  expects "$output" to_equal 'Error: message is required'
}

@test '`confirm --always-true --full-message MESSAGE` with answer "n" should exit 0' {
  run bash -c "echo 'n' | confirm --always-true --full-message 'Continue? '"
  expects "$status" to_be 0
}
