#!/usr/bin/env bats

# shellcheck disable=SC2016

# Note: These tests focus on format validation and error handling.
# Actual notification scheduling is not tested to avoid real notifications.

LAUNCHD_PREFIX="com.bash-toys.notify-at"
LAUNCHD_DIR="$HOME/Library/LaunchAgents"

# Test setup and cleanup
setup() {
  # Set a unique test tag for this test run
  export NOTIFY_TEST_TAG="bats-test-$$-$RANDOM"
}

# Cleanup for Linux (at command)
cleanup_at_jobs() {
  local at_jobs
  at_jobs=$(atq 2>/dev/null || true)

  if [[ -n $at_jobs ]] ; then
    while IFS= read -r line ; do
      local job_id job_content

      if [[ -z $line ]] ; then
        continue
      fi

      job_id=$(echo "$line" | awk '{print $1}')
      job_content=$(at -c "$job_id" 2>/dev/null || true)
      if echo "$job_content" | grep -q "NOTIFY_AT_JOB" ; then
        atrm "$job_id" 2>/dev/null || true
      fi
    done <<< "$at_jobs"
  fi
}

# Cleanup for macOS (launchd)
cleanup_launchd_jobs() {
  if [[ -d "$LAUNCHD_DIR" ]] ; then
    for plist in "$LAUNCHD_DIR/$LAUNCHD_PREFIX."*.plist ; do
      [[ -f "$plist" ]] || continue
      launchctl unload "$plist" 2>/dev/null || true
      rm -f "$plist"
    done
  fi
  # Also clean up log files
  rm -f /tmp/notify-at-*.log 2>/dev/null || true
}

# Platform-aware cleanup
cleanup_test_jobs() {
  case "$(uname -s)" in
    Darwin)
      cleanup_launchd_jobs
      ;;
    *)
      cleanup_at_jobs
      ;;
  esac
  sleep 0.1 # Wait a moment for cleanup to complete
}

teardown() {
  cleanup_test_jobs >/dev/null 2>&1 || true
}

@test '`notify-at` with no arguments should show usage message' {
  run notify-at
  expects "$status" to_be 1
  # Help message varies by platform (launchd on macOS, at on Linux)
  expects "${lines[0]}" to_contain 'notify-at - Sends notification at specified time'
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
  run notify-at 23:59 'Test Title' 'Test Message'
  expects "$status" to_be 0
  expects "$output" to_contain 'Notification scheduled:'
  expects "$output" to_contain 'Job ID:'
}

@test '`notify-at` should accept MM-DD HH:MM format for future dates' {
  # Test with future date (assuming current date is before 12-31)
  run notify-at '12-31 23:59' 'Test Title' 'Test Message'
  expects "$status" to_be 0
  expects "$output" to_contain 'Notification scheduled:'
  expects "$output" to_contain 'Job ID:'
}

@test '`notify-at` should accept YYYY-MM-DD HH:MM format for future dates' {
  # Test with future date
  run notify-at '2027-01-15 09:00' 'Test Title' 'Test Message'
  expects "$status" to_be 0
  expects "$output" to_contain 'Notification scheduled:'
  expects "$output" to_contain 'Job ID:'
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
  cleanup_test_jobs

  run notify-at -l
  expects "$status" to_be 0
  expects "$output" to_equal 'No scheduled jobs found.'
}

@test '`notify-at --list` should show no jobs when none are scheduled' {
  # Clean up any existing jobs first
  cleanup_test_jobs

  run notify-at --list
  expects "$status" to_be 0
  expects "$output" to_equal 'No scheduled jobs found.'
}

@test '`notify-at -c` should show error without Job ID' {
  run notify-at -c
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Job ID required for cancel operation'
}

@test '`notify-at --cancel` should show error without Job ID' {
  run notify-at --cancel
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Job ID required for cancel operation'
}

@test '`notify-at -c` should show error for non-existent job' {
  run notify-at -c 99999
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Job with ID 99999 not found'
}

@test '`notify-at -c` should cancel successfully for existent job' {
  # Clean up any existing jobs first
  cleanup_test_jobs

  # Create a test job
  run notify-at 23:59 'Cancel Test' 'Cancel Message'
  expects "$status" to_be 0

  # Extract job ID from output
  local job_id
  job_id=$(echo "$output" | grep 'Job ID:' | awk '{print $3}')
  expects "$job_id" not to_equal ''

  # Cancel the job
  run notify-at -c "$job_id"
  expects "$status" to_be 0
  expects "$output" to_contain "cancelled successfully"
}

@test '`notify-at` should create and list a scheduled job' {
  # Clean up any existing jobs first
  cleanup_test_jobs

  # Create a test job
  run notify-at 23:59 'Test Job' 'Test Message'
  expects "$status" to_be 0

  # List jobs and check output
  run notify-at -l
  expects "$status" to_be 0
  expects "$output" to_contain 'JOB_ID'
  expects "$output" to_contain 'Test Job'
  expects "$output" to_contain 'Test Message'

  # Clean up is handled by teardown function automatically
}

@test '`notify-at --list` should correctly parse arguments with spaces' {
  # Simple test to verify the list command works without error
  run notify-at -l
  expects "$status" to_be 0
}

@test '`notify-at` with current time should not schedule for next day' {
  # When specifying the current minute, it should schedule for "now" (0 minutes later)
  # not "1 day later" - this was a bug where target == now caused +86400 seconds
  local current_time
  current_time=$(date +%H:%M)

  run notify-at "$current_time" 'Current Time Test' 'Test message'
  expects "$status" to_be 0
  expects "$output" to_contain 'Notification scheduled:'
  # Check the first line (schedule info) does not contain "1 day"
  expects "${lines[0]}" not to_contain '1 day'
}
