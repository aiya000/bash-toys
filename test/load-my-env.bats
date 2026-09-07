#!/usr/bin/env bats

# shellcheck disable=SC2016

# shellcheck disable=SC1091
source ./source-all.sh

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`load-my-env --help` should show help message' {
  run load-my-env --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^load-my-env - '
}

@test '`load-my-env -h` should show help message' {
  run load-my-env -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^load-my-env - '
}

@test '`load-my-env headroom` should be defined (not an undefined env)' {
  run load-my-env headroom
  expects "$status" to_be 0
  expects "$output" to_match 'headroom mcp backend'
}

@test '`load-my-env headroom` should set $ANTHROPIC_BASE_URL' {
  load-my-env headroom > /dev/null
  expects "$ANTHROPIC_BASE_URL" to_be http://127.0.0.1:8787
}
