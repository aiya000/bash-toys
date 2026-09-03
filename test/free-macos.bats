#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

# Converts an output line like 'total:  23.2GiB' back to a plain MiB number,
# so the scaled values can be compared arithmetically
to_mib() {
  echo "$1" | awk '{
    value = $2
    unit = value
    sub(/^[0-9.]+/, "", unit)
    number = value + 0
    if (unit == "GiB") print number * 1024
    else if (unit == "MiB") print number
    else if (unit == "KiB") print number / 1024
    else exit 1
  }'
}

@test '`free-macos --help` should show help message' {
  run free-macos --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^free-macos - '
}

@test '`free-macos -h` should show help message' {
  run free-macos -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^free-macos - '
}

@test 'should error on unknown option' {
  run free-macos --unknown-option
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Unknown option: --unknown-option'
}

@test 'should error on unexpected argument' {
  run free-macos foo
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Unexpected argument: foo'
}

@test 'detail is off by default' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 free-macos
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'detail=false'
}

@test '--detail turns the breakdown on' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 free-macos --detail
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'detail=true'
}

@test 'should error on --human, since scaling is not optional' {
  run free-macos --human
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Unknown option: --human'
}

@test 'is rejected outside macOS' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'macOS supports free-macos'
  fi
  run free-macos
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: free-macos is supported on macOS only'
}

@test '--detail is rejected outside macOS' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'macOS supports free-macos'
  fi
  run free-macos --detail
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: free-macos is supported on macOS only'
}

@test 'macOS: default run prints the PhysMem line of top' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run free-macos
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^PhysMem: .*used'
}

@test 'macOS: default run prints exactly one line' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run free-macos
  expects "$status" to_be 0
  expects "${#lines[@]}" to_be 1
}

@test 'macOS: --detail prints total, used and available in a scaled unit' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run free-macos --detail
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^total: +[0-9]+(\.[0-9]+)?(KiB|MiB|GiB)$'
  expects "${lines[1]}" to_match '^used: +[0-9]+(\.[0-9]+)?(KiB|MiB|GiB)$'
  expects "${lines[2]}" to_match '^available: +[0-9]+(\.[0-9]+)?(KiB|MiB|GiB)$'
}

@test 'macOS: --detail shows a decimal in GiB, since whole GiB would be too coarse' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run free-macos --detail
  expects "$status" to_be 0

  local line
  for line in "${lines[@]}" ; do
    case "$line" in
      *GiB) expects "$line" to_match '[0-9]+\.[0-9]GiB$' ;;
    esac
  done
}

@test 'macOS: --detail prints exactly three lines' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run free-macos --detail
  expects "$status" to_be 0
  expects "${#lines[@]}" to_be 3
}

@test 'macOS: --detail keeps every line aligned' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run free-macos --detail
  expects "$status" to_be 0

  local first_length=${#lines[0]}
  local line
  for line in "${lines[@]:1}" ; do
    expects "${#line}" to_be "$first_length"
  done
}

@test 'macOS: --detail total equals used plus available' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run free-macos --detail
  expects "$status" to_be 0

  local total used available
  total=$(to_mib "${lines[0]}")
  used=$(to_mib "${lines[1]}")
  available=$(to_mib "${lines[2]}")

  # Each of the three values is rounded independently, and a GiB value keeps
  # only one decimal (0.05GiB = 51.2MiB of slack each), so allow 160MiB
  expects "$(awk -v t="$total" -v u="$used" -v a="$available" 'BEGIN { d = t - (u + a); print (d <= 160 && d >= -160) ? "yes" : "no" }')" to_be yes
}

@test 'macOS: --detail total is a plausible fraction of the installed RAM' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run free-macos --detail
  expects "$status" to_be 0

  local reported installed
  reported=$(to_mib "${lines[0]}")
  installed=$(( $(sysctl -n hw.memsize) / 1024 / 1024 ))

  # vm_stat's counters do not cover every page, so the reported total only
  # approaches the installed size from below. The 1.01 allows for the rounding
  # the scaled unit introduces
  expects "$(awk -v r="$reported" -v i="$installed" 'BEGIN { print (r <= i * 1.01 && r > i * 0.8) ? "yes" : "no" }')" to_be yes
}
