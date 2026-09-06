#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

# Prints 'yes' when a memory column never decreases down the table, 'no'
# otherwise. Pass the data rows only, without the header.
#
# The column is identified by which MiB value it is within a row (1 for the
# leftmost), because COMMAND may contain spaces, so no fixed field number
# identifies a column once --pname moves COMMAND around.
#
# Rendering to one decimal is monotonic, so comparing the printed MiB values is
# enough to tell whether the underlying KiB values were sorted.
ascending_mib_column() {
  local occurrence=$1
  shift
  printf '%s\n' "$@" | awk -v occurrence="$occurrence" '
    {
      seen = 0
      value = ""
      for (i = 1; i <= NF; i++) {
        if ($i ~ /^[0-9]+\.[0-9]MiB$/) {
          seen++
          if (seen == occurrence) {
            value = $i
            break
          }
        }
      }
      if (value == "") {
        missing = 1
        next
      }
      sub(/MiB$/, "", value)
      if (value + 0 < previous + 0) descending = 1
      previous = value
    }
    END { print (missing || descending) ? "no" : "yes" }
  '
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
  expects "${lines[0]}" to_equal 'columns=RSS'
}

@test '--swap selects SWAP only' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --swap
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=SWAP'
}

@test '--uss selects USS only' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --uss
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=USS'
}

@test '--pss selects PSS only' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --pss
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=PSS'
}

@test '--swap --rss keeps given order (SWAP before RSS)' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --swap --rss
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=SWAP,RSS'
}

@test '--rss --swap keeps given order (RSS before SWAP)' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --rss --swap
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=RSS,SWAP'
}

@test '--uss --pss --rss --swap keeps given order' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --uss --pss --rss --swap
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=USS,PSS,RSS,SWAP'
}

@test '--footprint selects FOOTPRINT only' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --footprint
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=FOOTPRINT'
}

@test '--footprint --rss keeps given order' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --footprint --rss
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=FOOTPRINT,RSS'
}

@test 'sort target defaults to RSS' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem
  expects "$status" to_be 0
  expects "${lines[3]}" to_equal 'sort=RSS'
}

@test 'sort target is the last memory option (--swap --rss)' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --swap --rss
  expects "$status" to_be 0
  expects "${lines[3]}" to_equal 'sort=RSS'
}

@test 'sort target is the last memory option (--rss --swap)' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --rss --swap
  expects "$status" to_be 0
  expects "${lines[3]}" to_equal 'sort=SWAP'
}

@test 'sort target is the last memory option (--uss --pss --rss --swap)' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --uss --pss --rss --swap
  expects "$status" to_be 0
  expects "${lines[3]}" to_equal 'sort=SWAP'
}

@test 'sort target is the last memory option (--rss --footprint)' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --rss --footprint
  expects "$status" to_be 0
  expects "${lines[3]}" to_equal 'sort=FOOTPRINT'
}

@test 'sort target is the last memory option (--footprint --rss)' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --footprint --rss
  expects "$status" to_be 0
  expects "${lines[3]}" to_equal 'sort=RSS'
}

@test '--pname does not become the sort target' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --pname
  expects "$status" to_be 0
  expects "${lines[3]}" to_equal 'sort=RSS'
}

@test '--pname does not become the sort target even when passed last' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --swap --pname
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=SWAP,COMMAND'
  expects "${lines[3]}" to_equal 'sort=SWAP'
}

@test '--pname does not shadow a later memory option as the sort target' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --swap --pname --rss
  expects "$status" to_be 0
  expects "${lines[3]}" to_equal 'sort=RSS'
}

@test '--total does not become the sort target' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --swap --total
  expects "$status" to_be 0
  expects "${lines[3]}" to_equal 'sort=SWAP'
}

@test 'total is off by default' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem
  expects "$status" to_be 0
  expects "${lines[2]}" to_equal 'total=false'
}

@test '--total turns the TOTAL row on' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --total
  expects "$status" to_be 0
  expects "${lines[2]}" to_equal 'total=true'
}

@test '--total works regardless of position' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --rss --total --pname
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=RSS,COMMAND'
  expects "${lines[2]}" to_equal 'total=true'
}

@test '--total alone does not count as a memory column' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --total
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=RSS'
}

@test '--pname adds COMMAND to the ordered columns, keeping the default RSS' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --pname
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=COMMAND,RSS'
}

@test '--process-name is a long form of --pname' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --process-name
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=COMMAND,RSS'
}

@test '--rss --pname keeps given order (RSS before COMMAND)' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --rss --pname
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=RSS,COMMAND'
}

@test '--pname --rss keeps given order (COMMAND before RSS)' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --pname --rss
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=COMMAND,RSS'
}

@test '--pname takes part in the ordering of memory columns' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --swap --pname --rss
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=SWAP,COMMAND,RSS'
}

@test 'default cmd_max is 30' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem
  expects "$status" to_be 0
  expects "${lines[1]}" to_equal 'cmd_max=30'
}

@test '--process-name-max-length overrides cmd_max' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --process-name-max-length 60
  expects "$status" to_be 0
  expects "${lines[1]}" to_equal 'cmd_max=60'
}

@test '--process-name-max-length works regardless of position' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem --rss --process-name-max-length 60 --swap
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'columns=RSS,SWAP'
  expects "${lines[1]}" to_equal 'cmd_max=60'
}

@test '--process-name-max-length errors when value is missing' {
  run ps-mem --process-name-max-length
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --process-name-max-length requires a number'
}

@test '--process-name-max-length errors when value is not a number' {
  run ps-mem --process-name-max-length abc
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --process-name-max-length requires a number, got: abc'
}

@test '--process-name-max-length errors when value is below the minimum' {
  run ps-mem --process-name-max-length 3
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --process-name-max-length must be 4 or greater'
}

@test '-c is a shorthand for --process-name-max-length' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem -c 60
  expects "$status" to_be 0
  expects "${lines[1]}" to_equal 'cmd_max=60'
}

@test '-c errors when value is missing' {
  run ps-mem -c
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --process-name-max-length requires a number'
}

@test 'later -c wins when given multiple times' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem -c 10 -c 90
  expects "$status" to_be 0
  expects "${lines[1]}" to_equal 'cmd_max=90'
}

@test 'later --process-name-max-length wins over an earlier -c' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ps-mem -c 90 --process-name-max-length 10
  expects "$status" to_be 0
  expects "${lines[1]}" to_equal 'cmd_max=10'
}

@test 'header always shows PID, USER, COMMAND plus selected columns in order' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'the /proc backend is Linux only'
  fi
  run ps-mem --swap --rss
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +SWAP +RSS'
}

@test 'header column order follows --rss --swap' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'the /proc backend is Linux only'
  fi
  run ps-mem --rss --swap
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +RSS +SWAP'
}

@test 'header places COMMAND at the --pname position' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'the /proc backend is Linux only'
  fi
  run ps-mem --swap --pname --rss
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +SWAP +COMMAND +RSS'
}

@test 'default run shows RSS column with MiB values for at least one process' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'the /proc backend is Linux only'
  fi
  run ps-mem
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +RSS'
  expects "$output" to_match '[0-9]+\.[0-9]MiB'
}

@test '--pss alone is sorted ascending by PSS, not by RSS' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'the /proc backend is Linux only'
  fi
  run ps-mem --pss
  expects "$status" to_be 0
  expects "$(ascending_mib_column 1 "${lines[@]:1}")" to_be yes
}

@test '--rss --pss is sorted ascending by PSS, since --pss comes last' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'the /proc backend is Linux only'
  fi
  run ps-mem --rss --pss
  expects "$status" to_be 0
  expects "$(ascending_mib_column 2 "${lines[@]:1}")" to_be yes
}

@test '--pss --rss is sorted ascending by RSS, since --rss comes last' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'the /proc backend is Linux only'
  fi
  run ps-mem --pss --rss
  expects "$status" to_be 0
  expects "$(ascending_mib_column 2 "${lines[@]:1}")" to_be yes
}

@test '--footprint is rejected outside macOS' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'macOS supports --footprint'
  fi
  run ps-mem --footprint
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --footprint is supported on macOS only'
}

@test '--footprint is rejected outside macOS even when combined with --rss' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'macOS supports --footprint'
  fi
  run ps-mem --rss --footprint
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --footprint is supported on macOS only'
}

@test 'TOTAL row is appended when --total is given' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'the /proc backend is Linux only'
  fi
  run ps-mem --pss --total
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +PSS'

  # bash 3.2 (macOS' /bin/bash) has no negative array subscripts
  local last=$(( ${#lines[@]} - 1 ))
  expects "${lines[$last]}" to_match '^TOTAL +- +[0-9]+ processes +[0-9]+\.[0-9](MiB|GiB)$'

  local rule=$(( last - 1 ))
  expects "${lines[$rule]}" to_match '^-+$'
  expects "${#lines[$rule]}" to_be "${#lines[0]}"
}

@test 'a command line containing a newline stays on one row' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'the /proc backend is Linux only'
  fi

  # $0 of the sh is a harmless place to put a newline into argv. fd 3 is closed
  # so that the background process does not keep bats waiting on it.
  sh -c 'sleep 30' $'ps-mem-newline-marker\nsecond-line' > /dev/null 2>&1 3>&- &
  local sleeper=$!

  run ps-mem --rss --total -c 80
  kill "$sleeper"
  expects "$status" to_be 0

  # The newline is folded into the row instead of starting a new one
  expects "$output" to_match 'ps-mem-newline-marker.second-line'
  expects "$output" not to_contain $'\nsecond-line'

  # Every data row is a whole process: PID and USER first, a value last
  local last=$(( ${#lines[@]} - 1 ))
  local rows=$(( last - 2 ))
  local line
  for line in "${lines[@]:1:$rows}" ; do
    expects "$line" to_match '^[0-9]+ +[^ ]+ +.*[0-9]+\.[0-9]MiB$'
  done

  # Nothing was dropped between the rows and the TOTAL row
  expects "${lines[$last]}" to_match "^TOTAL +- +$rows processes "
}

@test 'Linux: --process-name-max-length is not capped by the backend' {
  if [[ $(uname -s) == 'Darwin' ]] ; then
    skip 'the /proc backend is Linux only'
  fi

  sh -c 'sleep 30' 'ps-mem-long-marker-0123456789-0123456789-0123456789' > /dev/null 2>&1 3>&- &
  local sleeper=$!

  run ps-mem -c 80
  kill "$sleeper"
  expects "$status" to_be 0
  expects "$output" to_contain 'sh -c sleep 30 ps-mem-long-marker-0123456789-0123456789-0123456789'
}

@test 'macOS: default run shows RSS column with MiB values' {
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

@test 'macOS: --footprint alone is sorted ascending by FOOTPRINT' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --footprint
  expects "$status" to_be 0
  expects "$(ascending_mib_column 1 "${lines[@]:1}")" to_be yes
}

@test 'macOS: --rss --footprint is sorted ascending by FOOTPRINT, since --footprint comes last' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --rss --footprint
  expects "$status" to_be 0
  expects "$(ascending_mib_column 2 "${lines[@]:1}")" to_be yes
}

@test 'macOS: --footprint --rss is sorted ascending by RSS, since --rss comes last' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --footprint --rss
  expects "$status" to_be 0
  expects "$(ascending_mib_column 2 "${lines[@]:1}")" to_be yes
}

@test 'macOS: --rss --pname keeps RSS ascending even though COMMAND comes last' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --rss --pname
  expects "$status" to_be 0
  expects "$(ascending_mib_column 1 "${lines[@]:1}")" to_be yes
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

@test 'macOS: --process-name-max-length widens the COMMAND column' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --process-name-max-length 60
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +RSS'
}

@test 'macOS: all data rows have the same line length as the header' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem
  expects "$status" to_be 0

  local header_length=${#lines[0]}
  local line
  for line in "${lines[@]:1}" ; do
    expects "${#line}" to_be "$header_length"
  done
}

@test 'macOS: --pname places COMMAND after RSS' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --rss --pname
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +RSS +COMMAND'
}

@test 'macOS: --pname alone keeps COMMAND before RSS' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --pname
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +RSS'
}

@test 'macOS: all data rows stay aligned with --rss --pname' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --rss --pname
  expects "$status" to_be 0

  local header_length=${#lines[0]}
  local line
  for line in "${lines[@]:1}" ; do
    expects "${#line}" to_be "$header_length"
  done
}

@test 'macOS: --footprint shows a FOOTPRINT column with MiB values' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --footprint
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +FOOTPRINT'
  expects "$output" to_match '[0-9]+\.[0-9]MiB'
}

@test 'macOS: --footprint keeps its position next to --rss' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --rss --footprint
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'PID +USER +COMMAND +RSS +FOOTPRINT'
}

@test 'macOS: --footprint reports more than RSS in total' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --rss --footprint --total
  expects "$status" to_be 0

  local last=$(( ${#lines[@]} - 1 ))
  local total_line=${lines[$last]}
  expects "$total_line" to_match '^TOTAL +-'

  # The TOTAL row switches to GiB from 10000.0MiB up, so normalize to MiB
  local rss footprint
  rss=$(echo "$total_line" | awk '{ v = $(NF - 1); if (sub(/GiB$/, "", v)) v = v * 1024; else sub(/MiB$/, "", v); print v }')
  footprint=$(echo "$total_line" | awk '{ v = $NF; if (sub(/GiB$/, "", v)) v = v * 1024; else sub(/MiB$/, "", v); print v }')
  expects "$(awk -v a="$rss" -v b="$footprint" 'BEGIN { print (a <= b) ? "yes" : "no" }')" to_be yes
}

@test 'macOS: --total appends a TOTAL row' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --total
  expects "$status" to_be 0

  local last=$(( ${#lines[@]} - 1 ))
  expects "${lines[$last]}" to_match '^TOTAL +- +[0-9]+ processes +[0-9]+\.[0-9](MiB|GiB)$'
}

@test 'macOS: --total draws a horizontal rule right above the TOTAL row' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --total
  expects "$status" to_be 0

  local last=$(( ${#lines[@]} - 1 ))
  local rule=$(( last - 1 ))
  expects "${lines[$rule]}" to_match '^-+$'
  expects "${#lines[$rule]}" to_be "${#lines[0]}"
}

@test 'macOS: no horizontal rule is drawn without --total' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem
  expects "$status" to_be 0

  # `$output` is checked line by line because bash's `=~` anchors match the
  # whole string, not each line
  local line
  for line in "${lines[@]}" ; do
    expects "$line" not to_match '^-+$'
  done
}

@test 'macOS: --total keeps every row aligned with the header' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --total
  expects "$status" to_be 0

  local header_length=${#lines[0]}
  local line
  for line in "${lines[@]:1}" ; do
    expects "${#line}" to_be "$header_length"
  done
}

@test 'macOS: --total sums the RSS column of the printed rows' {
  if [[ $(uname -s) != 'Darwin' ]] ; then
    skip 'not macOS'
  fi
  run ps-mem --total
  expects "$status" to_be 0

  local last=$(( ${#lines[@]} - 1 ))
  local reported summed tolerance
  # The TOTAL row switches to GiB from 10000.0MiB up, where one displayed digit
  # is worth 102.4MiB, so the tolerance has to follow the unit actually printed
  reported=$(echo "${lines[$last]}" | awk '{ v = $NF; if (sub(/GiB$/, "", v)) v = v * 1024; else sub(/MiB$/, "", v); print v }')
  summed=$(printf '%s\n' "${lines[@]:1}" | awk '!/^TOTAL /  { v = $NF; sub(/MiB$/, "", v); s += v } END { printf "%.1f", s }')

  if [[ ${lines[$last]} == *GiB ]] ; then
    tolerance=103
  else
    tolerance=1
  fi
  expects "$(awk -v a="$reported" -v b="$summed" -v t="$tolerance" 'BEGIN { print ((a - b) < t && (b - a) < t) ? "yes" : "no" }')" to_be yes
}

@test '--total shows the TOTAL row in GiB from 10000.0MiB up, in MiB below it' {
  run ps-mem --total
  expects "$status" to_be 0

  # The per-process rows are always MiB, so summing them tells which unit the
  # TOTAL row is expected to use
  local last=$(( ${#lines[@]} - 1 ))
  local summed
  summed=$(printf '%s\n' "${lines[@]:1}" | awk '!/^TOTAL /  { v = $NF; sub(/MiB$/, "", v); s += v } END { printf "%.1f", s }')

  if [[ $(awk -v s="$summed" 'BEGIN { print (s >= 10000) ? "gib" : "mib" }') == 'gib' ]] ; then
    expects "${lines[$last]}" to_match '[0-9]+\.[0-9]GiB$'
  else
    expects "${lines[$last]}" to_match '[0-9]+\.[0-9]MiB$'
  fi
}
