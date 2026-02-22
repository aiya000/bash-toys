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

@test '`git-credential-gh-switch` should switch account and delegate to gh auth git-credential' {
  # Mock gh command
  function gh() {
    if [[ $1 == 'auth' && $2 == 'switch' && $3 == '--user' && $4 == 'testuser' ]] ; then
      # Simulate successful account switch
      return 0
    fi
    if [[ $1 == 'auth' && $2 == 'git-credential' && $3 == 'get' ]] ; then
      # Simulate credential output from gh auth git-credential
      cat << 'CREDENTIALS'
protocol=https
host=github.com
username=testuser
password=ghp_mocktoken123456789
CREDENTIALS
      return 0
    fi
    return 1
  }
  export -f gh

  # Test with proper git credential input
  run bash -c 'echo -e "protocol=https\nhost=github.com\n" | git-credential-gh-switch testuser get'
  
  expects "$status" to_be 0
  expects "$output" to_contain 'username=testuser'
  expects "$output" to_contain 'password=ghp_mocktoken123456789'
}

@test '`git-credential-gh-switch` should pass through git credential operation' {
  # Track which commands were called
  local switch_called=false
  local credential_called=false
  
  # Mock gh command
  function gh() {
    if [[ $1 == 'auth' && $2 == 'switch' && $3 == '--user' ]] ; then
      switch_called=true
      return 0
    fi
    if [[ $1 == 'auth' && $2 == 'git-credential' ]] ; then
      credential_called=true
      # Echo the operation type that was passed
      echo "operation: $3"
      return 0
    fi
    return 1
  }
  export -f gh
  export switch_called credential_called

  # Test 'store' operation
  run bash -c 'echo -e "protocol=https\nhost=github.com\n" | git-credential-gh-switch myaccount store'
  expects "$status" to_be 0
  expects "$output" to_contain 'operation: store'

  # Test 'erase' operation
  run bash -c 'echo -e "protocol=https\nhost=github.com\n" | git-credential-gh-switch myaccount erase'
  expects "$status" to_be 0
  expects "$output" to_contain 'operation: erase'
}

@test '`git-credential-gh-switch` should continue even if account switch fails' {
  # Mock gh command where switch fails but credential succeeds
  function gh() {
    if [[ $1 == 'auth' && $2 == 'switch' ]] ; then
      # Simulate switch failure (e.g., account not found)
      echo "error: no account found for user" >&2
      return 1
    fi
    if [[ $1 == 'auth' && $2 == 'git-credential' && $3 == 'get' ]] ; then
      # Credential operation still works (uses current account)
      cat << 'CREDENTIALS'
protocol=https
host=github.com
username=currentuser
password=ghp_currenttoken
CREDENTIALS
      return 0
    fi
    return 1
  }
  export -f gh

  # The script should continue and return credentials even if switch fails
  # (because of the '|| true' in the script)
  run bash -c 'echo -e "protocol=https\nhost=github.com\n" | git-credential-gh-switch nonexistent get'
  
  expects "$status" to_be 0
  expects "$output" to_contain 'username=currentuser'
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
  local test_dir original_dir
  test_dir=$(mktemp -d)
  original_dir=$(pwd)

  # Create bare repository (remote) with main as default branch
  git init --bare --initial-branch=main "$test_dir/remote-repo.git"

  # Clone and setup main repository
  git clone "$test_dir/remote-repo.git" "$test_dir/main-repo"
  cd "$test_dir/main-repo"
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
  cd "$original_dir"
  rm -rf "$test_dir"
}
