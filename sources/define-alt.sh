#!/bin/bash

# See ../doc/sources.md for description

function bash-toys::help::define-alt () {
  cat << 'EOF'
define-alt - Define variable if not already defined

Usage:
  define-alt [--export] <var_name> [value...]
  define-alt [--export] --empty-array <var_name>
  define-alt -h | --help

Arguments:
  var_name      Variable name to define
  value         Value(s) to assign (multiple = array)

Options:
  --export      Also export the variable
  --empty-array Define an empty array variable

Notes:
  Array variables defined with --export are available in the current shell,
  but cannot be passed to child processes via the environment. This is a
  POSIX limitation: the environment only supports string key=value pairs,
  so arrays are silently reduced to a scalar when exported.
  Neither bash nor zsh can work around this constraint.

Examples:
  define-alt a 10                    # Define scalar
  define-alt xs 1 2 3               # Define array
  define-alt --empty-array ys       # Define empty array
  define-alt --export EDITOR vim    # Define and export
EOF
}

function define-alt () {
  if [[ $1 == -h || $1 == --help ]] ; then
    bash-toys::help::define-alt
    return 0
  fi

  local export_flag=false
  local positional=()
  for arg in "$@" ; do
    if [[ $arg == --export ]] ; then
      export_flag=true
    else
      positional+=("$arg")
    fi
  done
  set -- "${positional[@]}"

  local var_name=$1

  # Do nothing if the variable is already defined
  if [[ $1 != --empty-array ]] && eval "[[ \$$var_name != '' ]]" ; then
    return
  fi

  # Define an empty array variable
  if [[ $1 == --empty-array ]] ; then
    var_name=$2
    eval "$var_name=()"
    if [[ $export_flag == true ]] ; then
      export "$var_name"
    fi
    return
  fi
  local value=$2
  local values_length=$#

  # Define an empty variable or a variable with a value
  if [[ $values_length -le 1 ]] ; then
    eval "$var_name=$value"
    if [[ $export_flag == true ]] ; then
      export "$var_name"
    fi
    return
  fi

  # Define an array variable with elements
  local remaining_args=("$@") values_last_index values
  values_last_index=$((values_length - 1))
  values=("${remaining_args[@]:1:$values_last_index}")
  eval "$var_name=(${values[*]})"
  if [[ $export_flag == true ]] ; then
    export "$var_name"
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
