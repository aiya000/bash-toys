#!/usr/bin/env bats

# shellcheck disable=SC2016

# shellcheck disable=SC1091
source ./source-all.sh

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`grep-skip-self --help` should show help message' {
  run grep-skip-self --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^grep-skip-self - '
}

@test '`grep-skip-self -h` should show help message' {
  run grep-skip-self -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^grep-skip-self - '
}

@test 'piped: grep-skip-self should return matching lines' {
  run bash -c 'source ./source-all.sh && printf "nginx\napache\nnginx2\n" | grep-skip-self nginx'
  expects "$status" to_be 0
  expects "$output" to_contain 'nginx'
}

@test 'piped: grep-skip-self should not return lines matching the self invocation' {
  run bash -c 'source ./source-all.sh && printf "grep-skip-self nginx\nnginx\n" | grep-skip-self nginx'
  expects "$status" to_be 0
  expects "$output" not to_contain 'grep-skip-self nginx'
  expects "$output" to_contain 'nginx'
}

@test 'piped: grep-skip-self should not return the internal grep process line' {
  run bash -c 'source ./source-all.sh && printf "grep nginx\nnginx\n" | grep-skip-self nginx'
  expects "$status" to_be 0
  expects "$output" not to_contain 'grep nginx'
  expects "$output" to_contain 'nginx'
}

@test 'piped: grep-skip-self should exit non-zero when no match' {
  run bash -c 'source ./source-all.sh && printf "apache\n" | grep-skip-self nginx'
  expects "$status" not to_be 0
}
