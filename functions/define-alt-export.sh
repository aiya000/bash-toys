#!/bin/bash

# Similar to ./define-alt, but this one performs `export`
#
# Example
#
# $ define-alt-export BASH_TOYS_INTERACTIVE_FILTER peco

function define-alt-export () {
  if eval "[[ -z \$$1 ]]" ; then
    eval "export $1=\"$2\""
  fi
}
