#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`date-diff-seconds --help` should show help message' {
  run date-diff-seconds --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^date-diff-seconds - '
  expects "${lines[1]}" to_equal ''
  expects "${lines[3]}" to_equal 'Usage:'
}

@test '`date-diff-seconds` with no arguments should show error' {
  run date-diff-seconds
  expects "$status" to_be 1
  expects "$output" to_equal 'Error: TIME1 and TIME2 arguments are required'
}

@test 'date-diff-seconds works with date crossing' {
  # Test case 1: Same day
  run date-diff-seconds "2025-09-26 13:00" "2025-09-26 14:30"
  expects "$status" to_be 0
  expects "$output" to_equal "90"

  # Test case 2: Date crossing - night to morning
  run date-diff-seconds "2025-09-24 23:50" "2025-09-25 01:20"
  expects "$status" to_be 0
  expects "$output" to_equal "90"

  # Test case 3: Multiple hours crossing midnight
  run date-diff-seconds "2025-09-24 22:00" "2025-09-25 02:00"
  expects "$status" to_be 0
  expects "$output" to_equal "240"
}

@test 'date-diff-seconds with full YYYY-MM-DD HH:MM format' {
  # Test the fixed date-diff-seconds with full datetime format

  run date-diff-seconds "2025-09-26 10:00" "2025-09-26 11:30"
  expects "$status" to_be 0
  expects "$output" to_equal "90"

  run date-diff-seconds "2025-09-25 23:30" "2025-09-26 01:00"
  expects "$status" to_be 0
  expects "$output" to_equal "90"
}

@test 'date-diff-seconds backward compatibility with HH:MM format' {
  # Test that the old HH:MM format still works (assumes today)
  local today=$(date +%Y-%m-%d)

  # Compare HH:MM format result with full datetime format result
  run date-diff-seconds "10:00" "11:00"
  local hhmm_result="$output"
  expects "$status" to_be 0

  run date-diff-seconds "$today 10:00" "$today 11:00"
  local full_result="$output"
  expects "$status" to_be 0

  expects "$hhmm_result" to_equal "$full_result"
}

@test 'date-diff-seconds with MM-DD HH:MM format' {
  # Test MM-DD format (assumes current year)
  run date-diff-seconds "09-26 10:00" "09-26 12:00"
  expects "$status" to_be 0
  expects "$output" to_equal "120"

  # Cross-date with MM-DD format
  run date-diff-seconds "09-25 23:00" "09-26 01:00"
  expects "$status" to_be 0
  expects "$output" to_equal "120"
}
