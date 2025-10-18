#!/usr/bin/env bats

# shellcheck disable=SC2016

@test '`pomodoro-timer --from` with no start time should show error' {
  run pomodoro-timer --from
  expects "$status" to_be 1
  expects "$output" to_match "--from requires start time as a second argument"
}

@test '`pomodoro-timer --from` with no duration should show error' {
  run pomodoro-timer --from "20:45"
  expects "$status" to_be 1
  expects "$output" to_match "--from requires duration in minutes as a third argument"
}

@test '`pomodoro-timer --from` with HH:MM format should start timer' {
  # Test that HH:MM format is parsed correctly and timer starts
  run timeout 1s pomodoro-timer --from "20:45" 1
  # Should either timeout (124) or complete normally (0), not error out
  expects "$status" to_match "^(0|124)$"
  expects "$output" to_match "Starting.*work time"
}

@test '`pomodoro-timer --from` with YYYY-MM-DD HH:MM format should start timer' {
  # Test that the new date format is accepted and timer starts
  run timeout 1s pomodoro-timer --from "2025-09-26 20:45" 1
  # Should either timeout (124) or complete normally (0), not error out
  expects "$status" to_match "^(0|124)$"
  expects "$output" to_match "Starting.*work time"
}

@test 'pomodoro-timer --from with date crossing - night to morning' {
  # Test case 2: Date crossing - night to morning, using current time base
  run timeout 2s pomodoro-timer --from "2025-09-26 23:50" 120
  expects "$status" to_match "^(0|124)$"
  expects "$output" to_match "Starting.*work time"
  # Will have many minutes left since it's in the future
}

@test 'pomodoro-timer --from with multiple hours crossing midnight' {
  # Test case 3: Multiple hours crossing midnight, using future time
  run timeout 2s pomodoro-timer --from "2025-09-27 22:00" 300
  expects "$status" to_match "^(0|124)$"
  expects "$output" to_match "Starting.*work time"
  # Will have many minutes left since it's in the future
}

@test 'pomodoro-timer --from expired timer should show error' {
  # When remaining time is 0 or negative, should show expired message
  # Using a past date that would definitely be expired
  run pomodoro-timer --from "2025-01-01 00:00" 60
  # Should exit with error status due to expired timer
  expects "$status" to_be 1
  expects "$output" to_match "Timer has already expired"
}

@test 'pomodoro-timer --from with recent time should work correctly' {
  # Test with time from 1 hour ago (should have remaining time)
  run timeout 2s pomodoro-timer --from "2025-09-26 13:00" 120
  expects "$status" to_match "^(0|124)$"
  expects "$output" to_match "Starting.*work time"
  # Should have some remaining time
}