#!/bin/bash

# See ../doc/sources.md for description

# ZSH only — skip silently in bash
if [[ $ZSH_VERSION == '' ]] ; then
  return 0
fi

function bash-toys::help::zsh-vi-flash-find () {
  cat << 'EOF'
zsh-vi-flash-find - Vim-style f/F/t/T with flash.nvim-compatible repeat key

Usage:
  zsh-vi-flash-find-setup
  zsh-vi-flash-find-setup -h | --help

Description:
  Binds f, F, t, T in zsh vi-mode so that pressing the same key again
  repeats the motion (like `;` in Vim), matching flash.nvim's behavior.
  Pressing the counterpart key (f after F, or F after f) reverses direction
  (like `,` in Vim).

  Without this plugin:
    fa;;;   (standard zsh: `;` to repeat)

  With this plugin:
    fafff   (same as fa;;; -- f repeats forward)
    FaFFF   (same as Fa;;; -- F repeats backward)
    faFF    (fa forward, then FF reverses -- like fa,, in standard vi)
    FaFff   (Fa backward, then ff reverses forward)

  The first keypress acts as the original vi motion.
  Subsequent consecutive keypresses of the same key repeat the find.
  The counterpart key reverses direction.
  State resets when entering insert mode or starting a new command line.

  Keys bound:
    f   vi-find-next-char      (repeat forward with f; reverse with F)
    F   vi-find-prev-char      (repeat backward with F; reverse with f)
    t   vi-find-next-char-skip (repeat forward with t; reverse with T)
    T   vi-find-prev-char-skip (repeat backward with T; reverse with t)

  Note: This is a zsh-only feature (requires ZLE). The function is a no-op
  in bash.

Setup:
  Call zsh-vi-flash-find-setup in your .zshrc after entering vi mode:

    bindkey -v
    source /path/to/bash-toys/sources/zsh-vi-flash-find.sh
    zsh-vi-flash-find-setup

Examples:
  # In .zshrc
  bindkey -v
  zsh-vi-flash-find-setup

  # Then in the shell (vi normal mode):
  # fafff  =>  moves to next 'a', then repeats twice (like fa;;)
  # tbtb   =>  moves before next 'b', then repeats (like tbt;)
  # fafFF  =>  fa forward, f forward, FF backward twice
EOF
}

# _bash_toys_flash_find_last: widget name of the last f/F/t/T press; '' = no active search
# _bash_toys_flash_find_dir:  direction ZLE internally stored at the last new search
#   'forward'  -- vi-repeat-find goes forward  (after vi-find-next-char / vi-find-next-char-skip)
#   'backward' -- vi-repeat-find goes backward (after vi-find-prev-char / vi-find-prev-char-skip)
# Both are reset on keymap change away from vicmd and at the start of each new command line.
_bash_toys_flash_find_last=''
_bash_toys_flash_find_dir=''
_bash_toys_flash_find_hooks_registered=''

function _bash_toys_flash_find_reset () {
  _bash_toys_flash_find_last=''
  _bash_toys_flash_find_dir=''
}

# Called by add-zle-hook-widget keymap-select; $KEYMAP is the new keymap.
function _bash_toys_flash_find_keymap_select () {
  [[ $KEYMAP != vicmd ]] && _bash_toys_flash_find_reset
}

# Called by add-zle-hook-widget line-init; fires at the start of each new command line.
function _bash_toys_flash_find_line_init () {
  _bash_toys_flash_find_reset
}

# $1: widget_name -- this widget's id,      e.g. 'bash-toys::flash-find::f'
# $2: zle_motion  -- new-search motion,     e.g. 'vi-find-next-char'
# $3: native_dir  -- 'forward' or 'backward' (the direction this key represents)
# $4: counterpart -- the paired widget,     e.g. 'bash-toys::flash-find::F'
#
# Repeat/reverse logic:
#   same key or counterpart key pressed -> choose vi-repeat-find vs vi-rev-repeat-find
#   based on whether ZLE's stored direction (_bash_toys_flash_find_dir) matches native_dir.
#   If they match  -> vi-repeat-find    (ZLE goes the same way as this key's native direction)
#   If they differ -> vi-rev-repeat-find (ZLE goes the opposite way)
function _bash_toys_flash_find_widget () {
  local widget_name="$1"
  local zle_motion="$2"
  local native_dir="$3"
  local counterpart="$4"

  if [[ $_bash_toys_flash_find_last == "$widget_name" || $_bash_toys_flash_find_last == "$counterpart" ]] ; then
    if [[ $_bash_toys_flash_find_dir == "$native_dir" ]] ; then
      zle vi-repeat-find
    else
      zle vi-rev-repeat-find
    fi
  else
    zle "$zle_motion"
    _bash_toys_flash_find_dir="$native_dir"
  fi

  _bash_toys_flash_find_last="$widget_name"
}

function _bash_toys_flash_find_f () {
  _bash_toys_flash_find_widget 'bash-toys::flash-find::f' 'vi-find-next-char'      'forward'  'bash-toys::flash-find::F'
}

function _bash_toys_flash_find_F () {
  _bash_toys_flash_find_widget 'bash-toys::flash-find::F' 'vi-find-prev-char'      'backward' 'bash-toys::flash-find::f'
}

function _bash_toys_flash_find_t () {
  _bash_toys_flash_find_widget 'bash-toys::flash-find::t' 'vi-find-next-char-skip' 'forward'  'bash-toys::flash-find::T'
}

function _bash_toys_flash_find_T () {
  _bash_toys_flash_find_widget 'bash-toys::flash-find::T' 'vi-find-prev-char-skip' 'backward' 'bash-toys::flash-find::t'
}

function zsh-vi-flash-find-setup () {
  if [[ $1 == -h || $1 == --help ]] ; then
    bash-toys::help::zsh-vi-flash-find
    return 0
  fi

  zle -N bash-toys::flash-find::f _bash_toys_flash_find_f
  zle -N bash-toys::flash-find::F _bash_toys_flash_find_F
  zle -N bash-toys::flash-find::t _bash_toys_flash_find_t
  zle -N bash-toys::flash-find::T _bash_toys_flash_find_T

  bindkey -M vicmd 'f' bash-toys::flash-find::f
  bindkey -M vicmd 'F' bash-toys::flash-find::F
  bindkey -M vicmd 't' bash-toys::flash-find::t
  bindkey -M vicmd 'T' bash-toys::flash-find::T

  if [[ -z $_bash_toys_flash_find_hooks_registered ]] ; then
    autoload -Uz add-zle-hook-widget
    add-zle-hook-widget keymap-select _bash_toys_flash_find_keymap_select
    add-zle-hook-widget line-init     _bash_toys_flash_find_line_init
    _bash_toys_flash_find_hooks_registered=1
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
