#!/bin/bash

# See ./doc/sources.md for description

function bash-toys::help::force-unexport () {
  cat << 'EOF'
force-unexport - Unexport a variable while keeping its value

Usage:
  force-unexport <var_name>...
  force-unexport -h | --help

Arguments:
  var_name    Variable name(s) to unexport

Examples:
  export FOO=1
  force-unexport FOO
  # FOO is now a local variable, not exported
EOF
}

function force-unexport() {
  if [[ $1 == -h || $1 == --help ]] ; then
    bash-toys::help::force-unexport
    return 0
  fi

  while [ "$#" -ne 0 ] ; do
    eval "set -- \"\${$1}\" \"\${$1+set}\" \"\$@\""
    if [[ -n $2 ]]; then
      unset "$3"
      eval "$3=\$1"
    fi
    shift
    shift
    shift
  done
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
