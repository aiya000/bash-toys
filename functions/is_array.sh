#!/bin/bash

# Check a taken var name is an array
#
# Example:
# ```shell-session
# $ foo=()
# $ is_array foo && echo yes || echo no
# yes
#
# $ foo=1
# $ is_array foo && echo yes || echo no
# no
# ```

function is_array () {
  local target_var_name=$1 target_var_type
  target_var_type=$(declare -p "$target_var_name" 2>/dev/null)

  # Bash
  if [[ $target_var_type =~ declare\ -[aA] ]] ; then
    return 0
  fi

  # Zsh
  if [[ $target_var_type =~ typeset\ -g\ -a ]] ; then
    return 0
  fi

  return 1
}
