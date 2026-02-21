#!/bin/bash

# Bash completion for expects command

_expects_completion() {
  local cur prev
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  local matchers='to_be to_equal to_be_less_than lt to_be_greater_than gt to_be_less_than_or_equal_to le to_be_greater_than_or_equal_to ge to_contain to_match to_be_true to_be_false to_be_defined to_be_a_file to_be_a_dir'

  if [[ $cur == -* ]] ; then
    COMPREPLY=($(compgen -W '--help -h' -- "$cur"))
    return
  fi

  # Position 1: value (no completion)
  # Position 2: 'not' or matcher
  # Position 3: matcher (if position 2 was 'not') or expected value
  local cword=${COMP_CWORD}

  if [[ $cword -eq 2 ]] ; then
    COMPREPLY=($(compgen -W "not $matchers" -- "$cur"))
  elif [[ $cword -eq 3 && $prev == 'not' ]] ; then
    COMPREPLY=($(compgen -W "$matchers" -- "$cur"))
  fi
}

complete -F _expects_completion expects

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
