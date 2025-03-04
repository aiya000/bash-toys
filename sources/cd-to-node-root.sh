#!/bin/bash

# `cd` to a directory that have a `package.json`.
#
# ```shell-session
# TODO: Write an example
# ```

function cd-to-node-root::find-node-root-dir () {
  local current_dir=$1

  if [[ $(realpath "$current_dir") == / ]]  ; then
    return 1
  fi

  if ls "$current_dir/package.json" > /dev/null 2>&1 ; then
    echo "$current_dir"
    return 0
  fi

  cd-to-node-root::find-node-root-dir "$current_dir/.."
}

function cd-to-node-root () {
  local root
  root=$(cd-to-node-root::find-node-root-dir .)
  if [[ $root == '' ]] ; then
    echo 'No package.json found'
    return 1
  fi
  cd "$root" || exit 1
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
