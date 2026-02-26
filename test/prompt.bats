#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`prompt --help` should show help message' {
  run prompt --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal "prompt - Display a prompt and wait for the user to press Enter"
  expects "${lines[1]}" to_equal "Usage:"
}

@test '`prompt -h` should show help message' {
  run prompt -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal "prompt - Display a prompt and wait for the user to press Enter"
}

@test '`prompt` with no arguments should exit 0' {
  run bash -c "echo '' | prompt"
  expects "$status" to_be 0
}

@test '`prompt MESSAGE` should exit 0' {
  run bash -c "echo '' | prompt 'Press Enter to continue: '"
  expects "$status" to_be 0
}

@test '`prompt` should exit 0 regardless of input' {
  run bash -c "echo 'n' | prompt"
  expects "$status" to_be 0
}

@test '`prompt MESSAGE` should exit 0 regardless of input' {
  run bash -c "echo 'no' | prompt 'Are you sure? '"
  expects "$status" to_be 0
}
