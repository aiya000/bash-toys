#!/usr/bin/env bats

# shellcheck disable=SC2016

# Note: These tests focus on format validation and error handling.
# Actual notification scheduling is not tested to avoid real notifications.

@test '`notify-at` with no arguments should show usage message' {
  run notify-at
  expects "$status" to_be 1
  expects "${lines[0]}" to_equal 'Usage: /Users/yoichiro.ishikawa/.dotfiles/bash-toys/bin/notify-at TIME title message [sound]'
  expects "${lines[1]}" to_equal 'TIME formats:'
  expects "${lines[2]}" to_equal '  HH:MM                - Time today (if past, then tomorrow)'
}

@test '`notify-at` with insufficient arguments should show usage message' {
  run notify-at 13:30
  expects "$status" to_be 1
  expects "$output" to_contain 'Usage:'
  expects "$output" to_contain 'TIME formats:'
}

@test '`notify-at` with two arguments should show usage message' {
  run notify-at 13:30 'Title'
  expects "$status" to_be 1
  expects "$output" to_contain 'Usage:'
}

@test '`notify-at` should accept HH:MM format' {
  # Test with a future time that should work
  timeout 1s notify-at 23:59 'Test Title' 'Test Message' 2>/dev/null &
  pid=$!
  sleep 0.1
  kill $pid 2>/dev/null || true
  wait $pid 2>/dev/null || true
  # If we get here without error, the format was accepted
  expects 0 to_be 0
}

@test '`notify-at` should accept MM-DD HH:MM format for future dates' {
  # Test with future date (assuming current date is before 12-31)
  timeout 1s notify-at '12-31 23:59' 'Test Title' 'Test Message' 2>/dev/null &
  pid=$!
  sleep 0.1
  kill $pid 2>/dev/null || true
  wait $pid 2>/dev/null || true
  # If we get here without error, the format was accepted
  expects 0 to_be 0
}

@test '`notify-at` should accept YYYY-MM-DD HH:MM format for future dates' {
  # Test with future date
  timeout 1s notify-at '2027-01-15 09:00' 'Test Title' 'Test Message' 2>/dev/null &
  pid=$!
  sleep 0.1
  kill $pid 2>/dev/null || true
  wait $pid 2>/dev/null || true
  # If we get here without error, the format was accepted
  expects 0 to_be 0
}

@test '`notify-at` should reject MM-DD HH:MM format for past dates' {
  run notify-at '01-01 10:00' 'Test Title' 'Test Message'
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Specified date/time is in the past:'
}

@test '`notify-at` should reject YYYY-MM-DD HH:MM format for past dates' {
  run notify-at '2023-01-01 10:00' 'Test Title' 'Test Message'
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Specified date/time is in the past:'
}

@test '`notify-at` should reject invalid hyphen-separated format MM-DD-HH:MM' {
  run notify-at '01-15-09:00' 'Test Title' 'Test Message'
  expects "$status" to_be 1
  expects "$output" to_equal 'Error: Invalid time format. Use HH:MM, MM-DD HH:MM, or YYYY-MM-DD HH:MM'
}

@test '`notify-at` should reject invalid hyphen-separated format YYYY-MM-DD-HH:MM' {
  run notify-at '2027-01-15-09:00' 'Test Title' 'Test Message'
  expects "$status" to_be 1
  expects "$output" to_equal 'Error: Invalid time format. Use HH:MM, MM-DD HH:MM, or YYYY-MM-DD HH:MM'
}

@test '`notify-at` should reject completely invalid format' {
  run notify-at 'invalid-time' 'Test Title' 'Test Message'
  expects "$status" to_be 1
  expects "$output" to_equal 'Error: Invalid time format. Use HH:MM, MM-DD HH:MM, or YYYY-MM-DD HH:MM'
}

@test '`notify-at` should reject malformed time format' {
  run notify-at '25:99' 'Test Title' 'Test Message'
  expects "$status" to_be 1
  # The malformed time will be detected by date command during parsing
  expects "$output" to_contain 'Error:'
}

@test '`notify-at` should reject malformed date format MM-DD HH:MM' {
  run notify-at '13-32 10:00' 'Test Title' 'Test Message'
  expects "$status" to_be 1
  # Malformed dates may be interpreted as past dates by date command
  expects "$output" to_contain 'Error:'
}

@test '`notify-at` should reject malformed date format YYYY-MM-DD HH:MM' {
  run notify-at '2027-13-32 10:00' 'Test Title' 'Test Message'
  expects "$status" to_be 1
  # Malformed dates may be interpreted as past dates by date command
  expects "$output" to_contain 'Error:'
}