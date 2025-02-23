#!/bin/bash

# - - -
# Integrates this plugin.
# - - -

dir=$(dirname "${BASH_SOURCE[0]}")

PATH="$PATH:$dir/bin"

for script in "$dir"/functions/* ; do
  # shellcheck disable=SC1090
  source "$script"
done
