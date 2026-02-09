#!/bin/bash

# Bash completion for rm-dust command

_rm_dust_completion() {
  local cur prev words cword
  _init_completion || return

  # If --restore option is present, complete with dustbox files
  local restore_mode=false
  for word in "${words[@]}"; do
    if [[ $word == '--restore' ]] ; then
      restore_mode=true
      break
    fi
  done

  if [[ $cur == -* ]] ; then
    # Complete options
    COMPREPLY=($(compgen -W '--help -h --restore' -- "$cur"))
  elif [[ $restore_mode == 'true' ]] ; then
    # Complete with files from dustbox
    if [[ -d $BASH_TOYS_DUSTBOX_DIR ]] ; then
      local dustbox_files
      dustbox_files=$(ls -1 "$BASH_TOYS_DUSTBOX_DIR" 2>/dev/null)
      if [[ $dustbox_files != '' ]] ; then
        COMPREPLY=($(compgen -W "$dustbox_files" -- "$cur"))
      fi
    fi
  else
    # Default file completion
    _filedir
  fi
}

complete -F _rm_dust_completion rm-dust

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
