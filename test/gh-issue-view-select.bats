#!/usr/bin/env bats

setup () {
  export GH_OUTPUT
  GH_OUTPUT="$(mktemp)"
}

@test '`gh-issue-view-select --help` should show help message with usage' {
  run bin/gh-issue-view-select --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^gh-issue-view-select - '
  expects "${lines[1]}" to_equal 'Usage:'
}

@test '`gh-issue-view-select` should display selected issue content' {
  # Mock gh command
  function gh () {
    if [[ $1 == 'issue' && $2 == 'list' ]] ; then
      echo '#42  Issue title  enhancement  2024-03-05'
      return 0
    fi
    if [[ $1 == 'issue' && $2 == 'view' && $3 == '42' ]] ; then
      echo "Issue #42 content" >> "$GH_OUTPUT"
      return 0
    fi
    return 1
  }
  export -f gh

  # Mock filter
  function test_filter () {
    head -n 1
  }
  export -f test_filter
  export BASH_TOYS_INTERACTIVE_FILTER=test_filter

  run bin/gh-issue-view-select
  expects "$status" to_be 0
  expects "$(cat "$GH_OUTPUT")" to_equal 'Issue #42 content'
}
