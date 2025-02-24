#!/bin/bash

function source_if_exists () {
  if [[ -f $1 ]] ; then
    # shellcheck disable=SC1090
    source "$1"
  fi
}
