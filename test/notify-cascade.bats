#!/usr/bin/env bats

# shellcheck disable=SC2016

# Note: These tests focus on cascade notification scheduling.
#
# WARNING: Some tests create/delete real launchd jobs on the host OS.
# To run these tests, set BASH_TOYS_TEST_REAL_JOBS=1
#
# Example:
#   BASH_TOYS_TEST_REAL_JOBS=1 bats test/notify-cascade.bats

LAUNCHD_PREFIX="com.bash-toys.notify-at"
LAUNCHD_DIR="$HOME/Library/LaunchAgents"

# Helper function to skip tests that affect real jobs
skip_unless_real_jobs_enabled() {
  if [[ "${BASH_TOYS_TEST_REAL_JOBS:-}" != "1" ]] ; then
    skip "This test affects real jobs on the host OS. Set BASH_TOYS_TEST_REAL_JOBS=1 to run."
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
  # Clean up script and log files (new location)
  rm -f "$HOME/.local/share/notify-at/notify-at-"*.sh 2>/dev/null || true
  rm -f "$HOME/.local/share/notify-at/notify-at-"*.log 2>/dev/null || true
  # Legacy /tmp cleanup
  rm -f /tmp/notify-at-*.sh 2>/dev/null || true
  rm -f /tmp/notify-at-*.log 2>/dev/null || true
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
  sleep 0.1
}

teardown() {
  if [[ "${BASH_TOYS_TEST_REAL_JOBS:-}" == "1" ]] ; then
    cleanup_test_jobs >/dev/null 2>&1 || true
  fi
}

@test '`notify-cascade` with no arguments should show help' {
  run notify-cascade
  expects "$status" to_be 1
  expects "$output" to_contain 'Usage:'
  expects "$output" to_contain 'notify-cascade'
}

@test '`notify-cascade --help` should show help message' {
  run notify-cascade --help
  expects "$status" to_be 0
  expects "$output" to_contain 'notify-cascade - Sends cascade of notifications'
  expects "$output" to_contain 'TIME formats (See also'
  expects "$output" to_contain 'Timing formats:'
}

@test '`notify-cascade` with insufficient arguments should show help' {
  run notify-cascade 15:00
  expects "$status" to_be 1
  expects "$output" to_contain 'Usage:'
}

@test '`notify-cascade` with two arguments should show help' {
  run notify-cascade 15:00 'Title'
  expects "$status" to_be 1
  expects "$output" to_contain 'Usage:'
}

@test '`notify-cascade` should reject invalid time format' {
  run notify-cascade 'invalid-time' 'Title' 'Message'
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Invalid time format'
}

@test '`notify-cascade` should reject past dates for MM-DD HH:MM format' {
  run notify-cascade '01-01 10:00' 'Title' 'Message'
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Specified date/time is in the past:'
}

@test '`notify-cascade` should reject past dates for YYYY-MM-DD HH:MM format' {
  run notify-cascade '2023-01-01 10:00' 'Title' 'Message'
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Specified date/time is in the past:'
}

# Regression test for date boundary issue
# Previously, notify-cascade only passed HH:MM to notify-at, causing incorrect dates
# when the notification time was close to midnight or crossed date boundaries.
@test '`notify-cascade` should pass full datetime to notify-at for correct date handling' {
  skip_unless_real_jobs_enabled
  cleanup_test_jobs

  # Schedule for tomorrow at 10:00 with 1m timing
  # The 1m before notification should be tomorrow at 09:59, not today
  local tomorrow_date
  tomorrow_date=$(date -d "+1 day" +"%m-%d" 2>/dev/null || date -v+1d +"%m-%d")
  local expected_year
  expected_year=$(date -d "+1 day" +"%Y" 2>/dev/null || date -v+1d +"%Y")

  run notify-cascade "$tomorrow_date 10:00" 'Date Test' 'Test message' 1m --local
  expects "$status" to_be 0

  # Check that the scheduled notification has the correct date
  run notify-at -l
  expects "$status" to_be 0
  # The notification should be scheduled for tomorrow 09:59, not today
  expects "$output" to_contain "$expected_year-$tomorrow_date 09:59"
}

@test '`notify-cascade` should schedule multiple notifications with correct dates' {
  skip_unless_real_jobs_enabled
  cleanup_test_jobs

  # Schedule for a future date with multiple timings
  local future_date
  future_date=$(date -d "+2 days" +"%Y-%m-%d" 2>/dev/null || date -v+2d +"%Y-%m-%d")

  run notify-cascade "$future_date 10:00" 'Multi Test' 'Test message' 1h 30m 5m --local
  expects "$status" to_be 0

  # Check all notifications are scheduled for the correct date
  run notify-at -l
  expects "$status" to_be 0
  # All notifications should be on the future date, not today
  expects "$output" to_contain "$future_date 09:00"  # 1h before
  expects "$output" to_contain "$future_date 09:30"  # 30m before
  expects "$output" to_contain "$future_date 09:55"  # 5m before
}

@test '`notify-cascade` should handle --mobile option without ntfy topic' {
  # Unset BASH_TOYS_NTFY_TOPIC to test error handling
  unset BASH_TOYS_NTFY_TOPIC
  run notify-cascade 23:59 'Test' 'Message' 5m --mobile
  # Should fail with missing ntfy topic error
  expects "$status" to_be 1
  expects "$output" to_contain 'BASH_TOYS_NTFY_TOPIC'
}

@test '`notify-cascade` should handle --local option' {
  skip_unless_real_jobs_enabled
  cleanup_test_jobs

  run notify-cascade 23:59 'Local Test' 'Message' 5m --local
  expects "$status" to_be 0
  expects "$output" to_contain 'Cascade notifications scheduled'
}

@test '`notify-cascade` should skip past notification times' {
  skip_unless_real_jobs_enabled
  cleanup_test_jobs

  # Schedule for soon with a very long timing that should be skipped
  run notify-cascade 23:59 'Skip Test' 'Message' 24h 5m --local
  expects "$status" to_be 0
  # The 24h notification would be in the past (relative to 23:59), so it should be skipped
  expects "$output" to_contain 'Skipping 24h notification'
}
