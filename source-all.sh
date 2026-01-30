#!/bin/bash

# Load all sources
# ```shell-session
# $ source path/to/bash-toys/source-all.sh
# ```

dir="$(cd -- "$(dirname -- "${BASH_SOURCE:-$0}")" && pwd || exit 1)"

PATH="$PATH:$dir/bin"

# Depenencies
source "$dir"/lib/fun.sh

for script in "$dir"/sources/* ; do
  # shellcheck disable=SC1090
  # NOTE: `|| true` is needed because some scripts (e.g., nvim-parent-edit.sh)
  # may return 1 when required environment variables are not set.
  # This allows source-all.sh to work correctly with `bash -e` (set -e).
  source "$script" || true
done
