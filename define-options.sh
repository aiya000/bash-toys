#!/bin/bash

# ```shell-session
# $ source path/to/bash-toys/define-options.sh
# ```

[[ -n $BASH_TOYS_LOADED_DEFAULT_OPTIONS ]] && return

dir="$(cd -- "$(dirname -- "${BASH_SOURCE:-$0}")" && pwd || exit 1)"
source "$dir/sources/define-alt-export.sh"

define-alt-export BASH_TOYS_INTERACTIVE_FILTER peco # or fzf
define-alt-export BASH_TOYS_DUSTBOX_DIR "$HOME/.backup/dustbox"
define-alt-export BASH_TOYS_MUSIC_PLAYER vlc
define-alt-export BASH_TOYS_POMODORO_NOTIFICATION_MUSIC "$dir/assets/notify.mp3"
define-alt-export BASH_TOYS_BATCAT_OPTIONS '--number'
define-alt-export BASH_TOYS_BOOKMARK_URLS

export BASH_TOYS_LOADED_DEFAULT_OPTIONS=true
