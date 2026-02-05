#!/bin/bash

# See ../doc/sources.md for description

function bash-toys::help::get-var () {
  cat << 'EOF'
get-var - Get value of variable by name

Usage:
  get-var <var_name>
  get-var -h | --help

Arguments:
  var_name    Name of the variable to read

Examples:
  name=42
  get-var name    # Output: 42
  get-var undefined || echo 'not found'
EOF
}

function get-var () {
  if [[ $1 == -h || $1 == --help ]] ; then
    bash-toys::help::get-var
    return 0
  fi

  local var_name=$1 result
  result=$(eval "echo \$$var_name")
  if [[ $result == '' ]] ; then
    return 1
  fi
  echo "$result"
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
