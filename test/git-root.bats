#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`git-root --help` should show help message' {
  run git-root --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^git-root - '
}

@test '`git-root -h` should show help message' {
  run git-root -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^git-root - '
}

@test '`git-root` should print git repository root when inside a git repo' {
  # This test runs in the bash-toys repository itself
  expected_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  run git-root
  expects "$status" to_be 0
  expects "$output" to_equal "$expected_root"
}

@test '`git-root` should exit with code 1 and no output when not in a git repo' {
  # Create a temporary directory that is not a git repository
  temp_dir=$(mktemp -d)

  # Run git-root in the non-git directory
  run bash -c "cd '$temp_dir' && git-root"

  # Clean up
  rm -rf "$temp_dir"

  # Verify exit code 1 and no output
  expects "$status" to_be 1
  expects "$output" to_be ""
}
