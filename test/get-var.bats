#!/usr/bin/env bats

# shellcheck disable=SC2016,SC2034,SC2181

# shellcheck disable=SC1091
source ./sources/get-var.sh

@test '`get-var name` should read a variable value of the name' {
  local name=10
  run get-var name
  expects "$output" to_equal 10
}

@test '`get-var name` should failure if the variable is not defined' {
  run get-var name
  [ "$status" -ne 0 ]
  [ "$output" == '' ]
}
