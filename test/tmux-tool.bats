#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`tmux-tool --help` should show help message' {
  run tmux-tool --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^tmux-tool - '
}

@test '`tmux-tool -h` should show help message' {
  run tmux-tool -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^tmux-tool - '
}

@test '`tmux-tool` with no subcommand should show error and help' {
  run tmux-tool
  expects "$status" to_be 1
  expects "$output" to_match 'Error: a subcommand is required'
}

@test '`tmux-tool` with unknown subcommand should exit 1' {
  run tmux-tool unknown-subcommand
  expects "$status" to_be 1
  expects "$output" to_match 'Error: unknown subcommand'
}

@test '`tmux-tool` with unknown option should exit 1' {
  run tmux-tool --unknown
  expects "$status" to_be 1
  expects "$output" to_match 'Error: Unknown option'
}

@test '`tmux-tool attach-with-new-session` should default the session name to 0' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 tmux-tool attach-with-new-session
  expects "$status" to_be 0
  expects "$output" to_be 'session_name=0'
}

@test '`tmux-tool attach-with-new-session <name>` should use the given session name' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 tmux-tool attach-with-new-session main
  expects "$status" to_be 0
  expects "$output" to_be 'session_name=main'
}

@test '`tmux-tool attach-with-new-session` with two session names should exit 1' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 tmux-tool attach-with-new-session foo bar
  expects "$status" to_be 1
  expects "$output" to_match 'Error: attach-with-new-session takes at most one session name'
}

@test '`tmux-tool attach-with-new-session` with unknown option should exit 1' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 tmux-tool attach-with-new-session --unknown
  expects "$status" to_be 1
  expects "$output" to_match 'Error: Unknown option'
}
