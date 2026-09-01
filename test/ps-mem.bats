#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`ps-mem --help` should show help message' {
  run ps-mem --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^ps-mem - '
}

@test '`ps-mem -h` should show help message' {
  run ps-mem -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^ps-mem - '
}

@test 'should error on unknown option' {
  run ps-mem --unknown-option
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Unknown option: --unknown-option'
}

@test 'default columns is RSS only' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem
  expects "$status" to_be 0
  expects "$output" to_equal 'columns=RSS'
}

@test '--swap selects SWAP only' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --swap
  expects "$status" to_be 0
  expects "$output" to_equal 'columns=SWAP'
}

@test '--uss selects USS only' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --uss
  expects "$status" to_be 0
  expects "$output" to_equal 'columns=USS'
}

@test '--pss selects PSS only' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --pss
  expects "$status" to_be 0
  expects "$output" to_equal 'columns=PSS'
}

@test '--swap --rss keeps given order (SWAP before RSS)' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --swap --rss
  expects "$status" to_be 0
  expects "$output" to_equal 'columns=SWAP,RSS'
}

@test '--rss --swap keeps given order (RSS before SWAP)' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --rss --swap
  expects "$status" to_be 0
  expects "$output" to_equal 'columns=RSS,SWAP'
}

@test '--uss --pss --rss --swap keeps given order' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --uss --pss --rss --swap
  expects "$status" to_be 0
  expects "$output" to_equal 'columns=USS,PSS,RSS,SWAP'
}

@test 'header always shows PID, USER, COMMAND plus selected columns in order' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'smem backend is Linux only'
  fi
  if ! command -v smem &> /dev/null ; then
    skip 'smem is not installed'
  fi
  run ps-mem --swap --rss
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +SWAP +RSS'
}

@test 'header column order follows --rss --swap' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'smem backend is Linux only'
  fi
  if ! command -v smem &> /dev/null ; then
    skip 'smem is not installed'
  fi
  run ps-mem --rss --swap
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +RSS +SWAP'
}

@test 'default run shows RSS column with MiB values for at least one process' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'smem backend is Linux only'
  fi
  if ! command -v smem &> /dev/null ; then
    skip 'smem is not installed'
  fi
  run ps-mem
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +RSS'
  expects "$output" to_match '[0-9]+\.[0-9]MiB'
}

@test 'errors clearly when smem is not installed' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'macOS uses the ps backend, so smem is not required'
  fi
  if command -v smem &> /dev/null ; then
    skip 'smem is installed; cannot test the not-installed path'
  fi
  run ps-mem
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: smem is not installed'
}

@test 'macOS: default run shows RSS column with MiB values without smem' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +RSS'
  expects "$output" to_match '[0-9]+\.[0-9]MiB'
}

@test 'macOS: --rss is supported' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --rss
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +RSS'
}

@test 'macOS: RSS is sorted ascending' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem
  expects "$status" to_be 0

  local previous=-1
  local current
  local line
  for line in "${lines[@]:1}" ; do
    current=$(echo "$line" | grep -oE '[0-9]+\.[0-9]MiB$' | tr -d 'MiB')
    if [[ $current == '' ]] ; then
      continue
    fi
    expects "$(awk -v a="$previous" -v b="$current" 'BEGIN { print (a <= b) ? "yes" : "no" }')" to_be yes
    previous=$current
  done
}

@test 'macOS: --uss is rejected' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --uss
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --uss is not supported on macOS'
}

@test 'macOS: --pss is rejected' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --pss
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --pss is not supported on macOS'
}

@test 'macOS: --swap is rejected' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --swap
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --swap is not supported on macOS'
}

@test 'macOS: unsupported column is rejected even when combined with --rss' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --rss --uss
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --uss is not supported on macOS'
}
