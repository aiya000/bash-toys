#!/usr/bin/env bats

# shellcheck disable=SC2016,SC2181

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
  [ "$status" -eq 0 ]
  [ "$output" == "a"$'\n'"b" ]
}

@test '`take-until-empty < file_contains_empty_line` (using stdin/pipe) should take lines until an empty line appears' {
  result=$(take-until-empty < "$file_contains_empty_line")
  [ "$?" -eq 0 ]
  [ "$result" == "a"$'\n'"b" ]
}

@test '`take-until-empty file_contains_empty_line` should take all lines if no empty line appears' {
  run take-until-empty "$file_does_not_contain_empty_line"
  [ "$status" -eq 0 ]
  [ "$output" == "a"$'\n'"b"$'\n'"c" ]
}
