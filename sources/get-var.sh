#!/bin/bash

# Reads a variable value of the name.
#
# ```shell-session
# $ name=42
# $ get-var name
# 42
# ```
#
# ```shell-session
# $ [[ $name == '' ]] && echo 'name is empty'
# name is empty
# $ get-var name || echo 'not found'
# not found
# ```

function get-var () {
  local var_name=$1 result
  result=$(eval "echo \$$var_name")
  if [[ $result == '' ]] ; then
    return 1
  fi
  echo "$result"
}

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
