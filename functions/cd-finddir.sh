#!/bin/bash

#
# Shows all directories of 6 depth (if `fd` is available, or 3 depth for `find`), and cd to a directory you selected.
#

dir=$(dirname "$0")

# shellcheck disable=SC1091
source "$dir/../default-options.sh"

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
