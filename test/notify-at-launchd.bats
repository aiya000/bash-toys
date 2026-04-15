#!/usr/bin/env bats

# shellcheck disable=SC2016

# Tests for notify-at-launchd (macOS launchd implementation)
#
# These tests are specific to the launchd-based implementation used on macOS.
# They test features like:
# - StartCalendarInterval plist generation
# - Wrapper script creation with year validation
# - Script cleanup behavior
#
# WARNING: These tests create/delete real launchd jobs on the host OS.
# To run these tests, set BASH_TOYS_TEST_REAL_JOBS=1
#
# Example:
#   BASH_TOYS_TEST_REAL_JOBS=1 bats test/notify-at-launchd.bats

LAUNCHD_PREFIX="com.bash-toys.notify-at"
LAUNCHD_DIR="$HOME/Library/LaunchAgents"

# Helper function to skip tests that affect real jobs
skip_unless_real_jobs_enabled() {
  if [[ "${BASH_TOYS_TEST_REAL_JOBS:-}" != 1 ]] ; then
    skip "This test affects real jobs on the host OS. Set BASH_TOYS_TEST_REAL_JOBS=1 to run."
  fi
}

# Helper function to skip tests on non-macOS platforms
skip_unless_macos() {
  if [[ "$(uname -s)" != Darwin ]] ; then
    skip "Test only runs on macOS"
  fi
}

# Test setup
setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
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
  # Also clean up script and log files
  rm -f "$HOME/.local/share/notify-at/notify-at-"*.sh 2>/dev/null || true
  rm -f "$HOME/.local/share/notify-at/notify-at-"*.log 2>/dev/null || true
  # Legacy /tmp cleanup
  rm -f /tmp/notify-at-*.sh 2>/dev/null || true
  rm -f /tmp/notify-at-*.log 2>/dev/null || true
}

teardown() {
  # Only cleanup if real jobs testing is enabled
  if [[ "${BASH_TOYS_TEST_REAL_JOBS:-}" == 1 ]] ; then
    cleanup_launchd_jobs >/dev/null 2>&1 || true
  fi
}

# Tests for StartCalendarInterval implementation

@test '`notify-at` on macOS should create plist with StartCalendarInterval' {
  skip_unless_real_jobs_enabled
  skip_unless_macos

  # Clean up any existing jobs first
  cleanup_launchd_jobs

  # Create a test job
  run notify-at 23:59 'StartCalendarInterval Test' 'Test message'
  expects "$status" to_be 0

  # Extract job ID from output
  local job_id
  job_id=$(echo "$output" | grep 'Job ID:' | awk '{print $3}')
  expects "$job_id" to_be_defined

  # Check plist file contains StartCalendarInterval
  local plist_path="$LAUNCHD_DIR/$LAUNCHD_PREFIX.$job_id.plist"
  expects "$plist_path" to_be_a_file

  run cat "$plist_path"
  expects "$output" to_contain '<key>StartCalendarInterval</key>'
  expects "$output" to_contain '<key>Hour</key>'
  expects "$output" to_contain '<key>Minute</key>'
  expects "$output" to_contain '<integer>23</integer>'
  expects "$output" to_contain '<integer>59</integer>'
  # Should NOT contain RunAtLoad (or it should be false)
  expects "$output" not to_contain '<key>RunAtLoad</key>'
}

@test '`notify-at` on macOS should create wrapper script with year check' {
  skip_unless_real_jobs_enabled
  skip_unless_macos

  # Clean up any existing jobs first
  cleanup_launchd_jobs

  # Create a test job
  run notify-at 23:59 'Script Test' 'Test message'
  expects "$status" to_be 0

  # Extract job ID from output
  local job_id
  job_id=$(echo "$output" | grep 'Job ID:' | awk '{print $3}')
  expects "$job_id" to_be_defined

  # Check wrapper script exists
  local script_path="$HOME/.local/share/notify-at/notify-at-$job_id.sh"
  expects "$script_path" to_be_a_file

  # Check script contains year validation
  run cat "$script_path"
  expects "$output" to_contain 'target_year='
  expects "$output" to_contain 'current_year=$(date +%Y)'
  expects "$output" to_contain 'target_timestamp='

  # Cleanup (also removes script)
  run notify-at -c "$job_id"
  expects "$status" to_be 0
}

@test '`notify-at` cancel should also remove wrapper script' {
  skip_unless_real_jobs_enabled
  skip_unless_macos

  # Clean up any existing jobs first
  cleanup_launchd_jobs

  # Create a test job
  run notify-at 23:59 'Cleanup Test' 'Test message'
  expects "$status" to_be 0

  # Extract job ID from output
  local job_id
  job_id=$(echo "$output" | grep 'Job ID:' | awk '{print $3}')
  expects "$job_id" to_be_defined

  # Verify files exist before cancel
  local plist_path="$LAUNCHD_DIR/$LAUNCHD_PREFIX.$job_id.plist"
  local script_path="$HOME/.local/share/notify-at/notify-at-$job_id.sh"
  expects "$plist_path" to_be_a_file
  expects "$script_path" to_be_a_file

  # Cancel the job
  run notify-at -c "$job_id"
  expects "$status" to_be 0

  # Verify files are removed
  expects "$plist_path" not to_be_a_file
  expects "$script_path" not to_be_a_file
}

# Tests for script cleanup behavior

@test '`notify-at-launchd` script should cleanup when target time is more than 2 minutes past' {
  skip_unless_real_jobs_enabled
  skip_unless_macos

  # Clean up any existing jobs first
  cleanup_launchd_jobs

  # Create a test job
  run notify-at 23:59 'Past Time Test' 'Test message'
  expects "$status" to_be 0

  # Extract job ID from output
  local job_id
  job_id=$(echo "$output" | grep 'Job ID:' | awk '{print $3}')
  expects "$job_id" to_be_defined

  local plist_path="$LAUNCHD_DIR/$LAUNCHD_PREFIX.$job_id.plist"
  local script_path="$HOME/.local/share/notify-at/notify-at-$job_id.sh"

  # Verify files exist
  expects "$plist_path" to_be_a_file
  expects "$script_path" to_be_a_file

  # Modify the script to have a past timestamp (yesterday)
  local past_timestamp
  past_timestamp=$(($(date +%s) - 86400))

  # Replace the target_timestamp in the script
  local current_timestamp
  current_timestamp=$(grep '^target_timestamp=' "$script_path" | cut -d'"' -f2)
  sed -i '' "s/target_timestamp=\"$current_timestamp\"/target_timestamp=\"$past_timestamp\"/" "$script_path"

  # Execute the script
  run bash "$script_path"
  expects "$status" to_be 0

  # Verify files are removed (cleanup was executed)
  expects "$plist_path" not to_be_a_file
  expects "$script_path" not to_be_a_file
}

@test '`notify-at-launchd` generated script should use `launchctl bootout` instead of `launchctl unload`' {
  skip_unless_real_jobs_enabled
  skip_unless_macos

  cleanup_launchd_jobs

  run notify-at 23:59 'Bootout Test' 'Test message'
  expects "$status" to_be 0

  local job_id
  job_id=$(echo "$output" | grep 'Job ID:' | awk '{print $3}')
  expects "$job_id" to_be_defined

  local script_path="$HOME/.local/share/notify-at/notify-at-$job_id.sh"
  expects "$script_path" to_be_a_file

  # Should use bootout, not unload
  run cat "$script_path"
  expects "$output" to_contain 'launchctl bootout'
  expects "$output" not to_contain 'launchctl unload'

  run notify-at -c "$job_id"
  expects "$status" to_be 0
}

@test '`notify-at-launchd` generated script should remove files before calling launchctl in cleanup' {
  skip_unless_real_jobs_enabled
  skip_unless_macos

  cleanup_launchd_jobs

  run notify-at 23:59 'Cleanup Order Test' 'Test message'
  expects "$status" to_be 0

  local job_id
  job_id=$(echo "$output" | grep 'Job ID:' | awk '{print $3}')
  expects "$job_id" to_be_defined

  local script_path="$HOME/.local/share/notify-at/notify-at-$job_id.sh"
  expects "$script_path" to_be_a_file

  # Find the last rm -f "$plist_path" and launchctl bootout line numbers
  local rm_line launchctl_line
  rm_line=$(grep -n 'rm -f "\$plist_path"' "$script_path" | tail -1 | cut -d: -f1)
  launchctl_line=$(grep -n 'launchctl bootout' "$script_path" | tail -1 | cut -d: -f1)

  # rm -f must appear before launchctl bootout in the cleanup section
  [[ "$rm_line" -lt "$launchctl_line" ]]

  run notify-at -c "$job_id"
  expects "$status" to_be 0
}

@test '`notify-at-launchd` cleanup should remove files even if launchctl fails' {
  skip_unless_real_jobs_enabled
  skip_unless_macos

  cleanup_launchd_jobs

  run notify-at 23:59 'Launchctl Failure Test' 'Test message'
  expects "$status" to_be 0

  local job_id
  job_id=$(echo "$output" | grep 'Job ID:' | awk '{print $3}')
  expects "$job_id" to_be_defined

  local plist_path="$LAUNCHD_DIR/$LAUNCHD_PREFIX.$job_id.plist"
  local script_path="$HOME/.local/share/notify-at/notify-at-$job_id.sh"

  expects "$plist_path" to_be_a_file
  expects "$script_path" to_be_a_file

  # Set a past timestamp to trigger the "too late" cleanup branch
  local past_timestamp
  past_timestamp=$(($(date +%s) - 86400))
  local current_timestamp
  current_timestamp=$(grep '^target_timestamp=' "$script_path" | cut -d'"' -f2)
  sed -i '' "s/target_timestamp=\"$current_timestamp\"/target_timestamp=\"$past_timestamp\"/" "$script_path"

  # Create a mock launchctl that always fails
  local mock_bin_dir
  mock_bin_dir=$(mktemp -d)
  printf '#!/bin/bash\nexit 1\n' > "$mock_bin_dir/launchctl"
  chmod +x "$mock_bin_dir/launchctl"

  # Run the cleanup script with mock launchctl
  PATH="$mock_bin_dir:$PATH" run bash "$script_path"
  expects "$status" to_be 0

  # Files must be removed despite launchctl failing
  expects "$plist_path" not to_be_a_file
  expects "$script_path" not to_be_a_file

  rm -rf "$mock_bin_dir"
}

@test '`notify-at` should accept tomorrow HH:MM format (launchd implementation)' {
  skip_unless_real_jobs_enabled
  skip_unless_macos
  cleanup_launchd_jobs

  run notify-at 'tomorrow 23:59' 'Tomorrow Test' 'Test message'
  expects "$status" to_be 0
  expects "$output" to_contain 'Notification scheduled:'
  expects "$output" to_contain 'Job ID:'

  local job_id
  job_id=$(echo "$output" | grep 'Job ID:' | awk '{print $3}')
  expects "$job_id" to_be_defined

  run notify-at -c "$job_id"
  expects "$status" to_be 0
}

@test '`notify-at-launchd --list-day-titles` should show no notification for date with no jobs' {
  skip_unless_macos

  run notify-at-launchd --list-day-titles 2099-12-31
  expects "$status" to_be 0
  expects "$output" to_equal 'No notification at 2099-12-31'
}

@test '`notify-at-launchd --list-all-titles` should show no notification when no jobs exist' {
  skip_unless_real_jobs_enabled
  skip_unless_macos
  cleanup_launchd_jobs

  run notify-at-launchd --list-all-titles
  expects "$status" to_be 0
  expects "$output" to_equal 'No notification scheduled.'
}

@test '`notify-at-launchd --list-day-titles DATE` should list titles for jobs on that date' {
  skip_unless_real_jobs_enabled
  skip_unless_macos
  cleanup_launchd_jobs

  run notify-at-launchd '2027-06-15 14:30' 'Meeting' 'Team standup'
  expects "$status" to_be 0

  run notify-at-launchd --list-day-titles 2027-06-15
  expects "$status" to_be 0
  expects "$output" to_contain "* Meeting'14:30'"
}

@test '`notify-at-launchd --list-day-titles DATE` should sort multiple titles by time' {
  skip_unless_real_jobs_enabled
  skip_unless_macos
  cleanup_launchd_jobs

  run notify-at-launchd '2027-06-15 14:30' 'Afternoon' 'pm'
  expects "$status" to_be 0
  run notify-at-launchd '2027-06-15 09:00' 'Morning' 'am'
  expects "$status" to_be 0

  run notify-at-launchd --list-day-titles 2027-06-15
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal "* Morning'09:00'"
  expects "${lines[1]}" to_equal "* Afternoon'14:30'"
}

@test '`notify-at-launchd --list-all-titles` should list titles grouped by date' {
  skip_unless_real_jobs_enabled
  skip_unless_macos
  cleanup_launchd_jobs

  run notify-at-launchd '2027-06-15 10:00' 'Morning Meeting' 'Stand up'
  expects "$status" to_be 0
  run notify-at-launchd '2027-06-16 14:30' 'Afternoon Review' 'Code review'
  expects "$status" to_be 0

  run notify-at-launchd --list-all-titles
  expects "$status" to_be 0
  expects "$output" to_contain '2027-06-15'
  expects "$output" to_contain "* Morning Meeting'10:00'"
  expects "$output" to_contain '2027-06-16'
  expects "$output" to_contain "* Afternoon Review'14:30'"
}

@test '`notify-at-launchd` script should cleanup when year does not match' {
  skip_unless_real_jobs_enabled
  skip_unless_macos

  # Clean up any existing jobs first
  cleanup_launchd_jobs

  # Create a test job
  run notify-at 23:59 'Year Mismatch Test' 'Test message'
  expects "$status" to_be 0

  # Extract job ID from output
  local job_id
  job_id=$(echo "$output" | grep 'Job ID:' | awk '{print $3}')
  expects "$job_id" to_be_defined

  local plist_path="$LAUNCHD_DIR/$LAUNCHD_PREFIX.$job_id.plist"
  local script_path="$HOME/.local/share/notify-at/notify-at-$job_id.sh"

  # Verify files exist
  expects "$plist_path" to_be_a_file
  expects "$script_path" to_be_a_file

  # Modify the script to have next year
  local next_year
  next_year=$(($(date +%Y) + 1))

  # Replace the target_year in the script
  local current_year
  current_year=$(date +%Y)
  sed -i '' "s/target_year=\"$current_year\"/target_year=\"$next_year\"/" "$script_path"

  # Execute the script
  run bash "$script_path"
  expects "$status" to_be 0

  # Verify files are removed (cleanup was executed)
  expects "$plist_path" not to_be_a_file
  expects "$script_path" not to_be_a_file
}
