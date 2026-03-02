#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`set-audio-volume --help` should show help message' {
  run set-audio-volume --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'set-audio-volume - Adjust audio volume to match a target level'
}

@test '`set-audio-volume -h` should show help message' {
  run set-audio-volume -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'set-audio-volume - Adjust audio volume to match a target level'
}

@test 'should error when --input is missing' {
  run set-audio-volume --output bar.mp3 --mean-volume -18.3
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --input is required'
}

@test 'should error when --output is missing' {
  run set-audio-volume --input foo.mp3 --mean-volume -18.3
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --output is required'
}

@test 'should error when neither --mean-volume nor --max-volume is given' {
  run set-audio-volume --input foo.mp3 --output bar.mp3
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Either --mean-volume or --max-volume is required'
}

@test 'should error when both --mean-volume and --max-volume are given' {
  run set-audio-volume --input foo.mp3 --output bar.mp3 --mean-volume -18.3 --max-volume -1.0
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --mean-volume and --max-volume cannot be used together'
}

@test 'should error when input file does not exist' {
  run set-audio-volume --input nonexistent.mp3 --output bar.mp3 --mean-volume -18.3
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Input file not found: nonexistent.mp3'
}

@test 'should error on unknown option' {
  run set-audio-volume --unknown-option
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Unknown option: --unknown-option'
}
