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
  # Check that a date-hour directory was created
  expects "$(find "$BASH_TOYS_DUSTBOX_DIR" -type d -mindepth 1 | wc -l)" to_be 1
  # Check that one file exists in the dustbox
  expects "$(find "$BASH_TOYS_DUSTBOX_DIR" -type f | wc -l)" to_be 1
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
  # Check that dustbox is now empty (no files)
  expects "$(find "$BASH_TOYS_DUSTBOX_DIR" -type f | wc -l)" to_be 0
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

  # Get the dustbox filename for file1 (search for file1 specifically)
  dustbox_file=$(find "$BASH_TOYS_DUSTBOX_DIR" -type f -name "*test-file1*" | head -1 | xargs basename)

  # Restore specific file by filename
  run rm-dust --restore "$dustbox_file"
  expects "$status" to_be 0
  expects "$test_file1" to_be_a_file
  expects "$test_file2" not to_be_a_file
  # Check that one file still remains in dustbox
  expects "$(find "$BASH_TOYS_DUSTBOX_DIR" -type f | wc -l)" to_be 1
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
  expects "$test_dir" not to_be_a_dir
  # Check that a date-hour directory was created
  expects "$(find "$BASH_TOYS_DUSTBOX_DIR" -maxdepth 1 -type d -mindepth 1 | wc -l)" to_be 1
  # Check that one directory exists in the dustbox (the moved directory)
  date_hour_dir=$(find "$BASH_TOYS_DUSTBOX_DIR" -maxdepth 1 -type d -mindepth 1 | head -1)
  expects "$(find "$date_hour_dir" -maxdepth 1 -type d -mindepth 1 | wc -l)" to_be 1
  # Check that the directory contents are preserved
  moved_dir=$(find "$date_hour_dir" -maxdepth 1 -type d -mindepth 1 | head -1)
  expects "$moved_dir/file1.txt" to_be_a_file
  expects "$moved_dir/file2.txt" to_be_a_file
  expects "$moved_dir/subdir/subfile.txt" to_be_a_file
}

@test '`rm-dust --restore` should restore directory from dustbox' {
  test_dir="$BATS_TEST_DIRNAME/../tmp/test-dir-restore-$$"
  mkdir -p "$test_dir"
  echo "file content" > "$test_dir/file.txt"

  # Move to dustbox
  rm-dust "$test_dir"
  expects "$test_dir" not to_be_a_dir

  # Restore from dustbox
  run rm-dust --restore
  expects "$status" to_be 0
  expects "$test_dir" to_be_a_dir
  expects "$test_dir/file.txt" to_be_a_file
  expects "$(cat "$test_dir/file.txt")" to_equal 'file content'
  # Check that dustbox is now empty (no directories in date-hour dir)
  date_hour_dir=$(find "$BASH_TOYS_DUSTBOX_DIR" -maxdepth 1 -type d -mindepth 1 | head -1)
  if [[ -d "$date_hour_dir" ]] ; then
    expects "$(find "$date_hour_dir" -maxdepth 1 -mindepth 1 | wc -l)" to_be 0
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
  expects "$test_dir1" not to_be_a_dir
  expects "$test_dir2" not to_be_a_dir

  # Get the dustbox dirname for dir1 (search for dir1 specifically)
  dustbox_dir=$(find "$BASH_TOYS_DUSTBOX_DIR" -type d -name "*test-dir1*" | head -1 | xargs basename)

  # Restore specific directory by dirname
  run rm-dust --restore "$dustbox_dir"
  expects "$status" to_be 0
  expects "$test_dir1" to_be_a_dir
  expects "$test_dir2" not to_be_a_dir
  expects "$test_dir1/file1.txt" to_be_a_file
  # Check that one directory still remains in dustbox
  date_hour_dir=$(find "$BASH_TOYS_DUSTBOX_DIR" -maxdepth 1 -type d -mindepth 1 | head -1)
  expects "$(find "$date_hour_dir" -maxdepth 1 -type d -mindepth 1 | wc -l)" to_be 1
}

@test '`rm-dust --restore` should handle both files and directories' {
  test_file="$BATS_TEST_DIRNAME/../tmp/test-mixed-file-$$.txt"
  test_dir="$BATS_TEST_DIRNAME/../tmp/test-mixed-dir-$$"
  echo "file content" > "$test_file"
  mkdir -p "$test_dir"
  echo "dir file content" > "$test_dir/file.txt"

  # Move both to dustbox
  rm-dust "$test_file" "$test_dir"
  expects "$test_file" not to_be_a_file
  expects "$test_dir" not to_be_a_dir

  # Restore both from dustbox (using BASH_TOYS_INTERACTIVE_FILTER='head -2')
  export BASH_TOYS_INTERACTIVE_FILTER='head -2'
  run rm-dust --restore
  expects "$status" to_be 0
  expects "$test_file" to_be_a_file
  expects "$test_dir" to_be_a_dir
  expects "$(cat "$test_file")" to_equal 'file content'
  expects "$(cat "$test_dir/file.txt")" to_equal 'dir file content'
}

@test '`rm-dust` should handle dotfiles correctly' {
  test_file="$BATS_TEST_DIRNAME/../tmp/.bashrc-$$"
  echo "# bashrc content" > "$test_file"

  run rm-dust "$test_file"
  expects "$status" to_be 0
  expects "$test_file" not to_be_a_file
  # Check that one file exists in the dustbox
  expects "$(find "$BASH_TOYS_DUSTBOX_DIR" -type f | wc -l)" to_be 1

  # Restore the dotfile
  run rm-dust --restore
  expects "$status" to_be 0
  expects "$test_file" to_be_a_file
  expects "$(cat "$test_file")" to_equal '# bashrc content'
}

@test '`rm-dust` should handle files with multiple dots correctly' {
  test_file="$BATS_TEST_DIRNAME/../tmp/archive.tar.gz-$$"
  echo "archive content" > "$test_file"

  run rm-dust "$test_file"
  expects "$status" to_be 0
  expects "$test_file" not to_be_a_file
  # Check that one file exists in the dustbox
  expects "$(find "$BASH_TOYS_DUSTBOX_DIR" -type f | wc -l)" to_be 1

  # Restore the file
  run rm-dust --restore
  expects "$status" to_be 0
  expects "$test_file" to_be_a_file
  expects "$(cat "$test_file")" to_equal 'archive content'
}

@test '`rm-dust` should handle directories with dots correctly' {
  test_dir="$BATS_TEST_DIRNAME/../tmp/.config-$$"
  mkdir -p "$test_dir"
  echo "config content" > "$test_dir/config.txt"

  run rm-dust "$test_dir"
  expects "$status" to_be 0
  expects "$test_dir" not to_be_a_dir
  # Check that one directory exists in the dustbox
  date_hour_dir=$(find "$BASH_TOYS_DUSTBOX_DIR" -maxdepth 1 -type d -mindepth 1 | head -1)
  expects "$(find "$date_hour_dir" -maxdepth 1 -type d -mindepth 1 | wc -l)" to_be 1

  # Restore the directory
  run rm-dust --restore
  expects "$status" to_be 0
  expects "$test_dir" to_be_a_dir
  expects "$test_dir/config.txt" to_be_a_file
  expects "$(cat "$test_dir/config.txt")" to_equal 'config content'
}

@test '`rm-dust --restore --keep` should copy file from dustbox without removing it' {
  test_file="$BATS_TEST_DIRNAME/../tmp/test-file-keep-$$.txt"
  echo "keep content" > "$test_file"

  # Move to dustbox
  rm-dust "$test_file"
  expects "$test_file" not to_be_a_file

  # Restore with --keep (should copy, not move)
  run rm-dust --restore --keep
  expects "$status" to_be 0
  expects "$test_file" to_be_a_file
  expects "$(cat "$test_file")" to_equal 'keep content'
  # File should still exist in dustbox
  expects "$(find "$BASH_TOYS_DUSTBOX_DIR" -type f | wc -l)" to_be 1
}

@test '`rm-dust --restore --keep FILENAME` should copy specific file without removing it' {
  test_file="$BATS_TEST_DIRNAME/../tmp/test-file-keep-direct-$$.txt"
  echo "keep direct content" > "$test_file"

  # Move to dustbox
  rm-dust "$test_file"
  expects "$test_file" not to_be_a_file

  # Get the dustbox filename
  dustbox_file=$(find "$BASH_TOYS_DUSTBOX_DIR" -type f | head -1 | xargs basename)

  # Restore specific file with --keep
  run rm-dust --restore --keep "$dustbox_file"
  expects "$status" to_be 0
  expects "$test_file" to_be_a_file
  expects "$(cat "$test_file")" to_equal 'keep direct content'
  # File should still exist in dustbox
  expects "$(find "$BASH_TOYS_DUSTBOX_DIR" -type f | wc -l)" to_be 1
}

@test '`rm-dust --restore --keep` should copy directory from dustbox without removing it' {
  test_dir="$BATS_TEST_DIRNAME/../tmp/test-dir-keep-$$"
  mkdir -p "$test_dir"
  echo "dir keep content" > "$test_dir/file.txt"

  # Move to dustbox
  rm-dust "$test_dir"
  expects "$test_dir" not to_be_a_dir

  # Restore with --keep
  run rm-dust --restore --keep
  expects "$status" to_be 0
  expects "$test_dir" to_be_a_dir
  expects "$test_dir/file.txt" to_be_a_file
  expects "$(cat "$test_dir/file.txt")" to_equal 'dir keep content'
  # Directory should still exist in dustbox
  date_hour_dir=$(find "$BASH_TOYS_DUSTBOX_DIR" -maxdepth 1 -type d -mindepth 1 | head -1)
  expects "$(find "$date_hour_dir" -maxdepth 1 -type d -mindepth 1 | wc -l)" to_be 1
}

@test '`rm-dust --keep` without --restore should fail with error' {
  run rm-dust --keep file.txt
  expects "$status" to_be 1
  expects "$output" to_contain '--keep requires --restore'
}

@test '`rm-dust --help` should show --keep option' {
  run rm-dust --help
  expects "$status" to_be 0
  expects "$output" to_match '--keep'
}

@test '`BASH_TOYS_RESTORE_KEEP=1` should make --keep the default behavior' {
  test_file="$BATS_TEST_DIRNAME/../tmp/test-file-env-keep-$$.txt"
  echo "env keep content" > "$test_file"

  # Move to dustbox
  rm-dust "$test_file"
  expects "$test_file" not to_be_a_file

  # Restore with BASH_TOYS_RESTORE_KEEP=1 (should behave like --keep)
  BASH_TOYS_RESTORE_KEEP=1 run rm-dust --restore
  expects "$status" to_be 0
  expects "$test_file" to_be_a_file
  expects "$(cat "$test_file")" to_equal 'env keep content'
  # File should still exist in dustbox
  expects "$(find "$BASH_TOYS_DUSTBOX_DIR" -type f | wc -l)" to_be 1
}

@test '`BASH_TOYS_RESTORE_KEEP=0` should make --keep not the default (move behavior)' {
  test_file="$BATS_TEST_DIRNAME/../tmp/test-file-env-nokeep-$$.txt"
  echo "env nokeep content" > "$test_file"

  # Move to dustbox
  rm-dust "$test_file"
  expects "$test_file" not to_be_a_file

  # Restore with BASH_TOYS_RESTORE_KEEP=0 (should behave like normal mv)
  BASH_TOYS_RESTORE_KEEP=0 run rm-dust --restore
  expects "$status" to_be 0
  expects "$test_file" to_be_a_file
  expects "$(cat "$test_file")" to_equal 'env nokeep content'
  # File should NOT exist in dustbox anymore
  expects "$(find "$BASH_TOYS_DUSTBOX_DIR" -type f | wc -l)" to_be 0
}

@test '`BASH_TOYS_RESTORE_KEEP=1` with --keep should still keep (--keep takes precedence)' {
  test_file="$BATS_TEST_DIRNAME/../tmp/test-file-env-keep-flag-$$.txt"
  echo "env keep flag content" > "$test_file"

  # Move to dustbox
  rm-dust "$test_file"
  expects "$test_file" not to_be_a_file

  # Restore with BASH_TOYS_RESTORE_KEEP=1 and --keep (both agree)
  BASH_TOYS_RESTORE_KEEP=1 run rm-dust --restore --keep
  expects "$status" to_be 0
  expects "$test_file" to_be_a_file
  expects "$(cat "$test_file")" to_equal 'env keep flag content'
  # File should still exist in dustbox
  expects "$(find "$BASH_TOYS_DUSTBOX_DIR" -type f | wc -l)" to_be 1
}

@test '`BASH_TOYS_RESTORE_KEEP=0` with --keep should keep with warning (--keep takes precedence)' {
  test_file="$BATS_TEST_DIRNAME/../tmp/test-file-env-nokeep-flag-$$.txt"
  echo "env nokeep flag content" > "$test_file"

  # Move to dustbox
  rm-dust "$test_file"
  expects "$test_file" not to_be_a_file

  # Restore with BASH_TOYS_RESTORE_KEEP=0 and --keep (conflict: --keep wins but warns)
  BASH_TOYS_RESTORE_KEEP=0 run rm-dust --restore --keep
  expects "$status" to_be 0
  expects "$output" to_contain 'Warning: --keep specified but BASH_TOYS_RESTORE_KEEP=0'
  expects "$test_file" to_be_a_file
  expects "$(cat "$test_file")" to_equal 'env nokeep flag content'
  # File should still exist in dustbox (--keep won)
  expects "$(find "$BASH_TOYS_DUSTBOX_DIR" -type f | wc -l)" to_be 1
}

@test '`rm-dust` should handle directory names like "my.app.v2" correctly' {
  test_dir="$BATS_TEST_DIRNAME/../tmp/my.app.v2-$$"
  mkdir -p "$test_dir"
  echo "app content" > "$test_dir/app.txt"

  run rm-dust "$test_dir"
  expects "$status" to_be 0
  expects "$test_dir" not to_be_a_dir

  # Restore the directory
  run rm-dust --restore
  expects "$status" to_be 0
  expects "$test_dir" to_be_a_dir
  expects "$test_dir/app.txt" to_be_a_file
  expects "$(cat "$test_dir/app.txt")" to_equal 'app content'
}

@test '`rm-dust` should handle filenames with plus signs like "C++.txt" correctly' {
  test_file="$BATS_TEST_DIRNAME/../tmp/test-file-plus-C++-$$.txt"
  echo "plus sign content" > "$test_file"

  # Move the file with plus signs in its name to the dustbox
  run rm-dust "$test_file"
  expects "$status" to_be 0
  expects "$test_file" not to_be_a_file

  # Check that + in the filename is encoded as ++ in the dustbox
  dustbox_file=$(find "$BASH_TOYS_DUSTBOX_DIR" -name '*C++++*')
  expects "$dustbox_file" to_be_defined

  # Restore the file
  run rm-dust --restore
  expects "$status" to_be 0
  expects "$test_file" to_be_a_file
  expects "$(cat "$test_file")" to_equal 'plus sign content'
}
