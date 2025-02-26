#!/bin/bash

#
# Shows all directories of 6 depth (if `fd` is available, or 3 depth for `find`), and cd to a directory you selected.
#

dir=$(dirname "$0")

# shellcheck disable=SC1091
source "$dir/../define-options.sh"

function cd-finddir () {
  local finddir
  if command -v fd > /dev/null 2>&1 ; then
    finddir='fd --max-depth 6 --type d'
  else
    finddir='find . -maxdepth 3 -type d'
  fi

  local filter
  if [[ $BASH_TOYS_INTERACTIVE_FILTER == 'peco' ]] ; then
    filter='peco --select-1 --initial-filter Fuzzy'
  else
    filter=fzf
  fi

  local target_dir
  target_dir=$( \
    eval "$finddir" \
      | awk '{print $1 " / " gsub("/", $1)}' \
      | sed -r 's/(.*) \/ (.*)/\2 \/ \1/g' \
      | sort -n \
      | sed -r 's/(.*) \/ (.*)/\2/g' \
      | eval "$filter" \
  )

  # shellcheck disable=SC2181
  if [[ $? -eq 0 ]] ; then
    cd "$target_dir" || exit 1
  fi
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
