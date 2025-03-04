#!/usr/bin/env bats

setup () {
  export BASH_TOYS_INTERACTIVE_FILTER='head -n 1'
  export BASH_TOYS_BOOKMARK_OPEN_BOOKMARKS='(Example=https://example.com)|(GitHub=https://github.com)'
}

@test '`bookmark-open --help` should show help message' {
  run bin/bookmark-open --help
  [[ $status -eq 0 ]]
  [[ "${lines[0]}" == "bookmark-open - Opens a selected bookmark in the default browser" ]]
  [[ "${lines[2]}" == "Usage:" ]]
  [[ "${lines[5]}" == "Options:" ]]
}

@test '`bookmark-open` should open the first bookmark' {
  XDG_OPEN_OUTPUT="$(mktemp)"
  export XDG_OPEN_OUTPUT
  function xdg-open () {
    echo "$1" >> "$XDG_OPEN_OUTPUT"
  }
  export -f xdg-open

  run bin/bookmark-open
  [[ $status -eq 0 ]]
  [[ "$(cat "$XDG_OPEN_OUTPUT")" == 'https://example.com' ]]
}
