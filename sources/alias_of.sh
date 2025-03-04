#!/bin/bash

# If `$1` exists, create an alias for `$1` with the contents of `$2` and overwrite it.
#
# ```shell-session
# $ alias_of rg 'rg --color always --hidden'
# $ alias rg
# rg='rg --color always --hidden'
# ```

function alias_of () {
  local name=$1 detail=$2
  if command -v "$name" > /dev/null 2>&1 ; then
    eval "alias $name='$detail'"
  fi
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
