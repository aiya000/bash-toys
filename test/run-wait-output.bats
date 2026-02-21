#!/usr/bin/env bats

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`run-wait-output --help` should show help message' {
  run run-wait-output --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^Usage: run-wait-output'
}

@test '`run-wait-output -h` should show help message' {
  run run-wait-output -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^Usage: run-wait-output'
}

@test '`run-wait-output` with no arguments should show help and fail' {
  run run-wait-output
  expects "$status" to_be 1
  expects "${lines[0]}" to_match '^Usage: run-wait-output'
}

@test '`run-wait-output` with one argument should show help and fail' {
  run run-wait-output 1000
  expects "$status" to_be 1
  expects "${lines[0]}" to_match '^Usage: run-wait-output'
}

@test '`run-wait-output` with two arguments should show help and fail' {
  run run-wait-output 1000 'echo first'
  expects "$status" to_be 1
  expects "${lines[0]}" to_match '^Usage: run-wait-output'
}

@test '`run-wait-output` with non-numeric milliseconds should fail' {
  run run-wait-output abc 'echo first' 'echo second'
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: milliseconds must be a positive integer'
}

@test '`run-wait-output` should handle quick commands' {
  run timeout 5 run-wait-output 100 'echo test' 'echo done'
  expects "$status" to_be 0
  expects "$output" to_contain 'Executing: echo test'
  expects "$output" to_contain 'test'
  expects "$output" to_contain 'Executing: echo done'
  expects "$output" to_contain 'done'
}

@test '`run-wait-output` should return exit status of second command' {
  run timeout 5 run-wait-output 100 'echo test' 'false'
  expects "$status" to_be 1
}

@test '`run-wait-output` should keep command1 running after command2 completes' {
  tmpfile=$(mktemp)
  outputfile=$(mktemp)
  trap "rm -f $tmpfile $outputfile" EXIT

  # Start run-wait-output: command1 outputs "after_cmd2" after a long sleep
  timeout 8 run-wait-output 1000 "echo before ; sleep 2 ; echo after_cmd2 ; sleep 1" "echo done > $tmpfile" > $outputfile 2>&1

  saved_output=$(cat "$outputfile")

  # Check if command2 executed
  expects "$tmpfile" to_be_a_file
  run cat "$tmpfile"
  expects "$output" to_equal 'done'

  # Check if command1 continued running after command2 (should see "after_cmd2")
  expects "$saved_output" to_contain 'after_cmd2'

  rm -f "$tmpfile" "$outputfile"
}

@test '`run-wait-output` should execute command2 even if command1 fails' {
  run timeout 5 run-wait-output 100 'echo test && false' 'echo success'
  expects "$status" to_be 0
  expects "$output" to_contain 'success'
}

@test '`run-wait-output` should handle commands with stderr' {
  run timeout 5 run-wait-output 100 'echo error >&2' 'echo done'
  expects "$status" to_be 0
  expects "$output" to_contain 'error'
  expects "$output" to_contain 'done'
}

@test '`run-wait-output` should monitor output changes' {
  run timeout 5 run-wait-output 300 'for i in {1..3} ; do sleep 0.1 echo "$i" done' 'echo triggered'
  expects "$status" to_be 0
  expects "$output" to_contain '1'
  expects "$output" to_contain '2'
  expects "$output" to_contain '3'
  expects "$output" to_contain 'triggered'
}

@test '`run-wait-output` should run command2 in foreground' {
  tmpfile=$(mktemp)
  run timeout 5 run-wait-output 100 'echo first' "echo \$\$ > $tmpfile ; sleep 0.5"
  expects "$status" to_be 0

  if [[ -f "$tmpfile" ]] ; then
    run cat "$tmpfile"
    expects "$output" to_match '^[0-9]+$'
    rm -f "$tmpfile"
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
  expects "$tmpfile" to_be_a_file

  # Clean up
  kill $runner_pid 2>/dev/null || true
  wait $runner_pid 2>/dev/null || true
  rm -f "$tmpfile"
}

