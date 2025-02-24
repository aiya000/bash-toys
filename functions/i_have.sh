#!/bin/bash

# A shorthand to check a specified command does exist or not.
#
# Example:
#
# ```bash
# if i_have batcat ; then
#   alias bat=batcat
# fi
# ```

function i_have () {
  command -v "$1" > /dev/null 2>&1
}
