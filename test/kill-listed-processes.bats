#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`kill-listed-processes --help` should show help message' {
  run kill-listed-processes --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^kill-listed-processes - '
}

@test '`kill-listed-processes -h` should show help message' {
  run kill-listed-processes -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^kill-listed-processes - '
}

@test '`kill-listed-processes --unknown` should exit with error' {
  run kill-listed-processes --unknown
  expects "$status" to_be 1
}

@test 'DEBUG_BASHTOYS_PARSE_ONLY should print default process_names and apps' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 \
    env -u BASH_TOYS_KILL_LISTED_PROCESS_NAMES \
    env -u BASH_TOYS_KILL_LISTED_APPS \
    kill-listed-processes
  expects "$status" to_be 0
  expects "$output" to_match 'process_names=nvim claude java npm node deno'
  expects "$output" to_match 'apps=OpenDeck'
}

@test 'DEBUG_BASHTOYS_PARSE_ONLY should print custom process_names' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 \
    BASH_TOYS_KILL_LISTED_PROCESS_NAMES='nvim node' \
    kill-listed-processes
  expects "$status" to_be 0
  expects "$output" to_match 'process_names=nvim node'
}

@test 'DEBUG_BASHTOYS_PARSE_ONLY should print custom apps' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 \
    BASH_TOYS_KILL_LISTED_APPS='MyApp AnotherApp' \
    kill-listed-processes
  expects "$status" to_be 0
  expects "$output" to_match 'apps=MyApp AnotherApp'
}
