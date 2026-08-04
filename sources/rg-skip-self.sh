#!/bin/bash

# See ../doc/sources.md for description

function bash-toys::help::rg-skip-self () {
  cat << 'EOF'
rg-skip-self - Run rg and exclude its own process line from results

Usage:
  ... | rg-skip-self [RG_OPTIONS] PATTERN
  rg-skip-self -h | --help

Arguments:
  RG_OPTIONS    Options passed directly to rg
  PATTERN       Pattern passed directly to rg

Notes:
  Intended for piped use (e.g. `ps aux | rg-skip-self nginx`).
  Without a pipe, behaves exactly like rg.
  Excludes the line matching `rg-skip-self <args>` from results.

Examples:
  ps aux | rg-skip-self nginx
  ps aux | rg-skip-self -i NGINX
EOF
}

function rg-skip-self () {
  if [[ $1 == -h || $1 == --help ]] ; then
    bash-toys::help::rg-skip-self
    return 0
  fi

  if [[ -p /dev/stdin ]] ; then
    command rg "$@" | command rg -v -e "rg-skip-self $*" -e "rg $*"
  else
    command rg "$@"
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
