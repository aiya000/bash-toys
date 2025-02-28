#!/bin/bash

# `cd` to the git root directory.
# The behavior when Atata is on a Windows file system with WSL is also supported.
#
# ```shell-session
# TODO: Write an example
# ```

function cd-to-git-root () {
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
