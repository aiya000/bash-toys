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
  if ! command -v smem &> /dev/null ; then
    skip 'smem is not installed'
  fi
  run ps-mem --swap --rss
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +SWAP +RSS'
}

@test 'header column order follows --rss --swap' {
  if ! command -v smem &> /dev/null ; then
    skip 'smem is not installed'
  fi
  run ps-mem --rss --swap
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +RSS +SWAP'
}

@test 'default run shows RSS column with MiB values for at least one process' {
  if ! command -v smem &> /dev/null ; then
    skip 'smem is not installed'
  fi
  run ps-mem
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +RSS'
  expects "$output" to_match '[0-9]+\.[0-9]MiB'
}

@test 'errors clearly when smem is not installed' {
  if command -v smem &> /dev/null ; then
    skip 'smem is installed; cannot test the not-installed path'
  fi
  run ps-mem
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: smem is not installed'
}
