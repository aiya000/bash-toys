#!/bin/bash

# See ./doc/sources.md for description

function bash-toys::help::define-alt () {
  cat << 'EOF'
define-alt - Define variable if not already defined

Usage:
  define-alt <var_name> [value...]
  define-alt --empty-array <var_name>
  define-alt -h | --help

Arguments:
  var_name      Variable name to define
  value         Value(s) to assign (multiple = array)

Options:
  --empty-array Define an empty array variable

Examples:
  define-alt a 10           # Define scalar
  define-alt xs 1 2 3       # Define array
  define-alt --empty-array ys  # Define empty array
EOF
}

function define-alt () {
  if [[ $1 == -h || $1 == --help ]] ; then
    bash-toys::help::define-alt
    return 0
  fi

  local var_name=$1

  # Do nothing if the variable is already defined
  if [[ $1 != --empty-array ]] && eval "[[ \$$var_name != '' ]]" ; then
    return
  fi

  # Define an empty array variable
  if [[ $1 == --empty-array ]] ; then
    var_name=$2
    eval "$var_name=()"
    return
  fi
  local value=$2
  local values_length=$#

  # Define an empty variable or a variable with a value
  if [[ $values_length -le 1 ]] ; then
    eval "$var_name=$value"
    return
  fi

  # Define an array variable with elements
  local args=("$@") values_last_index values
  values_last_index=$((values_length - 1))
  values=("${args[@]:1:$values_last_index}")
  eval "$var_name=(${values[*]})"
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
