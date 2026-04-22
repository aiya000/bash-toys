#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`notify-ntfy --help` should show help message' {
  run notify-ntfy --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^Usage: notify-ntfy '
}

@test '`notify-ntfy -h` should show help message' {
  run notify-ntfy -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^Usage: notify-ntfy '
}

@test '`notify-ntfy` should use https://ntfy.sh as default server URL' {
  run env -u BASH_TOYS_NTFY_SERVER_BASE_URL BASH_TOYS_NTFY_TOPIC=test-topic DEBUG_BASHTOYS_PARSE_ONLY=1 notify-ntfy 'Title' 'Message'
  expects "$status" to_be 0
  expects "$output" to_match 'server_base_url=https://ntfy\.sh'
}

@test '`notify-ntfy` should use BASH_TOYS_NTFY_SERVER_BASE_URL when set' {
  run env BASH_TOYS_NTFY_SERVER_BASE_URL='http://192.168.1.10:18432' BASH_TOYS_NTFY_TOPIC=test-topic DEBUG_BASHTOYS_PARSE_ONLY=1 notify-ntfy 'Title' 'Message'
  expects "$status" to_be 0
  expects "$output" to_match 'server_base_url=http://192\.168\.1\.10:18432'
}
