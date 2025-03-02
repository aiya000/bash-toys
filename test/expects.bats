#!/usr/bin/env bats

# shellcheck disable=SC2016

@test "expects 10 to_be 10 should succeed" {
  run expects 10 to_be 10
  [ "$status" -eq 0 ]
}

@test "expects 42 to_be 10 should fail" {
  run expects 42 to_be 10
  [ "$status" -eq 1 ]
  [[ "$output" == "FAIL: expected {actual} to_be 10, but {actual} is: 42" ]]
}

@test "expects 10 not_to_be 42 should succeed" {
  run expects 10 not_to_be 42
  [ "$status" -eq 0 ]
}

@test "expects 10 not_to_be 10 should fail" {
  run expects 10 not_to_be 10
  [ "$status" -eq 1 ]
  [[ "$output" == "FAIL: expected {actual} not_to_be 10, but {actual} is: 10" ]]
}

@test "expects 5 to_be_less_than 10 should succeed" {
  run expects 5 to_be_less_than 10
  [ "$status" -eq 0 ]
}

@test "expects 15 to_be_less_than 10 should fail" {
  run expects 15 to_be_less_than 10
  [ "$status" -eq 1 ]
  [[ "$output" == "FAIL: expected {actual} to_be_less_than 10, but {actual} is: 15" ]]
}

@test "expects 10 to_be_greater_than 5 should succeed" {
  run expects 10 to_be_greater_than 5
  [ "$status" -eq 0 ]
}

@test "expects 5 to_be_greater_than 10 should fail" {
  run expects 5 to_be_greater_than 10
  [ "$status" -eq 1 ]
  [[ "$output" == "FAIL: expected {actual} to_be_greater_than 10, but {actual} is: 5" ]]
}

@test "expects 10 to_equal 10 should succeed" {
  run expects 10 to_equal 10
  [ "$status" -eq 0 ]
}

@test "expects 10 to_equal 20 should fail" {
  run expects 10 to_equal 20
  [ "$status" -eq 1 ]
  [[ "$output" == "FAIL: expected {actual} to_equal 20, but {actual} is: 10" ]]
}

@test "expects 10 not_to_equal 20 should succeed" {
  run expects 10 not_to_equal 20
  [ "$status" -eq 0 ]
}

@test "expects 10 not_to_equal 10 should fail" {
  run expects 10 not_to_equal 10
  [ "$status" -eq 1 ]
  [[ "$output" == "FAIL: expected {actual} not_to_equal 10, but {actual} is: 10" ]]
}
