#!/usr/bin/env bats

# shellcheck disable=SC2030,SC2031

setup () {
  export GH_OUTPUT
  GH_OUTPUT="$(mktemp)"
}

@test '`gh-issue-view-select --help` should show help message' {
  run bin/gh-issue-view-select --help
  [[ $status -eq 0 ]]
  [[ ${lines[0]} == 'gh-issue-view-select - Show GitHub issues in interactive filter and open selected issue' ]]
  [[ ${lines[2]} == 'Usage:' ]]
  [[ ${lines[5]} == 'Options:' ]]
}

@test '`gh-issue-view-select` should handle empty selection' {
  export BASH_TOYS_INTERACTIVE_FILTER=true
  bin/gh-issue-view-select
}

@test '`gh-issue-view-select` should extract and view issue number' {
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

  # Mock interactive filter
  function test_filter () {
    head -n 1
  }
  export -f test_filter
  export BASH_TOYS_INTERACTIVE_FILTER=test_filter

  bin/gh-issue-view-select
  [[ "$(cat "$GH_OUTPUT")" == 'Issue #42 content' ]]
}
