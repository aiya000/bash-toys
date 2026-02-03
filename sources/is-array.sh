#!/bin/bash

# Checks a taken var name is an array.
#
# ```shell-session
# $ foo=()
# $ is-array foo && echo yes || echo no
# yes
#
# $ foo=1
# $ is-array foo && echo yes || echo no
# no
# ```

function bash-toys::help::is-array () {
  cat << 'EOF'
is-array - Check if variable is an array

Usage:
  is-array <var_name>
  is-array -h | --help

Arguments:
  var_name    Name of the variable to check

Examples:
  foo=()
  is-array foo && echo yes  # Output: yes

  bar=1
  is-array bar && echo yes  # (no output)
EOF
}

function is-array () {
  if [[ $1 == -h || $1 == --help ]] ; then
    bash-toys::help::is-array
    return 0
  fi

  local target_var_name=$1 target_var_type
  target_var_type=$(declare -p "$target_var_name" 2>/dev/null)

  # Bash
  if [[ $target_var_type =~ declare\ -[aA] ]] ; then
    return 0
  fi

  # Zsh
  if [[ $target_var_type =~ typeset\ -g\ -a ]] ; then
    return 0
  fi

  return 1
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
