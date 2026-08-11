#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"

  mock_bin="$(mktemp -d)"
  export PATH="$mock_bin:$PATH"
}

teardown() {
  rm -rf "$mock_bin"
}

@test '`git-bridge-wsl-and-windows --help` should show help message' {
  run git-bridge-wsl-and-windows --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^git-bridge-wsl-and-windows - '
}

@test '`git-bridge-wsl-and-windows -h` should show help message' {
  run git-bridge-wsl-and-windows -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^git-bridge-wsl-and-windows - '
}

@test '`git-bridge-wsl-and-windows` should use WSL2 git by default (outside a Windows-mounted path)' {
  printf '#!/bin/bash\necho "wsl2: $*"\n' > "$mock_bin/mock-git-wsl2"
  chmod +x "$mock_bin/mock-git-wsl2"

  run env GIT_BRIDGE_WSL2_AND_WINDOWS_GIT_WSL2=mock-git-wsl2 git-bridge-wsl-and-windows status
  expects "$status" to_be 0
  expects "$output" to_equal 'wsl2: status'
}

@test '`git-bridge-wsl-and-windows` should use Windows git when the current directory is on a Windows-mounted path' {
  printf '#!/bin/bash\nexit 0\n' > "$mock_bin/is-in-windows-path"
  chmod +x "$mock_bin/is-in-windows-path"
  printf '#!/bin/bash\necho "windows: $*"\n' > "$mock_bin/mock-git-windows"
  chmod +x "$mock_bin/mock-git-windows"

  run env GIT_BRIDGE_WSL2_AND_WINDOWS_GIT_WINDOWS=mock-git-windows git-bridge-wsl-and-windows status
  expects "$status" to_be 0
  expects "$output" to_equal 'windows: status'
}

@test '`git-bridge-wsl-and-windows` should translate absolute Unix paths to Windows paths for git.exe' {
  printf '#!/bin/bash\necho "C:\\\\mockpath\\\\$(basename "$2")"\n' > "$mock_bin/wslpath"
  chmod +x "$mock_bin/wslpath"
  printf '#!/bin/bash\necho "windows: $*"\n' > "$mock_bin/mock-git-windows"
  chmod +x "$mock_bin/mock-git-windows"

  run env \
    GIT_BRIDGE_WSL2_AND_WINDOWS_USE_WINDOWS=1 \
    GIT_BRIDGE_WSL2_AND_WINDOWS_GIT_WINDOWS=mock-git-windows \
    git-bridge-wsl-and-windows status /mnt/c/Users/aiya0/repo
  expects "$status" to_be 0
  expects "$output" to_equal 'windows: status C:\\mockpath\\repo'
}

@test '`git-bridge-wsl-and-windows` with GIT_BRIDGE_WSL2_AND_WINDOWS_DIRECT=1 should skip path translation' {
  printf '#!/bin/bash\necho "windows: $*"\n' > "$mock_bin/mock-git-windows"
  chmod +x "$mock_bin/mock-git-windows"

  run env \
    GIT_BRIDGE_WSL2_AND_WINDOWS_USE_WINDOWS=1 \
    GIT_BRIDGE_WSL2_AND_WINDOWS_GIT_WINDOWS=mock-git-windows \
    GIT_BRIDGE_WSL2_AND_WINDOWS_DIRECT=1 \
    git-bridge-wsl-and-windows status /mnt/c/Users/aiya0/repo
  expects "$status" to_be 0
  expects "$output" to_equal 'windows: status /mnt/c/Users/aiya0/repo'
}

@test '`git-bridge-wsl-and-windows` with GIT_BRIDGE_WSL2_AND_WINDOWS_USE_WSL2=1 should force WSL2 git' {
  printf '#!/bin/bash\nexit 0\n' > "$mock_bin/is-in-windows-path"
  chmod +x "$mock_bin/is-in-windows-path"
  printf '#!/bin/bash\necho "wsl2: $*"\n' > "$mock_bin/mock-git-wsl2"
  chmod +x "$mock_bin/mock-git-wsl2"

  run env \
    GIT_BRIDGE_WSL2_AND_WINDOWS_USE_WSL2=1 \
    GIT_BRIDGE_WSL2_AND_WINDOWS_GIT_WSL2=mock-git-wsl2 \
    git-bridge-wsl-and-windows status
  expects "$status" to_be 0
  expects "$output" to_equal 'wsl2: status'
}

@test '`git-bridge-wsl-and-windows` with DEBUG=1 should print debug info' {
  printf '#!/bin/bash\necho "wsl2: $*"\n' > "$mock_bin/mock-git-wsl2"
  chmod +x "$mock_bin/mock-git-wsl2"

  run env DEBUG=1 GIT_BRIDGE_WSL2_AND_WINDOWS_GIT_WSL2=mock-git-wsl2 git-bridge-wsl-and-windows status
  expects "$status" to_be 0
  expects "$output" to_match 'git_bridge_wsl2_and_windows: Using WSL2 git'
}
