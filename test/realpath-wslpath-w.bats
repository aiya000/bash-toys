#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`realpath-wslpath-w --help` should show help message' {
  run realpath-wslpath-w --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^realpath-wslpath-w - '
  expects "${lines[1]}" to_equal 'Usage:'
}

@test '`realpath-wslpath-w -h` should show help message' {
  run realpath-wslpath-w -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^realpath-wslpath-w - '
}

@test '`realpath-wslpath-w` with no arguments should exit 1' {
  run realpath-wslpath-w
  expects "$status" to_be 1
  expects "$output" to_contain 'Usage:'
}

@test '`realpath-wslpath-w` should output a Windows-style path' {
  if ! is-in-wsl ; then
    skip 'Not in WSL'
  fi
  run realpath-wslpath-w /tmp
  expects "$status" to_be 0
  expects "$output" to_contain "\\"
}

@test '`realpath-wslpath-w` should resolve relative path' {
  if ! is-in-wsl ; then
    skip 'Not in WSL'
  fi
  run realpath-wslpath-w .
  expects "$status" to_be 0
  expects "$output" to_contain "\\"
}
