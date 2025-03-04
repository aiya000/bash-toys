#!/usr/bin/env bats

setup () {
  export GH_OUTPUT="$(mktemp)"
}

@test '`gh-issue-view-select --help` should show help message' {
  run bin/gh-issue-view-select --help
  [[ $status -eq 0 ]]
  [[ "${lines[0]}" == "gh-issue-view-select - Show GitHub issues in interactive filter and open selected issue" ]]
  [[ "${lines[2]}" == "Usage:" ]]
  [[ "${lines[5]}" == "Options:" ]]
}

@test 'Should show error when BASH_TOYS_INTERACTIVE_FILTER is not set' {
  unset BASH_TOYS_INTERACTIVE_FILTER
  run bin/gh-issue-view-select
  [[ $status -eq 1 ]]
  [[ "${lines[0]}" == "Error: BASH_TOYS_INTERACTIVE_FILTER is not set" ]]
}

@test 'Should show error when interactive filter command is not found' {
  export BASH_TOYS_INTERACTIVE_FILTER='nonexistent-command'
  run bin/gh-issue-view-select
  [[ $status -eq 1 ]]
  [[ "${lines[0]}" == "Error: nonexistent-command command not found" ]]
}

@test 'Should handle empty selection' {
  export BASH_TOYS_INTERACTIVE_FILTER='true'
  run bin/gh-issue-view-select
  [[ $status -eq 0 ]]
}

@test 'Should extract and view issue number' {
  # Mock gh command
  function gh () {
    if [[ $1 == 'issue' && $2 == 'list' ]] ; then
      echo "#42  Issue title  enhancement  2024-03-05"
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

  run bin/gh-issue-view-select
  [[ $status -eq 0 ]]
  [[ "$(cat "$GH_OUTPUT")" == 'Issue #42 content' ]]
}