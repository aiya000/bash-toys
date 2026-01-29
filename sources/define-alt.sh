#!/bin/bash

# Defines a variable of the first argument meaning the name, if the specified variable name is doesn't exist.
#
# Simple usage:
# ```shell-session
# $ define-alt a 10
# $ echo $a
# 10
# ```
#
# If already defined, the value is not changed.
# ```shell-session
# $ b=20
# $ define-alt b 30
# $ echo $b
# 20
# ```
#
# Define an empty variable if no value is specified.
# ```shell-session
# $ define-alt foo
# $ declare foo
# foo=''
# ```
#
# Define an array variable if two or more arguments of value specified.
# ```shell-session
# $ define-alt xs 1 2
# $ is-array xs && echo yes || echo no
# yes
# ```
#
# Define an empty with --empty-array.
# ```shell-session
# $ define-alt --empty-array xs
# $ is-array xs && echo yes || echo no
# yes
# $ echo ${#xs}
# 0
# ```

function define-alt () {
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
