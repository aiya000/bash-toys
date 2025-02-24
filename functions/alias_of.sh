#!/bin/bash

# If $1 exists, create an alias for $1 with the contents of $2 and overwrite it.
#
# Example:
#
# $ alias_of mysql 'mysql --pager="less -r -S -n -i -F -X"'

function alias_of () {
  local name=$1 detail=$2
  if command -v "$name" > /dev/null 2>&1 ; then
    eval "alias $name=$detail"
  fi
}
