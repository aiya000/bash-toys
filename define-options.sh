#!/bin/bash

# Defines default values only if variables are not already set>
# See also ./README.md for details and usage.
#
# ```shell-session
# $ source path/to/bash-toys/define-options.sh
# ```

dir="$(cd -- "$(dirname -- "${BASH_SOURCE:-$0}")" && pwd || exit 1)"

[[ -z $BASH_TOYS_INTERACTIVE_FILTER ]] && export BASH_TOYS_INTERACTIVE_FILTER=peco
[[ -z $BASH_TOYS_DUSTBOX_DIR ]] && export BASH_TOYS_DUSTBOX_DIR="$HOME/.backup/dustbox"
[[ -z $BASH_TOYS_WHEN_POMODORO_TIMER_FINISHED ]] && export BASH_TOYS_WHEN_POMODORO_TIMER_FINISHED="vlc --gain=0.3 $dir/assets/notification-impact.mp3"
[[ -z $BASH_TOYS_POMODORO_DEFAULT_INTERVAL ]] && export BASH_TOYS_POMODORO_DEFAULT_INTERVAL=5  # When not specified minutes for pomodoro-timer command, like `$ pomodoro-timer`
[[ -z $BASH_TOYS_NOTIFY_AT_DEFAULT_SOUND ]] && export BASH_TOYS_NOTIFY_AT_DEFAULT_SOUND="$dir/assets/notification-1.mp3"
[[ -z $BASH_TOYS_DURATION_WHEN_POMODORO_TIMER_FINISHED ]] && export BASH_TOYS_DURATION_WHEN_POMODORO_TIMER_FINISHED=5
[[ -z $BASH_TOYS_BATCAT_OPTIONS ]] && export BASH_TOYS_BATCAT_OPTIONS=--number
[[ -z $BASH_TOYS_OPEN_BOOKMARK_OPENER ]] && export BASH_TOYS_OPEN_BOOKMARK_OPENER=xdg-open
[[ -z $BASH_TOYS_BOOKMARK_OPEN_BOOKMARKS ]] && export BASH_TOYS_BOOKMARK_OPEN_BOOKMARKS='(Google=https://www.google.co.jp)|(GitHub=https://github.com)'

if [[ -z $BASH_TOYS_NOTIFY_DEFAULT_PLAYER ]] ; then
  if [[ -n $WSL_INTEROP ]] ; then
    # WSL
    export BASH_TOYS_NOTIFY_DEFAULT_PLAYER=not-defined-for-WSL
  elif [[ $(uname) == Darwin ]] ; then
    # macOS
    export BASH_TOYS_NOTIFY_DEFAULT_PLAYER=afplay
  elif command -v paplay >/dev/null 2>&1 ; then
    # Pure Linux
    export BASH_TOYS_NOTIFY_DEFAULT_PLAYER=paplay
  elif command -v aplay >/dev/null 2>&1 ; then
    # Pure Linux
    export BASH_TOYS_NOTIFY_DEFAULT_PLAYER=aplay
  elif command -v vlc >/dev/null 2>&1 ; then
    # Pure Linux
    export BASH_TOYS_NOTIFY_DEFAULT_PLAYER='vlc --play-and-exit --gain=0.3'
  elif command -v mpv >/dev/null 2>&1 ; then
    # Pure Linux
    export BASH_TOYS_NOTIFY_DEFAULT_PLAYER='mpv --volume=30'
  else
    # Not detectable
    export BASH_TOYS_NOTIFY_DEFAULT_PLAYER=
  fi
fi
