#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`git-stash-rename --help` should show help message' {
  run git-stash-rename --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^git-stash-rename - '
}

@test '`git-stash-rename -h` should show help message' {
  run git-stash-rename -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^git-stash-rename - '
}

@test '`git-stash-rename` without arguments should show error' {
  run git-stash-rename
  expects "$status" to_be 1
  expects "$output" to_match 'Required an arguments'
}

@test '`git-stash-rename` should rename stash@{0} with single argument' {
  # Create a temporary git repository
  temp_dir=$(mktemp -d)
  cd "$temp_dir"
  git init
  git config user.email "test@example.com"
  git config user.name "Test User"

  # Create a test file and commit
  echo "test" > test.txt
  git add test.txt
  git commit -m "Initial commit"

  # Create a stash
  echo "modified" > test.txt
  git stash push -m "Original message"

  # Rename the stash
  run git-stash-rename "New message"
  expects "$status" to_be 0
  expects "$output" to_match 'Renamed stash@\{0\}'
  expects "$output" to_match 'to: New message'

  # Verify the stash was renamed
  run git stash list
  expects "$output" to_match 'New message'

  # Cleanup
  cd -
  rm -rf "$temp_dir"
}

@test '`git-stash-rename` should rename specific stash with index argument' {
  # Create a temporary git repository
  temp_dir=$(mktemp -d)
  cd "$temp_dir"
  git init
  git config user.email "test@example.com"
  git config user.name "Test User"

  # Create a test file and commit
  echo "test" > test.txt
  git add test.txt
  git commit -m "Initial commit"

  # Create two stashes
  echo "modified1" > test.txt
  git stash push -m "First stash"
  echo "modified2" > test.txt
  git stash push -m "Second stash"

  # Rename stash@{1} (the first one)
  run git-stash-rename 1 "Renamed first stash"
  expects "$status" to_be 0
  expects "$output" to_match 'Renamed stash@\{1\}'
  expects "$output" to_match 'to: Renamed first stash'

  # Verify the stash was renamed
  run git stash list
  expects "$output" to_match 'Renamed first stash'

  # Cleanup
  cd -
  rm -rf "$temp_dir"
}

@test '`git-stash-rename` should error when not in a git repository' {
  # Create a temporary directory that is not a git repository
  temp_dir=$(mktemp -d)

  # Run git-stash-rename in the non-git directory
  run bash -c "cd '$temp_dir' && git-stash-rename 'test message'"

  # Cleanup
  rm -rf "$temp_dir"

  # Verify exit code is non-zero
  expects "$status" not to_be 0
}
