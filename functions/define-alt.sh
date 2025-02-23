#!/bin/bash

# If the shell variable specified in the first argument is not defined, define it with the contents of the second argument.
#
# Example
#
# $ define-alt BASH_TOYS_INTERACTIVE_FILTER peco

function define-alt () {
  if eval "[[ -z \$$1 ]]" ; then
    eval "$1=\"$2\""
  fi
}
