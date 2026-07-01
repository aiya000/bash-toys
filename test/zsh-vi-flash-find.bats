#!/usr/bin/env bats

# shellcheck disable=SC2016

# ZLE widget behavior requires an interactive zsh session and cannot be tested here.
# These tests verify that the source file loads safely and help text works.

setup() {
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`zsh-vi-flash-find-setup --help` should show help message' {
  run zsh -c 'source ./source-all.sh && zsh-vi-flash-find-setup --help'
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^zsh-vi-flash-find - '
}

@test '`zsh-vi-flash-find-setup -h` should show help message' {
  run zsh -c 'source ./source-all.sh && zsh-vi-flash-find-setup -h'
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^zsh-vi-flash-find - '
}

@test 'sourcing zsh-vi-flash-find.sh in bash should be a no-op' {
  run bash -c 'source ./sources/zsh-vi-flash-find.sh && type zsh-vi-flash-find-setup 2>&1; echo "exit:$?"'
  expects "$output" to_match 'not found|no zsh-vi-flash-find-setup'
}
