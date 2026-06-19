#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`docker-tool --help` should show help message' {
  run docker-tool --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^docker-tool - '
}

@test '`docker-tool -h` should show help message' {
  run docker-tool -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^docker-tool - '
}

@test '`docker-tool` with no subcommand should show error and help' {
  run docker-tool ''
  expects "$status" to_be 1
  expects "$output" to_match 'Error: at least one subcommand is required'
}

@test '`docker-tool` with unknown subcommand should exit 1' {
  run docker-tool unknown-subcommand
  expects "$status" to_be 1
  expects "$output" to_match 'Error: unknown subcommand'
}

@test '`docker-tool` with unknown option should exit 1' {
  run docker-tool --unknown
  expects "$status" to_be 1
  expects "$output" to_match 'Error: Unknown option'
}

@test '`docker-tool run` with no subcommand should exit 1' {
  run docker-tool run
  expects "$status" to_be 1
  expects "$output" to_match 'Error: at least one subcommand is required'
}

@test '`docker-tool run` with unknown subcommand should exit 1' {
  run docker-tool run unknown-subcommand
  expects "$status" to_be 1
  expects "$output" to_match 'Error: unknown subcommand'
}
