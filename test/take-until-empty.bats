#!/usr/bin/env bats

# shellcheck disable=SC2016

file_contains_empty_line="$BATS_TMPDIR/file_contains_empty_line"
file_does_not_contain_empty_line="$BATS_TMPDIR/file_does_not_contain_empty_line"

setup () {
  touch "$file_contains_empty_line"
  {
    echo a
    echo b
    echo ''
    echo c
  } >> "$file_contains_empty_line"

  touch "$file_does_not_contain_empty_line"
  {
    echo a
    echo b
    echo c
  } >> "$file_does_not_contain_empty_line"
}

teardown () {
  rm -f "$file_contains_empty_line"
  rm -f "$file_does_not_contain_empty_line"
}

@test '`take-until-empty file_contains_empty_line` should take lines until an empty line appears' {
  run take-until-empty "$file_contains_empty_line"
  [ "$output" == "a"$'\n'"b" ]
}

@test '`cat file_contains_empty_line | take-until-empty` should take lines until an empty line appears' {
  run cat "$file_contains_empty_line" | take-until-empty
  [ "$output" == "a"$'\n'"b" ]
}

@test '`take-until-empty file_contains_empty_line` should take all lines if no empty line appears' {
  run take-until-empty "$file_does_not_contain_empty_line"
  [ "$output" == "a"$'\n'"b"$'\n'"c" ]
}
