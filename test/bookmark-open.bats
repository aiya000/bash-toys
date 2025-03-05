#!/usr/bin/env bats

setup () {
  export BASH_TOYS_INTERACTIVE_FILTER='head -n 1'
  export BASH_TOYS_BOOKMARK_OPEN_BOOKMARKS='(Example=https://example.com)|(GitHub=https://github.com)'
}

@test '`bookmark-open --help` should show help message' {
  run bin/bookmark-open --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^bookmark-open - '
  expects "${lines[1]}" to_equal ''
  expects "${lines[3]}" to_equal 'Usage:'
  expects "${lines[6]}" to_equal 'Options:'
}

@test '`bookmark-open` should open the first bookmark' {
  XDG_OPEN_OUTPUT="$(mktemp)"
  export XDG_OPEN_OUTPUT
  function xdg-open () {
    echo "$1" >> "$XDG_OPEN_OUTPUT"
  }
  export -f xdg-open

  run bin/bookmark-open
  expects "$status" to_be 0
  expects "$(cat "$XDG_OPEN_OUTPUT")" to_equal 'https://example.com'
}
