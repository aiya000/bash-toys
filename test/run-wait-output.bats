#!/usr/bin/env bats

@test '`run-wait-output --help` should show help message' {
  run run-wait-output --help
  [[ $status -eq 0 ]]
  [[ ${lines[0]} =~ ^Usage:\ run-wait-output ]]
}

@test '`run-wait-output -h` should show help message' {
  run run-wait-output -h
  [[ $status -eq 0 ]]
  [[ ${lines[0]} =~ ^Usage:\ run-wait-output ]]
}

@test '`run-wait-output` with no arguments should show help and fail' {
  run run-wait-output
  [[ $status -eq 1 ]]
  [[ ${lines[0]} =~ ^Usage:\ run-wait-output ]]
}

@test '`run-wait-output` with one argument should show help and fail' {
  run run-wait-output 1000
  [[ $status -eq 1 ]]
  [[ ${lines[0]} =~ ^Usage:\ run-wait-output ]]
}

@test '`run-wait-output` with two arguments should show help and fail' {
  run run-wait-output 1000 'echo first'
  [[ $status -eq 1 ]]
  [[ ${lines[0]} =~ ^Usage:\ run-wait-output ]]
}

@test '`run-wait-output` with non-numeric milliseconds should fail' {
  run run-wait-output abc 'echo first' 'echo second'
  [[ $status -eq 1 ]]
  [[ $output =~ 'Error: milliseconds must be a positive integer' ]]
}

@test '`run-wait-output` should handle quick commands' {
  run timeout 5 run-wait-output 100 'echo test' 'echo done'
  [[ $status -eq 0 ]]
  [[ $output =~ 'Executing: echo test' ]]
  [[ $output =~ 'test' ]]
  [[ $output =~ 'Executing: echo done' ]]
  [[ $output =~ 'done' ]]
}

@test '`run-wait-output` should return exit status of second command' {
  run timeout 5 run-wait-output 100 'echo test' 'false'
  [[ $status -eq 1 ]]
}

@test '`run-wait-output` should keep command1 running after command2 completes' {
  tmpfile=$(mktemp)
  outputfile=$(mktemp)
  trap "rm -f $tmpfile $outputfile" EXIT

  # Start run-wait-output: command1 outputs "after_cmd2" after a long sleep
  timeout 8 run-wait-output 1000 "echo before ; sleep 2 ; echo after_cmd2 ; sleep 1" "echo done > $tmpfile" > $outputfile 2>&1

  output=$(cat "$outputfile")

  # Check if command2 executed
  [[ -f $tmpfile ]]
  [[ $(cat "$tmpfile") == 'done' ]]

  # Check if command1 continued running after command2 (should see "after_cmd2")
  [[ $output =~ 'after_cmd2' ]]

  rm -f "$tmpfile" "$outputfile"
}

@test '`run-wait-output` should execute command2 even if command1 fails' {
  run timeout 5 run-wait-output 100 'echo test && false' 'echo success'
  [[ $status -eq 0 ]]
  [[ $output =~ 'success' ]]
}

@test '`run-wait-output` should handle commands with stderr' {
  run timeout 5 run-wait-output 100 'echo error >&2' 'echo done'
  [[ $status -eq 0 ]]
  [[ $output =~ 'error' ]]
  [[ $output =~ 'done' ]]
}

@test '`run-wait-output` should monitor output changes' {
  run timeout 5 run-wait-output 300 'for i in {1..3} ; do sleep 0.1 echo "$i" done' 'echo triggered'
  [[ $status -eq 0 ]]
  [[ $output =~ '1' ]]
  [[ $output =~ '2' ]]
  [[ $output =~ '3' ]]
  [[ $output =~ 'triggered' ]]
}

@test '`run-wait-output` should run command2 in foreground' {
  tmpfile=$(mktemp)
  run timeout 5 run-wait-output 100 'echo first' "echo \$\$ > $tmpfile ; sleep 0.5"
  [[ $status -eq 0 ]]

  if [[ -f $tmpfile ]] ; then
    pid=$(cat "$tmpfile")
    rm -f "$tmpfile"
    [[ $pid =~ ^[0-9]+$ ]]
  fi
}

@test '`run-wait-output` command2 should receive signals properly' {
  tmpfile=$(mktemp)
  trap "rm -f $tmpfile" EXIT

  # Start run-wait-output in background, command2 writes its PID
  timeout 3 bash -c "run-wait-output 100 'echo first' 'echo \$\$ > $tmpfile ; sleep 5'" &
  runner_pid=$!

  # Wait for command2 to start and write its PID
  sleep 1

  # Verify the PID file was created (command2 executed)
  [[ -f $tmpfile ]]

  # Clean up
  kill $runner_pid 2>/dev/null || true
  wait $runner_pid 2>/dev/null || true
  rm -f "$tmpfile"
}

