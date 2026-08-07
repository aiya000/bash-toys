#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`notify-task-result --help` should show help message' {
  run notify-task-result --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^notify-task-result '
}

@test '`notify-task-result -h` should show help message' {
  run notify-task-result -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^notify-task-result '
}

@test '`notify-task-result` should use default succeed sound' {
  run env -u BASH_TOYS_NOTIFY_TASK_RESULT_SUCCEED_SOUND DEBUG_BASHTOYS_PARSE_ONLY=1 notify-task-result
  expects "$status" to_be 0
  expects "$output" to_match 'succeed_sound=.*/notification-3\.mp3'
}

@test '`notify-task-result` should use default failed sound' {
  run env -u BASH_TOYS_NOTIFY_TASK_RESULT_FAILED_SOUND DEBUG_BASHTOYS_PARSE_ONLY=1 notify-task-result
  expects "$status" to_be 0
  expects "$output" to_match 'failed_sound=.*/notification-2\.mp3'
}

@test '`notify-task-result` should use BASH_TOYS_NOTIFY_TASK_RESULT_SUCCEED_SOUND when set' {
  local mock_bin
  mock_bin="$(mktemp -d)"
  printf '#!/bin/bash\necho "notify: $*"\n' > "$mock_bin/notify"
  chmod +x "$mock_bin/notify"

  run bash -c "
    export PATH='${mock_bin}:${PATH}'
    export BASH_TOYS_NOTIFY_TASK_RESULT_SUCCEED_SOUND='/custom/success.mp3'
    true
    source '${BATS_TEST_DIRNAME}/../bin/notify-task-result'
  "
  rm -rf "$mock_bin"
  expects "$status" to_be 0
  expects "$output" to_match '/custom/success\.mp3'
}

@test '`notify-task-result` should use BASH_TOYS_NOTIFY_TASK_RESULT_FAILED_SOUND when set' {
  local mock_bin
  mock_bin="$(mktemp -d)"
  printf '#!/bin/bash\necho "notify: $*"\n' > "$mock_bin/notify"
  chmod +x "$mock_bin/notify"

  run bash -c "
    export PATH='${mock_bin}:${PATH}'
    export BASH_TOYS_NOTIFY_TASK_RESULT_FAILED_SOUND='/custom/failure.mp3'
    false
    source '${BATS_TEST_DIRNAME}/../bin/notify-task-result'
  "
  rm -rf "$mock_bin"
  expects "$status" to_be 0
  expects "$output" to_match '/custom/failure\.mp3'
}

@test '`notify-task-result` should reject unknown options' {
  run notify-task-result --unknown
  expects "$status" to_be 1
  expects "$output" to_match 'Error: Unknown option: --unknown'
}
