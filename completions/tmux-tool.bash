#!/bin/bash

# Bash completion for tmux-tool command

_tmux_tool_completion() {
  local cur
  cur="${COMP_WORDS[COMP_CWORD]}"

  local subcommands='attach-with-new-session'

  if [[ ${COMP_CWORD} == 1 ]] ; then
    if [[ $cur == -* ]] ; then
      COMPREPLY=($(compgen -W '--help -h' -- "$cur"))
    else
      COMPREPLY=($(compgen -W "$subcommands" -- "$cur"))
    fi
    return
  fi

  # Complete existing session names for `attach-with-new-session`
  if [[ ${COMP_WORDS[1]} == 'attach-with-new-session' && ${COMP_CWORD} == 2 ]] ; then
    local sessions
    sessions=$(tmux list-sessions -F '#{session_name}' 2> /dev/null)
    COMPREPLY=($(compgen -W "$sessions" -- "$cur"))
  fi
}

complete -F _tmux_tool_completion tmux-tool

# https://github.com/aiya000/bash-toys
#
# The MIT License (MIT)
#
# Copyright (c) 2026- aiya000
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
