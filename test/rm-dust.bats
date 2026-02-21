#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
  # Use a temporary dustbox for testing
  export BASH_TOYS_DUSTBOX_DIR="$BATS_TEST_DIRNAME/../tmp/test-dustbox-$$"
  export BASH_TOYS_INTERACTIVE_FILTER='head -1'
  mkdir -p "$BASH_TOYS_DUSTBOX_DIR"
}

teardown() {
  rm -rf "$BASH_TOYS_DUSTBOX_DIR"
}

@test '`rm-dust --help` should show help message with --restore option' {
  run rm-dust --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^rm-dust - '
  expects "$output" to_match '--restore'
}

@test '`rm-dust` should move file to dustbox' {
  test_file="$BATS_TEST_DIRNAME/../tmp/test-file-$$.txt"
  echo "test content" > "$test_file"
  
  run rm-dust "$test_file"
  expects "$status" to_be 0
  expects "$test_file" not to_be_a_file
  expects "$(ls -1 "$BASH_TOYS_DUSTBOX_DIR" | wc -l)" to_be 1
}

@test '`rm-dust --restore` should restore file from dustbox' {
  test_file="$BATS_TEST_DIRNAME/../tmp/test-file-restore-$$.txt"
  echo "test content" > "$test_file"
  
  # Move to dustbox
  rm-dust "$test_file"
  expects "$test_file" not to_be_a_file
  
  # Restore from dustbox
  run rm-dust --restore
  expects "$status" to_be 0
  expects "$test_file" to_be_a_file
  expects "$(cat "$test_file")" to_equal 'test content'
  expects "$(ls -1 "$BASH_TOYS_DUSTBOX_DIR" | wc -l)" to_be 0
}

@test '`rm-dust --restore` with empty dustbox should print message' {
  run rm-dust --restore
  expects "$status" to_be 0
  expects "$output" to_equal 'Dustbox is empty'
}

@test '`rm-dust --restore FILENAME` should restore specific file' {
  test_file1="$BATS_TEST_DIRNAME/../tmp/test-file1-$$.txt"
  test_file2="$BATS_TEST_DIRNAME/../tmp/test-file2-$$.txt"
  echo "content1" > "$test_file1"
  echo "content2" > "$test_file2"
  
  # Move both to dustbox
  rm-dust "$test_file1" "$test_file2"
  expects "$test_file1" not to_be_a_file
  expects "$test_file2" not to_be_a_file
  
  # Get the dustbox filename for file1
  dustbox_file=$(ls -1 "$BASH_TOYS_DUSTBOX_DIR" | head -1)
  
  # Restore specific file
  run rm-dust --restore "$dustbox_file"
  expects "$status" to_be 0
  expects "$test_file1" to_be_a_file
  expects "$test_file2" not to_be_a_file
  expects "$(ls -1 "$BASH_TOYS_DUSTBOX_DIR" | wc -l)" to_be 1
}
