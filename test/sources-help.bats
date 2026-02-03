#!/usr/bin/env bats

# Tests for -h/--help options in sources functions
# shellcheck disable=SC2016

# shellcheck disable=SC1091
source ./source-all.sh

# alias-of
@test '`alias-of --help` should show help message' {
  run alias-of --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^alias-of - '
}

@test '`alias-of -h` should show help message' {
  run alias-of -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^alias-of - '
}

# cd-finddir
@test '`cd-finddir --help` should show help message' {
  run cd-finddir --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^cd-finddir - '
}

@test '`cd-finddir -h` should show help message' {
  run cd-finddir -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^cd-finddir - '
}

# cd-to-git-root
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

# cd-to-node-root
@test '`cd-to-node-root --help` should show help message' {
  run cd-to-node-root --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^cd-to-node-root - '
}

@test '`cd-to-node-root -h` should show help message' {
  run cd-to-node-root -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^cd-to-node-root - '
}

# contains-value
@test '`contains-value --help` should show help message' {
  run contains-value --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^contains-value - '
}

@test '`contains-value -h` should show help message' {
  run contains-value -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^contains-value - '
}

# define-alt
@test '`define-alt --help` should show help message' {
  run define-alt --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^define-alt - '
}

@test '`define-alt -h` should show help message' {
  run define-alt -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^define-alt - '
}

# define-alt-export
@test '`define-alt-export --help` should show help message' {
  run define-alt-export --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^define-alt-export - '
}

@test '`define-alt-export -h` should show help message' {
  run define-alt-export -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^define-alt-export - '
}

# force-unexport
@test '`force-unexport --help` should show help message' {
  run force-unexport --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^force-unexport - '
}

@test '`force-unexport -h` should show help message' {
  run force-unexport -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^force-unexport - '
}

# i-have
@test '`i-have --help` should show help message' {
  run i-have --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^i-have - '
}

@test '`i-have -h` should show help message' {
  run i-have -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^i-have - '
}

# is-array
@test '`is-array --help` should show help message' {
  run is-array --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^is-array - '
}

@test '`is-array -h` should show help message' {
  run is-array -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^is-array - '
}

# load-my-env
@test '`load-my-env --help` should show help message' {
  run load-my-env --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^load-my-env - '
}

@test '`load-my-env -h` should show help message' {
  run load-my-env -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^load-my-env - '
}

# source-if-exists
@test '`source-if-exists --help` should show help message' {
  run source-if-exists --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^source-if-exists - '
}

@test '`source-if-exists -h` should show help message' {
  run source-if-exists -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^source-if-exists - '
}
