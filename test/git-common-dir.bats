#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`git-common-dir --help` should show help message' {
  run git-common-dir --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^git-common-dir - '
}

@test '`git-common-dir -h` should show help message' {
  run git-common-dir -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^git-common-dir - '
}

@test '`git-common-dir` should print git common directory when inside a git repo' {
  # This test runs in the bash-toys repository itself
  run git-common-dir
  expects "$status" to_be 0
  expects "$output" to_match '/\.git$'
}

@test '`git-common-dir` should exit with code 1 and no output when not in a git repo' {
  # Create a temporary directory that is not a git repository
  temp_dir=$(mktemp -d)

  # Run git-common-dir in the non-git directory
  run bash -c "cd '$temp_dir' && git-common-dir"

  # Clean up
  rm -rf "$temp_dir"

  # Verify exit code 1 and no output
  expects "$status" to_be 1
  expects "$output" to_be ""
}
