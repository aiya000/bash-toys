#!/usr/bin/env bats

# shellcheck disable=SC2016,SC2034

setup() {
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
  export BASH_TOYS_DUSTBOX_DIR="$BATS_TEST_DIRNAME/../tmp/test-dustbox-comp-$$"
  mkdir -p "$BASH_TOYS_DUSTBOX_DIR"
  # shellcheck source=../completions/rm-dust.bash
  source "$BATS_TEST_DIRNAME/../completions/rm-dust.bash"
}

teardown() {
  rm -rf "$BASH_TOYS_DUSTBOX_DIR"
}

# Helper: invoke _rm_dust_completion with the given COMP_WORDS
# The last element is taken as the current word (COMP_CWORD).
_invoke_completion() {
  COMP_WORDS=("$@")
  COMP_CWORD=$(( ${#COMP_WORDS[@]} - 1 ))
  COMPREPLY=()
  _rm_dust_completion
}

# ---------------------------------------------------------------------------
# --restore mode: filenames with spaces
# ---------------------------------------------------------------------------

@test 'completion --restore should include file with space in its name as a single entry' {
  local date_dir="$BASH_TOYS_DUSTBOX_DIR/2026-04-03-10"
  mkdir -p "$date_dir"
  touch "$date_dir/foo bar.txt"

  _invoke_completion rm-dust --restore ""

  local found=false
  local item
  for item in "${COMPREPLY[@]}" ; do
    [[ $item == 'foo bar.txt' ]] && found=true
  done
  expects "$found" to_be true
}

@test 'completion --restore should not split filename with space into multiple entries' {
  local date_dir="$BASH_TOYS_DUSTBOX_DIR/2026-04-03-10"
  mkdir -p "$date_dir"
  touch "$date_dir/foo bar.txt"

  _invoke_completion rm-dust --restore ""

  # Entries "foo" and "bar.txt" must NOT appear separately
  local found_foo=false found_bar=false
  local item
  for item in "${COMPREPLY[@]}" ; do
    [[ $item == 'foo' ]]     && found_foo=true
    [[ $item == 'bar.txt' ]] && found_bar=true
  done
  expects "$found_foo" to_be false
  expects "$found_bar" to_be false
}

@test 'completion --restore prefix filter works for filenames with spaces' {
  local date_dir="$BASH_TOYS_DUSTBOX_DIR/2026-04-03-10"
  mkdir -p "$date_dir"
  touch "$date_dir/foo bar.txt"
  touch "$date_dir/other.txt"

  _invoke_completion rm-dust --restore "foo"

  local found_foobar=false found_other=false
  local item
  for item in "${COMPREPLY[@]}" ; do
    [[ $item == 'foo bar.txt' ]] && found_foobar=true
    [[ $item == 'other.txt' ]]   && found_other=true
  done
  expects "$found_foobar" to_be true
  expects "$found_other"  to_be false
}

# ---------------------------------------------------------------------------
# non-restore mode: delegate to shell default (-o default)
# ---------------------------------------------------------------------------

@test 'completion should leave COMPREPLY empty for normal paths (delegates to -o default)' {
  # The complete registration uses -o default so the shell handles file/~ completion.
  # Our function must return an empty COMPREPLY to let that fallback fire.
  _invoke_completion rm-dust "~/"
  expects "${#COMPREPLY[@]}" to_be 0
}

@test 'completion should leave COMPREPLY empty for plain file prefix (delegates to -o default)' {
  _invoke_completion rm-dust "some/path"
  expects "${#COMPREPLY[@]}" to_be 0
}
