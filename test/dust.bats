#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`dust --help` should show help message' {
  run dust --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'dust - Alternative to rm that moves files to dustbox instead of deletion'
  expects "${lines[1]}" to_equal ''
  expects "${lines[2]}" to_equal 'Usage:'
}

@test '`dust` with no arguments should do nothing' {
  run dust
  expects "$status" to_be 0
  expects "$output" to_equal ''  # No error message, just silently succeed
}