#!/bin/bash

# Load all sources
# ```shell-session
# $ source path/to/bash-toys/source-all.sh
# ```

dir="$(cd -- "$(dirname -- "${BASH_SOURCE:-$0}")" && pwd || exit 1)"

PATH="$PATH:$dir/bin"

for script in "$dir"/sources/* ; do
  # shellcheck disable=SC1090
  source "$script"
done
