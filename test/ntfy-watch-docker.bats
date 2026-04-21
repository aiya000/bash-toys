#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`ntfy-watch-docker --help` should show help message' {
  run ntfy-watch-docker --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^Usage: ntfy-watch-docker '
}

@test '`ntfy-watch-docker -h` should show help message' {
  run ntfy-watch-docker -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^Usage: ntfy-watch-docker '
}

@test 'unknown option exits with status 1' {
  run ntfy-watch-docker --unknown-option
  expects "$status" to_be 1
}

@test 'parse_protocol: --protocol arg is used' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ntfy-watch-docker --protocol https
  expects "$status" to_be 0
  expects "$output" to_match 'protocol=https'
}

@test 'parse_protocol: BASH_TOYS_NTFY_SERVING_URL is parsed' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 BASH_TOYS_NTFY_SERVING_URL='http://192.168.1.10:18432' ntfy-watch-docker
  expects "$status" to_be 0
  expects "$output" to_match 'protocol=http'
}

@test 'parse_protocol: --protocol arg takes precedence over BASH_TOYS_NTFY_SERVING_URL' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 BASH_TOYS_NTFY_SERVING_URL='http://192.168.1.10:18432' ntfy-watch-docker --protocol https
  expects "$status" to_be 0
  expects "$output" to_match 'protocol=https'
}

@test 'parse_protocol: falls back to http when no arg and no env var' {
  run env -u BASH_TOYS_NTFY_SERVING_URL DEBUG_BASHTOYS_PARSE_ONLY=1 ntfy-watch-docker
  expects "$status" to_be 0
  expects "$output" to_match 'protocol=http'
}

@test 'parse_host: --host arg is used' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ntfy-watch-docker --host 192.168.1.10
  expects "$status" to_be 0
  expects "$output" to_match 'host=192.168.1.10'
}

@test 'parse_host: BASH_TOYS_NTFY_SERVING_URL is parsed' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 BASH_TOYS_NTFY_SERVING_URL='http://192.168.1.10:18432' ntfy-watch-docker
  expects "$status" to_be 0
  expects "$output" to_match 'host=192.168.1.10'
}

@test 'parse_host: --host arg takes precedence over BASH_TOYS_NTFY_SERVING_URL' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 BASH_TOYS_NTFY_SERVING_URL='http://192.168.1.10:18432' ntfy-watch-docker --host 10.0.0.1
  expects "$status" to_be 0
  expects "$output" to_match 'host=10.0.0.1'
}

@test 'parse_host: falls back to localhost when no arg and no env var' {
  run env -u BASH_TOYS_NTFY_SERVING_URL DEBUG_BASHTOYS_PARSE_ONLY=1 ntfy-watch-docker
  expects "$status" to_be 0
  expects "$output" to_match 'host=localhost'
}

@test 'parse_port: --port arg is used' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ntfy-watch-docker --port 18432
  expects "$status" to_be 0
  expects "$output" to_match 'port=18432'
}

@test 'parse_port: BASH_TOYS_NTFY_SERVING_URL is parsed' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 BASH_TOYS_NTFY_SERVING_URL='http://192.168.1.10:18432' ntfy-watch-docker
  expects "$status" to_be 0
  expects "$output" to_match 'port=18432'
}

@test 'parse_port: --port arg takes precedence over BASH_TOYS_NTFY_SERVING_URL' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 BASH_TOYS_NTFY_SERVING_URL='http://192.168.1.10:18432' ntfy-watch-docker --port 9999
  expects "$status" to_be 0
  expects "$output" to_match 'port=9999'
}

@test 'parse_port: falls back to 80 when no arg and no env var' {
  run env -u BASH_TOYS_NTFY_SERVING_URL DEBUG_BASHTOYS_PARSE_ONLY=1 ntfy-watch-docker
  expects "$status" to_be 0
  expects "$output" to_match 'port=80'
}

@test 'options work regardless of order' {
  run env DEBUG_BASHTOYS_PARSE_ONLY=1 ntfy-watch-docker --port 18432 --host 192.168.1.10 --protocol https
  expects "$status" to_be 0
  expects "$output" to_match 'protocol=https'
  expects "$output" to_match 'host=192.168.1.10'
  expects "$output" to_match 'port=18432'
}
