#!/usr/bin/env bats

# shellcheck disable=SC2016

# Tests for notify-at-at (Linux at command implementation)
#
# These tests are specific to the at-based implementation used on Linux.
# They test features like:
# - at command job scheduling
# - Job tagging and identification
# - at-specific job management
#
# WARNING: These tests create/delete real at jobs on the host OS.
# To run these tests, set BASH_TOYS_TEST_REAL_JOBS=1
#
# Example:
#   BASH_TOYS_TEST_REAL_JOBS=1 bats test/notify-at-at.bats

# Helper function to skip tests that affect real jobs
skip_unless_real_jobs_enabled() {
  if [[ "${BASH_TOYS_TEST_REAL_JOBS:-}" != "1" ]] ; then
    skip "This test affects real jobs on the host OS. Set BASH_TOYS_TEST_REAL_JOBS=1 to run."
  fi
}

# Helper function to skip tests on macOS
skip_if_macos() {
  if [[ "$(uname -s)" == "Darwin" ]] ; then
    skip "Test only runs on Linux (not macOS)"
  fi
}

# Test setup
setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
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

teardown() {
  # Only cleanup if real jobs testing is enabled
  if [[ "${BASH_TOYS_TEST_REAL_JOBS:-}" == "1" ]] ; then
    cleanup_at_jobs >/dev/null 2>&1 || true
  fi
}

# Tests for at command implementation

# TODO: Add tests for at-specific features
# Example tests to add:
# - Verify at job contains NOTIFY_AT_JOB tag
# - Verify at job scheduling with at command
# - Test job listing with atq
# - Test job cancellation with atrm
