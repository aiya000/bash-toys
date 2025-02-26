#!/usr/bin/env bats

# shellcheck disable=SC2016

declare -a params=(
  "10 to_be 10 0 ''"
  "42 to_be 10 1 'FAIL: expected {actual} to_be 10, but {actual} is: 42'"
  "10 not_to_be 42 0 ''"
  "10 not_to_be 10 1 'FAIL: expected {actual} not_to_be 10, but {actual} is: 10'"
  "5 to_be_less_than 10 0 ''"
  "15 to_be_less_than 10 1 'FAIL: expected {actual} to_be_less_than 10, but {actual} is: 15'"
  "10 to_be_greater_than 5 0 ''"
  "5 to_be_greater_than 10 1 'FAIL: expected {actual} to_be_greater_than 10, but {actual} is: 5'"
  "10 to_equal 10 0 ''"
  "10 to_equal 20 1 'FAIL: expected {actual} to_equal 20, but {actual} is: 10'"
  "10 not_to_equal 20 0 ''"
  "10 not_to_equal 10 1 'FAIL: expected {actual} not_to_equal 10, but {actual} is: 10'"
)

for param in "${params[@]}" ; do
  IFS=' ' read -r actual_value compare_method expected_value expected_status expected_message <<< "$param"
  @test "\`expects $actual_value $compare_method $expected_value\` should exit with $expected_status" {
    run expects "$actual_value" "$compare_method" "$expected_value"
    [ "$status" -eq "$expected_status" ]
    if [ "$expected_status" -eq 1 ] ; then
      [[ "'$output'" == "$expected_message" ]]
    fi
  }
done
