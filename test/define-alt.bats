#!/usr/bin/env bats

# shellcheck disable=SC2016

# shellcheck disable=SC1091
source ./source-all.sh

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`define-alt --help` should show help message' {
  run define-alt --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^define-alt - '
}

@test '`define-alt -h` should show help message' {
  run define-alt -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^define-alt - '
}

@test '`define-alt --export` should define and export a variable' {
  unset DEFINE_ALT_EXPORT_FLAG_TEST_VAR
  define-alt --export DEFINE_ALT_EXPORT_FLAG_TEST_VAR hello
  expects "$(bash -c 'echo "$DEFINE_ALT_EXPORT_FLAG_TEST_VAR"')" to_be hello
}

@test '`define-alt --export` should not overwrite an already-defined exported variable' {
  export DEFINE_ALT_EXPORT_FLAG_TEST_VAR=already
  define-alt --export DEFINE_ALT_EXPORT_FLAG_TEST_VAR hello
  expects "$(bash -c 'echo "$DEFINE_ALT_EXPORT_FLAG_TEST_VAR"')" to_be already
  unset DEFINE_ALT_EXPORT_FLAG_TEST_VAR
}

@test '`define-alt --export --empty-array` should define an empty array variable' {
  unset DEFINE_ALT_EXPORT_FLAG_TEST_ARR
  define-alt --export --empty-array DEFINE_ALT_EXPORT_FLAG_TEST_ARR
  expects "${#DEFINE_ALT_EXPORT_FLAG_TEST_ARR[@]}" to_be 0
  expects "$(bash -c 'echo "${#DEFINE_ALT_EXPORT_FLAG_TEST_ARR[@]}"')" to_be 0
}

@test '`define-alt --export` should define and export a multi-value array' {
  unset DEFINE_ALT_EXPORT_ARRAY_TEST
  define-alt --export DEFINE_ALT_EXPORT_ARRAY_TEST 1 2 3
  expects "${#DEFINE_ALT_EXPORT_ARRAY_TEST[@]}" to_be 3
}
