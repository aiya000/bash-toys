#!/bin/bash

# See ../doc/sources.md for description

dir="$(cd -- "$(dirname -- "${BASH_SOURCE:-$0}")" && pwd || exit 1)"

# shellcheck disable=SC1091
source "$dir/define-alt.sh"

function bash-toys::help::define-alt-export () {
  cat << 'EOF'
define-alt-export - Define and export variable if not already defined

Usage:
  define-alt-export <var_name> [value...]
  define-alt-export -h | --help

Description:
  Alias for `define-alt --export`. See define-alt --help for detailed usage.

Examples:
  define-alt-export BASH_TOYS_INTERACTIVE_FILTER peco
EOF
}

function define-alt-export () {
  if [[ $1 == -h || $1 == --help ]] ; then
    bash-toys::help::define-alt-export
    return 0
  fi

  define-alt --export "$@"
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
