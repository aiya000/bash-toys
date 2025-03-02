#!/usr/bin/env bats

# shellcheck disable=SC2016

@test "expects 10 to_be 10 should succeed" {
  run expects 10 to_be 10
  [[ $status -eq 0 ]]
}

@test "expects 42 to_be 10 should fail" {
  run expects 42 to_be 10
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} to_be 10, but {actual} is: 42" ]]
}

@test "expects 10 not_to_be 42 should succeed" {
  run expects 10 not_to_be 42
  [[ $status -eq 0 ]]
}

@test "expects 10 not_to_be 10 should fail" {
  run expects 10 not_to_be 10
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} not_to_be 10, but {actual} is: 10" ]]
}

@test "expects 5 to_be_less_than 10 should succeed" {
  run expects 5 to_be_less_than 10
  [[ $status -eq 0 ]]
}

@test "expects 15 to_be_less_than 10 should fail" {
  run expects 15 to_be_less_than 10
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} to_be_less_than 10, but {actual} is: 15" ]]
}

@test "expects 10 not_to_be_less_than 5 should succeed" {
  run expects 10 not_to_be_less_than 5
  [[ $status -eq 0 ]]
}

@test "expects 5 not_to_be_less_than 10 should fail" {
  run expects 5 not_to_be_less_than 10
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} not_to_be_less_than 10, but {actual} is: 5" ]]
}

@test "expects 10 to_be_greater_than 5 should succeed" {
  run expects 10 to_be_greater_than 5
  [[ $status -eq 0 ]]
}

@test "expects 5 to_be_greater_than 10 should fail" {
  run expects 5 to_be_greater_than 10
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} to_be_greater_than 10, but {actual} is: 5" ]]
}

@test "expects 5 not_to_be_greater_than 10 should succeed" {
  run expects 5 not_to_be_greater_than 10
  [[ $status -eq 0 ]]
}

@test "expects 10 not_to_be_greater_than 5 should fail" {
  run expects 10 not_to_be_greater_than 5
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} not_to_be_greater_than 5, but {actual} is: 10" ]]
}

@test "expects 10 to_equal 10 should succeed" {
  run expects 10 to_equal 10
  [[ $status -eq 0 ]]
}

@test "expects 10 to_equal 20 should fail" {
  run expects 10 to_equal 20
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} to_equal 20, but {actual} is: 10" ]]
}

@test "expects 10 not_to_equal 20 should succeed" {
  run expects 10 not_to_equal 20
  [[ $status -eq 0 ]]
}

@test "expects 10 not_to_equal 10 should fail" {
  run expects 10 not_to_equal 10
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} not_to_equal 10, but {actual} is: 10" ]]
}

@test "expects 'hello world' to_contain 'world' should succeed" {
  run expects "hello world" to_contain "world"
  [[ $status -eq 0 ]]
}

@test "expects 'hello world' to_contain 'moon' should fail" {
  run expects "hello world" to_contain "moon"
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} to_contain moon, but {actual} is: hello world" ]]
}

@test "expects 'hello' not_to_contain 'xyz' should succeed" {
  run expects "hello" not_to_contain "xyz"
  [[ $status -eq 0 ]]
}

@test "expects 'hello' not_to_contain 'ell' should fail" {
  run expects "hello" not_to_contain "ell"
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} not_to_contain ell, but {actual} is: hello" ]]
}

@test "expects 'hello123' to_match '^[a-z]+[0-9]+$' should succeed" {
  run expects "hello123" to_match "^[a-z]+[0-9]+$"
  [[ $status -eq 0 ]]
}

@test "expects 'hello123' to_match '^[0-9]+$' should fail" {
  run expects "hello123" to_match "^[0-9]+$"
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} to_match ^[0-9]+$, but {actual} is: hello123" ]]
}

@test "expects 'abc' not_to_match '^[0-9]+$' should succeed" {
  run expects "abc" not_to_match "^[0-9]+$"
  [[ $status -eq 0 ]]
}

@test "expects '123' not_to_match '^[0-9]+$' should fail" {
  run expects "123" not_to_match "^[0-9]+$"
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} not_to_match ^[0-9]+$, but {actual} is: 123" ]]
}

@test "expects true to_be_true should succeed" {
  run expects true to_be_true
  [[ $status -eq 0 ]]
}

@test "expects false to_be_true should fail" {
  run expects false to_be_true
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} to_be_true, but {actual} is: false" ]]
}

@test "expects false not_to_be_true should succeed" {
  run expects false not_to_be_true
  [[ $status -eq 0 ]]
}

@test "expects true not_to_be_true should fail" {
  run expects true not_to_be_true
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} not_to_be_true, but {actual} is: true" ]]
}

@test "expects false to_be_false should succeed" {
  run expects false to_be_false
  [[ $status -eq 0 ]]
}

@test "expects true to_be_false should fail" {
  run expects true to_be_false
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} to_be_false, but {actual} is: true" ]]
}

@test "expects true not_to_be_false should succeed" {
  run expects true not_to_be_false
  [[ $status -eq 0 ]]
}

@test "expects false not_to_be_false should fail" {
  run expects false not_to_be_false
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} not_to_be_false, but {actual} is: false" ]]
}

@test "expects 'value' to_be_defined should succeed" {
  run expects "value" to_be_defined
  [[ $status -eq 0 ]]
}

@test "expects '' to_be_defined should fail" {
  run expects "" to_be_defined
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} to_be_defined, but {actual} is empty" ]]
}

@test "expects '' not_to_be_defined should succeed" {
  run expects "" not_to_be_defined
  [[ $status -eq 0 ]]
}

@test "expects 'value' not_to_be_defined should fail" {
  run expects "value" not_to_be_defined
  [[ $status -eq 1 ]]
  [[ $output == "FAIL: expected {actual} not_to_be_defined, but {actual} is: value" ]]
}
