#!/usr/bin/env bats

# shellcheck disable=SC2016

# Note: Some tests perform actual git push operations with credential helpers.
# To run these tests, set BASH_TOYS_TEST_REAL_JOBS=1
#
# Example:
#   BASH_TOYS_TEST_REAL_JOBS=1 bats test/git-credential-gh-switch.bats

# Helper function to skip tests that affect real git operations
skip_unless_real_jobs_enabled() {
  if [[ "${BASH_TOYS_TEST_REAL_JOBS:-}" != "1" ]] ; then
    skip "This test affects real git operations on the host OS. Set BASH_TOYS_TEST_REAL_JOBS=1 to run."
  fi
}

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test '`git-credential-gh-switch --help` should show help message' {
  run git-credential-gh-switch --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^git-credential-gh-switch - '
}

@test '`git-credential-gh-switch -h` should show help message' {
  run git-credential-gh-switch -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^git-credential-gh-switch - '
}

@test '`git-credential-gh-switch` without arguments should fail' {
  run bash -c 'echo "" | git-credential-gh-switch'
  expects "$status" to_be 1
}

@test '`git-credential-gh-switch` should accept account parameter' {
  # Skip this test if gh is not installed
  if ! command -v gh &> /dev/null ; then
    skip "gh command not found"
  fi

  # Skip this test if gh auth status fails (not authenticated)
  if ! gh auth status &> /dev/null ; then
    skip "gh not authenticated"
  fi

  # Test that the script runs without crashing when given proper input
  # We don't test actual credential retrieval as it requires gh authentication
  # The script may fail (exit non-zero) if account switch fails, but it should not crash
  run bash -c 'echo -e "protocol=https\nhost=github.com\n" | git-credential-gh-switch testuser get 2>&1'

  # Just verify the command executes (even if it fails due to invalid account)
  # The important thing is that the script doesn't crash with a syntax error
  # Accept exit codes 0 (success) and 1 (normal failure, e.g., invalid account); others indicate a crash
  if [[ "$status" -ne 0 && "$status" -ne 1 ]]; then
    echo "Unexpected exit status from git-credential-gh-switch: $status"
    return 1
  fi
  expects "$status" to_be_defined
}

@test '`git-credential-gh-switch` should work as credential helper via git credential fill' {
  skip_unless_real_jobs_enabled

  # Skip this test if gh is not installed
  if ! command -v gh &> /dev/null ; then
    skip "gh command not found"
  fi

  # Skip this test if gh auth status fails (not authenticated)
  if ! gh auth status &> /dev/null ; then
    skip "gh not authenticated"
  fi

  # Get current gh user
  local current_user
  current_user=$(gh api user -q .login 2>/dev/null || echo "")
  if [[ -z "$current_user" ]] ; then
    skip "Could not determine current gh user"
  fi

  # Create a temporary directory for testing
  local test_dir
  test_dir=$(mktemp -d)

  # Initialize a test repository to configure credential helper
  git init "$test_dir/test-repo"
  cd "$test_dir/test-repo"
  git config user.email "test@example.com"
  git config user.name "Test User"

  # Configure credential helper for GitHub
  git config --local credential.helper ''
  git config --local credential.https://github.com.helper "!$BATS_TEST_DIRNAME/../bin/git-credential-gh-switch $current_user"

  # Test credential helper using git credential fill
  # This actually invokes the credential helper with protocol=https and host=github.com
  run bash -c 'echo -e "protocol=https\nhost=github.com\n" | git credential fill'
  
  # Verify the command succeeded
  expects "$status" to_be 0
  
  # Verify the output contains credential information
  # The output should include protocol, host, username, and password
  expects "$output" to_contain "protocol=https"
  expects "$output" to_contain "host=github.com"
  expects "$output" to_contain "username="
  expects "$output" to_contain "password="

  # Cleanup
  cd /tmp
  rm -rf "$test_dir"
}
