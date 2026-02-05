#!/bin/bash

# See ../doc/sources.md for description

if [[ $NVIM_PARENT_ADDRESS == '' ]] ; then
  return 1
fi

function bash-toys::help::nvim-parent-edit () {
  cat << 'EOF'
nvim-parent-edit - Open file in parent Neovim via RPC

Usage:
  nvim-parent-edit <open_method> <filename>
  nvim-parent-edit -h | --help

Arguments:
  open_method   One of: tabnew, split, vsplit
  filename      File to open

Environment:
  NVIM_PARENT_ADDRESS    Neovim server address (set automatically)

Related functions:
  nvim-parent-tabnew <file>   - Open in new tab
  nvim-parent-split <file>    - Open in horizontal split
  nvim-parent-vsplit <file>   - Open in vertical split

Examples:
  nvim-parent-edit tabnew myfile.txt
  nvim-parent-tabnew myfile.txt
EOF
}

function nvim-parent-edit() {
  if [[ $1 == -h || $1 == --help ]] ; then
    bash-toys::help::nvim-parent-edit
    return 0
  fi

  if [[ $# -eq 0 ]] ; then
    echo 'Usage: nvim-parent-edit <open_method> <filename>'
    return 1
  fi

  if [[ $NVIM_PARENT_ADDRESS == '' ]] ; then
    echo 'NVIM_PARENT_ADDRESS is not set. '
    return 1
  fi

  local open_method="$1"
  if [[ $open_method == '' ]] ; then
    echo 'Usage: nvim-parent-edit <open_method> <filename>'
    return 1
  fi

  # Get the absolute file path
  local filepath="$2"
  if [[ "$filepath" != /* ]] ; then
    filepath="$(realpath "$filepath")"
  fi

  # Open file in parent Neovim
  local result_code=0
  case $open_method in
    tabnew)
      nvim --server "$NVIM_PARENT_ADDRESS" --remote-tab "$filepath" 2>/dev/null
      result_code=$?
      ;;
    split)
      echo 'split method is not yet implemented' 2>&1
      return 1
      # TODO: Implement
      # local vim_command
      # vim_command=$(printf "execute('split ' .. shellescape('%s'))" "$filepath")
      # nvim --server "$NVIM_PARENT_ADDRESS" --remote-expr "$vim_command" 2>/dev/null
      # result_code=$?
      ;;
    vsplit)
      echo 'vsplit method is not yet implemented' 2>&1
      return 1
      # TODO: Implement
      # local vim_command
      # vim_command=$(printf "execute('vsplit ' .. shellescape('%s'))" "$filepath")
      # nvim --server "$NVIM_PARENT_ADDRESS" --remote-expr "$vim_command" 2>/dev/null
      # result_code=$?
      ;;
    *)
      echo "Unknown open method: $open_method"
      return 1
      ;;
  esac

  if [[ $result_code == 0 ]] ; then
    echo "✓ Opened '$filepath' in parent Neovim"
    return
  fi

  echo "✗ Failed to open file in parent Neovim"
  return 1
}

function nvim-parent-tabnew() {
  nvim-parent-edit tabnew "$1"
}

function nvim-parent-split() {
  nvim-parent-edit split "$1"
}

function nvim-parent-vsplit() {
  nvim-parent-edit vsplit "$1"
}

echo "✓ Parent Neovim RPC integration ready (server: $NVIM_PARENT_ADDRESS)"

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
