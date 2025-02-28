#!/bin/bash

# ```shell-session
# $ source path/to/bash-toys/define-options.sh
# ```

[[ -n $BASH_TOYS_LOADED_DEFAULT_OPTIONS ]] && return

dir="$(cd -- "$(dirname -- "${BASH_SOURCE:-$0}")" && pwd || exit 1)"
source "$dir/sources/define-alt-export.sh"

# TODO: Temporary overwrite variables. Shoud be fixed by using define-alt-export
unset BASH_TOYS_INTERACTIVE_FILTER || true
unset BASH_TOYS_DUSTBOX_DIR || true
unset BASH_TOYS_MUSIC_PLAYER || true
unset BASH_TOYS_POMODORO_NOTIFICATION_MUSIC || true
unset BASH_TOYS_BATCAT_OPTIONS || true
export BASH_TOYS_INTERACTIVE_FILTER=peco
export BASH_TOYS_DUSTBOX_DIR="$HOME/.backup/dustbox"
export BASH_TOYS_MUSIC_PLAYER=vlc
export BASH_TOYS_POMODORO_NOTIFICATION_MUSIC="$dir/assets/notify.mp3"
export BASH_TOYS_BATCAT_OPTIONS=--number

export BASH_TOYS_LOADED_DEFAULT_OPTIONS=true
