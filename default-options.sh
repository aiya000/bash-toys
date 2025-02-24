#!/bin/bash

#
# NOTE: This should be `souce`ed instead of execute.
#

[[ -n $BASH_TOYS_LOADED_DEFAULT_OPTIONS ]] && return

dir=$(dirname "$0")
source "$dir/functions/define-alt-export.sh"

define-alt-export BASH_TOYS_INTERACTIVE_FILTER peco # or fzf
define-alt-export BASH_TOYS_DUSTBOX_DIR "$HOME/.backup/dustbox"
define-alt-export BASH_TOYS_MUSIC_PLAYER vlc
define-alt-export BASH_TOYS_POMODORO_NOTIFICATION_MUSIC "$dir/assets/notify.mp3"
define-alt-export BASH_TOYS_BATCAT_OPTIONS '--number'

export BASH_TOYS_LOADED_DEFAULT_OPTIONS=true
