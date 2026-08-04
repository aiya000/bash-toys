#!/usr/bin/env bats

# shellcheck disable=SC2016

# shellcheck disable=SC1091
source ./source-all.sh

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`rg-skip-self --help` should show help message' {
  run rg-skip-self --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^rg-skip-self - '
}

@test '`rg-skip-self -h` should show help message' {
  run rg-skip-self -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^rg-skip-self - '
}

@test 'piped: rg-skip-self should return matching lines' {
  run bash -c 'source ./source-all.sh && printf "nginx\napache\nnginx2\n" | rg-skip-self nginx'
  expects "$status" to_be 0
  expects "$output" to_contain 'nginx'
}

@test 'piped: rg-skip-self should not return lines matching the self invocation' {
  run bash -c 'source ./source-all.sh && printf "rg-skip-self nginx\nnginx\n" | rg-skip-self nginx'
  expects "$status" to_be 0
  expects "$output" not to_contain 'rg-skip-self nginx'
  expects "$output" to_contain 'nginx'
}

@test 'piped: rg-skip-self should not return the internal rg process line' {
  run bash -c 'source ./source-all.sh && printf "rg nginx\nnginx\n" | rg-skip-self nginx'
  expects "$status" to_be 0
  expects "$output" not to_contain 'rg nginx'
  expects "$output" to_contain 'nginx'
}

@test 'piped: rg-skip-self should exit non-zero when no match' {
  run bash -c 'source ./source-all.sh && printf "apache\n" | rg-skip-self nginx'
  expects "$status" not to_be 0
}
