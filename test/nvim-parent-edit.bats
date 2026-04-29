#!/usr/bin/env bats

# shellcheck disable=SC2016

export NVIM_PARENT_ADDRESS="/tmp/nvim-parent-edit-bats-test.sock"

# shellcheck disable=SC1091
source ./source-all.sh

setup() {
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
  MOCK_DIR=$(mktemp -d)
  printf '#!/bin/bash\nexit 0\n' > "$MOCK_DIR/nvim"
  chmod +x "$MOCK_DIR/nvim"
  export PATH="$MOCK_DIR:$PATH"
  export NVIM_PARENT_ADDRESS="/tmp/nvim-parent-edit-bats-test.sock"
}

teardown() {
  rm -rf "$MOCK_DIR"
}

@test '`nvim-parent-edit --help` should show help message' {
  run nvim-parent-edit --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^nvim-parent-edit - '
  expects "${lines[1]}" to_equal 'Usage:'
}

@test '`nvim-parent-edit -h` should show help message' {
  run nvim-parent-edit -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^nvim-parent-edit - '
}

@test '`nvim-parent-edit` with no arguments should exit 1' {
  run nvim-parent-edit
  expects "$status" to_be 1
  expects "$output" to_contain 'Usage:'
}

@test '`nvim-parent-edit` with NVIM_PARENT_ADDRESS unset should exit 1' {
  local source_file="$BATS_TEST_DIRNAME/../sources/nvim-parent-edit.sh"
  local mock_dir="$MOCK_DIR"
  run bash -c "
    PATH=\"$mock_dir:\$PATH\"
    NVIM_PARENT_ADDRESS='/tmp/nvim-parent-edit-bats-test.sock'
    source \"$source_file\" 2>/dev/null
    unset NVIM_PARENT_ADDRESS
    nvim-parent-edit tabnew /tmp/nvim-parent-edit-nonexistent-bats.txt
  "
  expects "$status" to_be 1
  expects "$output" to_contain 'NVIM_PARENT_ADDRESS'
}

@test '`nvim-parent-edit` with unknown open_method should exit 1' {
  run nvim-parent-edit unknown-method /tmp/nvim-parent-edit-nonexistent-bats.txt
  expects "$status" to_be 1
  expects "$output" to_contain 'Unknown open method'
}

@test '`nvim-parent-edit tabnew` with existing file should exit 0' {
  local tmpfile
  tmpfile=$(mktemp)
  run nvim-parent-edit tabnew "$tmpfile"
  rm -f "$tmpfile"
  expects "$status" to_be 0
  expects "$output" to_contain '✓ Opened'
}

@test '`nvim-parent-edit tabnew` with non-existent file should exit 0' {
  run nvim-parent-edit tabnew /tmp/nvim-parent-edit-nonexistent-bats.txt
  expects "$status" to_be 0
  expects "$output" to_contain '✓ Opened'
}

@test '`nvim-parent-edit split` with existing file should exit 0' {
  local tmpfile
  tmpfile=$(mktemp)
  run nvim-parent-edit split "$tmpfile"
  rm -f "$tmpfile"
  expects "$status" to_be 0
  expects "$output" to_contain '✓ Opened'
}

@test '`nvim-parent-edit split` with non-existent file should exit 0' {
  run nvim-parent-edit split /tmp/nvim-parent-edit-nonexistent-bats.txt
  expects "$status" to_be 0
  expects "$output" to_contain '✓ Opened'
}

@test '`nvim-parent-edit vsplit` with existing file should exit 0' {
  local tmpfile
  tmpfile=$(mktemp)
  run nvim-parent-edit vsplit "$tmpfile"
  rm -f "$tmpfile"
  expects "$status" to_be 0
  expects "$output" to_contain '✓ Opened'
}

@test '`nvim-parent-edit vsplit` with non-existent file should exit 0' {
  run nvim-parent-edit vsplit /tmp/nvim-parent-edit-nonexistent-bats.txt
  expects "$status" to_be 0
  expects "$output" to_contain '✓ Opened'
}

@test '`nvim-parent-tabnew` should open in new tab' {
  run nvim-parent-tabnew /tmp/nvim-parent-edit-nonexistent-bats.txt
  expects "$status" to_be 0
  expects "$output" to_contain '✓ Opened'
}

@test '`nvim-parent-split` should open in horizontal split' {
  run nvim-parent-split /tmp/nvim-parent-edit-nonexistent-bats.txt
  expects "$status" to_be 0
  expects "$output" to_contain '✓ Opened'
}

@test '`nvim-parent-vsplit` should open in vertical split' {
  run nvim-parent-vsplit /tmp/nvim-parent-edit-nonexistent-bats.txt
  expects "$status" to_be 0
  expects "$output" to_contain '✓ Opened'
}
