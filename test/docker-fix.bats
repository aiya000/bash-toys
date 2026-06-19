#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`docker-fix --help` should show help message' {
  run docker-fix --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^docker-fix - '
}

@test '`docker-fix -h` should show help message' {
  run docker-fix -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^docker-fix - '
}

@test '`docker-fix` with no subcommand should show error and help' {
  run docker-fix ''
  expects "$status" to_be 1
  expects "$output" to_match 'Error: unknown subcommand'
}

@test '`docker-fix` with unknown subcommand should exit 1' {
  run docker-fix unknown-subcommand
  expects "$status" to_be 1
  expects "$output" to_match 'Error: unknown subcommand'
}

@test '`docker-fix` with unknown option should exit 1' {
  run docker-fix --unknown
  expects "$status" to_be 1
  expects "$output" to_match 'Error: Unknown option'
}
