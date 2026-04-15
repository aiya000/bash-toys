#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`which-path --help` should show help message' {
  run which-path --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^which-path - '
  expects "${lines[1]}" to_equal 'Usage:'
}

@test '`which-path -h` should show help message' {
  run which-path -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^which-path - '
}

@test '`which-path` with no arguments should show usage and exit 1' {
  run which-path
  expects "$status" to_be 1
  expects "$output" to_contain 'Usage:'
}

@test '`which-path` should find a known command' {
  run which-path bash
  expects "$status" to_be 0
  expects "$output" to_match '^/'
  expects "$output" to_contain 'bash'
}

@test '`which-path` should return real path even when an alias shadows the command' {
  # Verify the real path first
  local real_path
  real_path=$(type -P ls)

  # In a subshell where alias ls is defined:
  #   `which ls`      → alias ls='echo fake'  (alias-aware)
  #   `which-path ls` → /bin/ls               (PATH only)
  run bash -c "
    shopt -s expand_aliases
    alias ls='echo fake'
    export PATH=\"${BATS_TEST_DIRNAME}/../bin:\$PATH\"
    which-path ls
  "
  expects "$status" to_be 0
  expects "$output" to_equal "$real_path"
}

@test '`which-path` should exit 1 for nonexistent command' {
  run which-path __nonexistent_command_bash_toys__
  expects "$status" to_be 1
  expects "$output" to_contain 'Command not found:'
}
