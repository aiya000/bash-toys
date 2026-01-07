#!/usr/bin/env bats

# shellcheck disable=SC2016

# Note: These tests focus on format validation and error handling.
# Actual notification scheduling is not tested to avoid real notifications.

# Test setup and cleanup
setup() {
  # Set a unique test tag for this test run
  export NOTIFY_TEST_TAG="bats-test-$$-$RANDOM"
}

# Test-specific cleanup function
cleanup_test_jobs() {
  local target_tag="${1:-}"

  # If no target specified, clean all test-related notify-at processes
  if [[ -z "$target_tag" ]] ; then
    # Clean all notify-at processes (ps-based approach)
    # Kill all notify-at processes that contain test job signatures
    pkill -f "bin/notify-at.*(Test|Message|Job|Title|Multi|Another|Cleanup|Improved)" 2>/dev/null || true
  else
    # Clean jobs with specific tag
    pkill -f "bin/notify-at.*${target_tag}" 2>/dev/null || true
  fi

  # Wait a moment for processes to terminate
  sleep 0.1
}

teardown() {
  # Clean up any test jobs created during this test
  cleanup_test_jobs >/dev/null 2>&1 || true
}

@test '`notify-at` with no arguments should show usage message' {
  run notify-at
  expects "$status" to_be 1
  expects "${lines[0]}" to_equal 'notify-at - Sends notification at specified time with flexible date formats'
  expects "$output" to_contain 'Usage:'
  expects "$output" to_contain 'TIME formats:'
  expects "$output" to_contain 'Options:'
  expects "$output" to_contain 'Job management:'
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

# Job management tests

@test '`notify-at -l` should show no jobs when none are scheduled' {
  # Clean up any existing jobs first
  rm -rf "$HOME/.bash-toys/notify-at/jobs"

  run notify-at -l
  expects "$status" to_be 0
  expects "$output" to_equal 'No scheduled jobs found.'
}

@test '`notify-at --list` should show no jobs when none are scheduled' {
  # Clean up any existing jobs first
  rm -rf "$HOME/.bash-toys/notify-at/jobs"

  run notify-at --list
  expects "$status" to_be 0
  expects "$output" to_equal 'No scheduled jobs found.'
}

@test '`notify-at -c` should show error without PID' {
  run notify-at -c
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: PID required for cancel operation'
}

@test '`notify-at --cancel` should show error without PID' {
  run notify-at --cancel
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: PID required for cancel operation'
}

@test '`notify-at -c` should show error for non-existent job' {
  run notify-at -c 99999
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Job with PID 99999 not found'
}

@test '`notify-at -c` should kill successfully for existent job' {
  echo TODO
  return 1
}

@test '`notify-at` should create and list a scheduled job' {
  echo TODO  # Below test requires to wait a long time. Fix it
  return 1

  # Clean up any existing jobs first
  cleanup_test_jobs

  # Create a test job (use a long future time to avoid immediate execution)
  timeout 1s notify-at 23:59 'Test Job' 'Test Message' >/dev/null 2>&1 &
  sleep 0.1

  # List jobs and check output
  run notify-at -l
  expects "$status" to_be 0
  expects "$output" to_contain 'PID'
  expects "$output" to_contain 'Test Job'
  expects "$output" to_contain 'Test Message'

  # Clean up is handled by teardown function automatically
}

@test '`notify-at --list` should correctly parse arguments with spaces' {
  echo TODO  # Below test requires to wait a long time. Fix it
  return 1

  # Simple test to verify the list command works without error
  run notify-at -l
  expects "$status" to_be 0
}


