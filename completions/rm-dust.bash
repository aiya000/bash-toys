#!/bin/bash

# Bash completion for rm-dust command

_rm_dust_completion() {
  local cur prev
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  # If --restore option is present, complete with dustbox files
  local restore_mode=false
  local word
  for word in "${COMP_WORDS[@]}"; do
    if [[ $word == '--restore' ]] ; then
      restore_mode=true
      break
    fi
  done

  if [[ $cur == -* ]] ; then
    # Complete options
    COMPREPLY=($(compgen -W '--help -h --restore --keep --list' -- "$cur"))
  elif [[ $restore_mode == 'true' ]] ; then
    # Complete with paths from dustbox (supports YYYY-MM-DD-HH/filename format)
    if [[ -d $BASH_TOYS_DUSTBOX_DIR ]] ; then
      COMPREPLY=()
      local dir_part file_part target_dir
      if [[ $cur == */* ]] ; then
        dir_part="${cur%/*}/"
        file_part="${cur##*/}"
      else
        dir_part=""
        file_part="$cur"
      fi
      target_dir="${BASH_TOYS_DUSTBOX_DIR}/${dir_part}"
      if [[ -d $target_dir ]] ; then
        local entry
        while IFS= read -r entry; do
          [[ $entry == '' ]] && continue
          # Skip entries not matching current prefix (substring comparison to avoid glob issues)
          [[ $file_part != '' && ${entry:0:${#file_part}} != $file_part ]] && continue
          if [[ -d "${target_dir}${entry}" ]] ; then
            COMPREPLY+=("${dir_part}${entry}/")
          else
            COMPREPLY+=("${dir_part}${entry}")
          fi
        done < <(ls -1 "${target_dir}" 2>/dev/null)
        # Enable filename mode so bash properly escapes spaces in completion candidates
        compopt -o filenames 2>/dev/null || :
      fi
    fi
  else
    # Leave COMPREPLY empty so the shell falls back to its built-in file/directory
    # completion (enabled via -o default on the complete registration below).
    # This correctly handles ~/, spaces in filenames, etc. — same behaviour as rm.
    COMPREPLY=()
  fi
}

complete -o default -F _rm_dust_completion rm-dust

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
