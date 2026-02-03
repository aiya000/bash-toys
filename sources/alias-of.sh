#!/bin/bash

# See ./doc/sources.md for description

function bash-toys::help::alias-of () {
  cat << 'EOF'
alias-of - Create alias if command exists

Usage:
  alias-of <name> <detail>
  alias-of -h | --help

Arguments:
  name      Command name to check and alias
  detail    Alias definition (the full command)

Examples:
  alias-of rg 'rg --color always --hidden'
  alias-of bat 'bat --theme=TwoDark'
EOF
}

function alias-of () {
  if [[ $1 == -h || $1 == --help ]] ; then
    bash-toys::help::alias-of
    return 0
  fi

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
