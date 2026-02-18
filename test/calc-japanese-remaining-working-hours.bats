#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`calc-japanese-remaining-working-hours --help` should show help message' {
  run calc-japanese-remaining-working-hours --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^calc-japanese-remaining-working-hours - '
}

@test '`calc-japanese-remaining-working-hours -h` should show help message' {
  run calc-japanese-remaining-working-hours -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^calc-japanese-remaining-working-hours - '
}

@test '`calc-japanese-remaining-working-hours` without arguments should show error' {
  run calc-japanese-remaining-working-hours
  expects "$status" to_be 1
}

@test '`calc-japanese-remaining-working-hours` with invalid format should show error' {
  run calc-japanese-remaining-working-hours 'invalid'
  expects "$status" to_be 1
  expects "$output" to_match 'Error: Invalid format'
}

@test '`calc-japanese-remaining-working-hours 108:37` should accept HOURS:MINUTES format' {
  run calc-japanese-remaining-working-hours 108:37
  expects "$status" to_be 0
  if echo "$output" | grep -q '残り勤務時間'; then
    expects "$output" to_match '残り勤務時間: 108時間37分'
  fi
}

@test '`calc-japanese-remaining-working-hours 51時間` should accept Japanese format without minutes' {
  run calc-japanese-remaining-working-hours '51時間'
  expects "$status" to_be 0
  if echo "$output" | grep -q '残り勤務時間'; then
    expects "$output" to_match '残り勤務時間: 51時間0分'
  fi
}

@test '`calc-japanese-remaining-working-hours 51時間30分` should accept Japanese format with minutes' {
  run calc-japanese-remaining-working-hours '51時間30分'
  expects "$status" to_be 0
  if echo "$output" | grep -q '残り勤務時間'; then
    expects "$output" to_match '残り勤務時間: 51時間30分'
  fi
}

@test '`calc-japanese-remaining-working-hours 51時間0分` should accept Japanese format with 0 minutes' {
  run calc-japanese-remaining-working-hours '51時間0分'
  expects "$status" to_be 0
  if echo "$output" | grep -q '残り勤務時間'; then
    expects "$output" to_match '残り勤務時間: 51時間0分'
  fi
}

@test '`calc-japanese-remaining-working-hours 120時間` should accept large hours in Japanese format' {
  run calc-japanese-remaining-working-hours '120時間'
  expects "$status" to_be 0
  if echo "$output" | grep -q '残り勤務時間'; then
    expects "$output" to_match '残り勤務時間: 120時間0分'
  fi
}
