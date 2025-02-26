#!/usr/bin/env bats

# shellcheck disable=SC2016,SC2034,SC2181

@test '`get-var name` should read a variable value of the name' {
  local name=10 result
  result=$(get-var name)
  expects "$result" to_equal 10
}

@test '`get-var name` should failure if the variable is not defined' {
  local result
  result=$(get-var name)
  [ "$?" -ne 0 ]
  [ "$result" != '' ]
}
