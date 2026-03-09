#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`update-audio-file-volume --help` should show help message' {
  run update-audio-file-volume --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'update-audio-file-volume - Adjust audio volume to match a target level'
}

@test '`update-audio-file-volume -h` should show help message' {
  run update-audio-file-volume -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_equal 'update-audio-file-volume - Adjust audio volume to match a target level'
}

@test 'should error when --input is missing' {
  run update-audio-file-volume --output bar.mp3 --mean-volume -18.3
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --input is required'
}

@test 'should error when --output is missing' {
  run update-audio-file-volume --input foo.mp3 --mean-volume -18.3
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --output is required'
}

@test 'should error when neither --mean-volume nor --max-volume is given' {
  run update-audio-file-volume --input foo.mp3 --output bar.mp3
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Either --mean-volume or --max-volume is required'
}

@test 'should error when both --mean-volume and --max-volume are given' {
  run update-audio-file-volume --input foo.mp3 --output bar.mp3 --mean-volume -18.3 --max-volume -1.0
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --mean-volume and --max-volume cannot be used together'
}

@test 'should error when input file does not exist' {
  run update-audio-file-volume --input nonexistent.mp3 --output bar.mp3 --mean-volume -18.3
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Input file not found: nonexistent.mp3'
}

@test 'should error on unknown option' {
  run update-audio-file-volume --unknown-option
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Unknown option: --unknown-option'
}

@test 'should error when --input is provided without a value' {
  run update-audio-file-volume --input --output bar.mp3 --mean-volume -18.3
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --input requires a value'
}

@test 'should error when --output is provided without a value' {
  run update-audio-file-volume --input foo.mp3 --output --mean-volume -18.3
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --output requires a value'
}

@test 'should error when --mean-volume is provided without a value' {
  run update-audio-file-volume --input foo.mp3 --output bar.mp3 --mean-volume
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --mean-volume requires a value'
}

@test 'should error when --max-volume is provided without a value' {
  run update-audio-file-volume --input foo.mp3 --output bar.mp3 --max-volume
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: --max-volume requires a value'
}

@test 'should error when --mean-volume is non-numeric' {
  run update-audio-file-volume --input foo.mp3 --output bar.mp3 --mean-volume not-a-number
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Invalid value for --mean-volume: not-a-number'
}

@test 'should error when --max-volume is non-numeric' {
  run update-audio-file-volume --input foo.mp3 --output bar.mp3 --max-volume loud
  expects "$status" to_be 1
  expects "$output" to_contain 'Error: Invalid value for --max-volume: loud'
}
