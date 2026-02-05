#!/bin/bash

# See ../doc/sources.md for description

function bash-toys::help::cd-to-git-root () {
  cat << 'EOF'
cd-to-git-root - Change directory to git repository root

Usage:
  cd-to-git-root
  cd-to-git-root -h | --help

Description:
  Changes to the root directory of the current git repository.
  Supports WSL path conversion when running on Windows file systems.
EOF
}

function cd-to-git-root () {
  if [[ $1 == -h || $1 == --help ]] ; then
    bash-toys::help::cd-to-git-root
    return 0
  fi

  local root
  root=$(git rev-parse --show-toplevel 2> /dev/null || return 1)
  # shellcheck disable=SC2164
  cd "$root"

  # Try recover with wslpath if simple is failed
  # shellcheck disable=SC2181
  if [[ $? -ne 0 ]] && command -v wslpath > /dev/null 2>&1 ; then
    root=$(wslpath "$root")
    echo "cd-to-git-root: Using wslpath: $root"
    cd "$root" || return 1
    return
  fi

  echo "$root"
}

# https://github.com/aiya000/bash-toys
#
# The MIT License (MIT)
#
# Copyright (c) 2025- aiya000
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
