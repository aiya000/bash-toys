#!/bin/bash

# ```shell-session
# $ source path/to/bash-toys/define-options.sh
# ```

[[ -n $BASH_TOYS_LOADED_DEFAULT_OPTIONS ]] && return

dir="$(cd -- "$(dirname -- "${BASH_SOURCE:-$0}")" && pwd || exit 1)"

# Set default values only if variables are not already set
[[ -z $BASH_TOYS_INTERACTIVE_FILTER ]] && export BASH_TOYS_INTERACTIVE_FILTER=peco
[[ -z $BASH_TOYS_DUSTBOX_DIR ]] && export BASH_TOYS_DUSTBOX_DIR="$HOME/.backup/dustbox"
[[ -z $BASH_TOYS_MUSIC_PLAYER ]] && export BASH_TOYS_MUSIC_PLAYER=vlc
[[ -z $BASH_TOYS_POMODORO_NOTIFICATION_MUSIC ]] && export BASH_TOYS_POMODORO_NOTIFICATION_MUSIC="$dir/assets/notify.mp3"
[[ -z $BASH_TOYS_POMODORO_NOTIFICATION_DURATION ]] && export BASH_TOYS_POMODORO_NOTIFICATION_DURATION=5
[[ -z $BASH_TOYS_BATCAT_OPTIONS ]] && export BASH_TOYS_BATCAT_OPTIONS=--number

export BASH_TOYS_LOADED_DEFAULT_OPTIONS=true
