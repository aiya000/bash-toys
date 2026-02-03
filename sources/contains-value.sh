#!/bin/bash

# ```bash
# target=banana
# my_array=(apple banana cherry)
# if contains-value \"${my_array[@]}\" \"$target\" ';' then
#   echo 'It is in the array'
# else
#   echo 'It is not in the array'
# fi
# ```

function bash-toys::help::contains-value () {
  cat << 'EOF'
contains-value - Check if array contains a value

Usage:
  contains-value "${array[@]}" "value"
  contains-value -h | --help

Arguments:
  array...    Array elements
  value       Value to search for (last argument)

Examples:
  my_array=(apple banana cherry)
  if contains-value "${my_array[@]}" "banana"; then
    echo 'Found!'
  fi
EOF
}

function contains-value() {
  if [[ $1 == -h || $1 == --help ]] ; then
    bash-toys::help::contains-value
    return 0
  fi

  local array=("$@")
  local value_to_check="${array[-1]}"
  unset 'array[-1]'

  for element in "${array[@]}"; do
    if [[ $element == "$value_to_check" ]] ; then
      return 0
    fi
  done
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
