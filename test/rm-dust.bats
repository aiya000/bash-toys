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
  [[ ! -f "$test_file" ]]
  # Check that a date-hour directory was created
  [[ $(find "$BASH_TOYS_DUSTBOX_DIR" -type d -mindepth 1 | wc -l) -eq 1 ]]
  # Check that one file exists in the dustbox
  [[ $(find "$BASH_TOYS_DUSTBOX_DIR" -type f | wc -l) -eq 1 ]]
}

@test '`rm-dust --restore` should restore file from dustbox' {
  test_file="$BATS_TEST_DIRNAME/../tmp/test-file-restore-$$.txt"
  echo "test content" > "$test_file"

  # Move to dustbox
  rm-dust "$test_file"
  [[ ! -f "$test_file" ]]

  # Restore from dustbox
  run rm-dust --restore
  expects "$status" to_be 0
  [[ -f "$test_file" ]]
  [[ "$(cat "$test_file")" == "test content" ]]
  # Check that dustbox is now empty (no files)
  [[ $(find "$BASH_TOYS_DUSTBOX_DIR" -type f | wc -l) -eq 0 ]]
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
  [[ ! -f "$test_file1" ]]
  [[ ! -f "$test_file2" ]]

  # Get the dustbox filename for file1 (search for file1 specifically)
  dustbox_file=$(find "$BASH_TOYS_DUSTBOX_DIR" -type f -name "*test-file1*" | head -1 | xargs basename)

  # Restore specific file by filename
  run rm-dust --restore "$dustbox_file"
  expects "$status" to_be 0
  [[ -f "$test_file1" ]]
  [[ ! -f "$test_file2" ]]
  # Check that one file still remains in dustbox
  [[ $(find "$BASH_TOYS_DUSTBOX_DIR" -type f | wc -l) -eq 1 ]]
}

@test '`rm-dust` should move directory to dustbox' {
  test_dir="$BATS_TEST_DIRNAME/../tmp/test-dir-$$"
  mkdir -p "$test_dir"
  echo "file1 content" > "$test_dir/file1.txt"
  echo "file2 content" > "$test_dir/file2.txt"
  mkdir -p "$test_dir/subdir"
  echo "subfile content" > "$test_dir/subdir/subfile.txt"

  run rm-dust "$test_dir"
  expects "$status" to_be 0
  [[ ! -d "$test_dir" ]]
  # Check that a date-hour directory was created
  [[ $(find "$BASH_TOYS_DUSTBOX_DIR" -maxdepth 1 -type d -mindepth 1 | wc -l) -eq 1 ]]
  # Check that one directory exists in the dustbox (the moved directory)
  date_hour_dir=$(find "$BASH_TOYS_DUSTBOX_DIR" -maxdepth 1 -type d -mindepth 1 | head -1)
  [[ $(find "$date_hour_dir" -maxdepth 1 -type d -mindepth 1 | wc -l) -eq 1 ]]
  # Check that the directory contents are preserved
  moved_dir=$(find "$date_hour_dir" -maxdepth 1 -type d -mindepth 1 | head -1)
  [[ -f "$moved_dir/file1.txt" ]]
  [[ -f "$moved_dir/file2.txt" ]]
  [[ -f "$moved_dir/subdir/subfile.txt" ]]
}

@test '`rm-dust --restore` should restore directory from dustbox' {
  test_dir="$BATS_TEST_DIRNAME/../tmp/test-dir-restore-$$"
  mkdir -p "$test_dir"
  echo "file content" > "$test_dir/file.txt"

  # Move to dustbox
  rm-dust "$test_dir"
  [[ ! -d "$test_dir" ]]

  # Restore from dustbox
  run rm-dust --restore
  expects "$status" to_be 0
  [[ -d "$test_dir" ]]
  [[ -f "$test_dir/file.txt" ]]
  [[ "$(cat "$test_dir/file.txt")" == "file content" ]]
  # Check that dustbox is now empty (no directories in date-hour dir)
  date_hour_dir=$(find "$BASH_TOYS_DUSTBOX_DIR" -maxdepth 1 -type d -mindepth 1 | head -1)
  if [[ -d "$date_hour_dir" ]] ; then
    [[ $(find "$date_hour_dir" -maxdepth 1 -mindepth 1 | wc -l) -eq 0 ]]
  fi
}

@test '`rm-dust --restore DIRNAME` should restore specific directory' {
  test_dir1="$BATS_TEST_DIRNAME/../tmp/test-dir1-$$"
  test_dir2="$BATS_TEST_DIRNAME/../tmp/test-dir2-$$"
  mkdir -p "$test_dir1"
  mkdir -p "$test_dir2"
  echo "content1" > "$test_dir1/file1.txt"
  echo "content2" > "$test_dir2/file2.txt"

  # Move both to dustbox
  rm-dust "$test_dir1" "$test_dir2"
  [[ ! -d "$test_dir1" ]]
  [[ ! -d "$test_dir2" ]]

  # Get the dustbox dirname for dir1 (search for dir1 specifically)
  dustbox_dir=$(find "$BASH_TOYS_DUSTBOX_DIR" -type d -name "*test-dir1*" | head -1 | xargs basename)

  # Restore specific directory by dirname
  run rm-dust --restore "$dustbox_dir"
  expects "$status" to_be 0
  [[ -d "$test_dir1" ]]
  [[ ! -d "$test_dir2" ]]
  [[ -f "$test_dir1/file1.txt" ]]
  # Check that one directory still remains in dustbox
  date_hour_dir=$(find "$BASH_TOYS_DUSTBOX_DIR" -maxdepth 1 -type d -mindepth 1 | head -1)
  [[ $(find "$date_hour_dir" -maxdepth 1 -type d -mindepth 1 | wc -l) -eq 1 ]]
}

@test '`rm-dust --restore` should handle both files and directories' {
  test_file="$BATS_TEST_DIRNAME/../tmp/test-mixed-file-$$.txt"
  test_dir="$BATS_TEST_DIRNAME/../tmp/test-mixed-dir-$$"
  echo "file content" > "$test_file"
  mkdir -p "$test_dir"
  echo "dir file content" > "$test_dir/file.txt"

  # Move both to dustbox
  rm-dust "$test_file" "$test_dir"
  [[ ! -f "$test_file" ]]
  [[ ! -d "$test_dir" ]]

  # Restore both from dustbox (using BASH_TOYS_INTERACTIVE_FILTER='head -2')
  export BASH_TOYS_INTERACTIVE_FILTER='head -2'
  run rm-dust --restore
  expects "$status" to_be 0
  [[ -f "$test_file" ]]
  [[ -d "$test_dir" ]]
  [[ "$(cat "$test_file")" == "file content" ]]
  [[ "$(cat "$test_dir/file.txt")" == "dir file content" ]]
}
