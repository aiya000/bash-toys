#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
  # Back up any existing pomodoro count files so tests don't delete real user state
  POMODORO_BACKUP_DIR=''
  for f in /tmp/pomodoro-* ; do
    [[ -e $f ]] || continue
    if [[ $POMODORO_BACKUP_DIR == '' ]] ; then
      POMODORO_BACKUP_DIR="$(mktemp -d)"
    fi
    mv "$f" "$POMODORO_BACKUP_DIR"/
  done
}

teardown() {
  # Clean up any pomodoro count files created during tests
  rm -f /tmp/pomodoro-* 2> /dev/null
  # Restore any pomodoro count files that existed before the test run
  if [[ -d ${POMODORO_BACKUP_DIR:-} ]] ; then
    for f in "$POMODORO_BACKUP_DIR"/pomodoro-* ; do
      [[ -e $f ]] || continue
      mv "$f" /tmp/
    done
    rm -rf "$POMODORO_BACKUP_DIR"
  fi
}

@test '`pomodoro-timer --help` should show help message' {
  run pomodoro-timer --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^pomodoro-timer - '
}

@test '`pomodoro-timer -h` should show help message' {
  run pomodoro-timer -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^pomodoro-timer - '
}

@test '`pomodoro-timer --from` without arguments should show error' {
  run pomodoro-timer --from
  expects "$status" to_be 1
  expects "$output" to_contain '--from requires start time as a second argument'
}

@test '`pomodoro-timer --from HH:MM` without minutes should show error' {
  run pomodoro-timer --from 10:00
  expects "$status" to_be 1
  expects "$output" to_contain '--from requires duration in minutes as a third argument'
}

@test '`pomodoro-timer --from` with expired time should show error' {
  run pomodoro-timer --from 00:00 0
  expects "$status" to_be 1
  expects "$output" to_contain 'Timer has already expired'
}

@test 'pomodoro-timer --from YYYY-MM-DD HH:MM with expired date should show error' {
  run pomodoro-timer --from '2020-01-01 00:00' 60
  expects "$status" to_be 1
  expects "$output" to_contain 'Timer has already expired'
}

@test '`pomodoro-timer --set-count` without argument should show error' {
  run pomodoro-timer --set-count
  expects "$status" to_be 1
  expects "$output" to_contain '--set-count requires count as a second argument'
}

@test '`pomodoro-timer --set-count N` should set pomodoro count' {
  run pomodoro-timer --set-count 3
  expects "$status" to_be 0
  expects "$output" to_contain 'The current pomodoro count is 3'
}

@test '`pomodoro-timer --get-count` should return current count' {
  run pomodoro-timer --get-count
  expects "$status" to_be 0
  expects "$output" to_match '^[0-9]+$'
}

@test '`pomodoro-timer --set-count` then `--get-count` should return the next session number (set count + 1)' {
  pomodoro-timer --set-count 5 > /dev/null
  run pomodoro-timer --get-count
  expects "$status" to_be 0
  expects "$output" to_be '6'
}

@test '`pomodoro-timer --clean` should reset pomodoro count' {
  pomodoro-timer --set-count 2 > /dev/null
  run pomodoro-timer --clean
  expects "$status" to_be 0
  expects "$output" to_contain 'Removed:'
}

@test '`pomodoro-timer --clean` with no count should show message' {
  run pomodoro-timer --clean
  expects "$status" to_be 1
  expects "$output" to_contain 'Pomodoro count has not started yet'
}
