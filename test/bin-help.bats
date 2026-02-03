#!/usr/bin/env bats

# Tests for -h/--help options in bin commands that don't have dedicated test files
# shellcheck disable=SC2016

# bash-toys-help
@test '`bash-toys-help --help` should show help message' {
  run bash-toys-help --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^bash-toys-help - '
}

@test '`bash-toys-help -h` should show help message' {
  run bash-toys-help -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^bash-toys-help - '
}

# ctags-auto
@test '`ctags-auto --help` should show help message' {
  run ctags-auto --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^ctags-auto - '
}

@test '`ctags-auto -h` should show help message' {
  run ctags-auto -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^ctags-auto - '
}

# docker-attach-menu
@test '`docker-attach-menu --help` should show help message' {
  run docker-attach-menu --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^docker-attach-menu - '
}

@test '`docker-attach-menu -h` should show help message' {
  run docker-attach-menu -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^docker-attach-menu - '
}

# docker-kill-menu
@test '`docker-kill-menu --help` should show help message' {
  run docker-kill-menu --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^docker-kill-menu - '
}

@test '`docker-kill-menu -h` should show help message' {
  run docker-kill-menu -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^docker-kill-menu - '
}

# gh-run-view-latest
@test '`gh-run-view-latest --help` should show help message' {
  run gh-run-view-latest --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^gh-run-view-latest - '
}

@test '`gh-run-view-latest -h` should show help message' {
  run gh-run-view-latest -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^gh-run-view-latest - '
}

# git-root
@test '`git-root --help` should show help message' {
  run git-root --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^git-root - '
}

@test '`git-root -h` should show help message' {
  run git-root -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^git-root - '
}

# is-in-wsl
@test '`is-in-wsl --help` should show help message' {
  run is-in-wsl --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^is-in-wsl - '
}

@test '`is-in-wsl -h` should show help message' {
  run is-in-wsl -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^is-in-wsl - '
}

# kill-latest-started
@test '`kill-latest-started --help` should show help message' {
  run kill-latest-started --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^kill-latest-started - '
}

@test '`kill-latest-started -h` should show help message' {
  run kill-latest-started -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^kill-latest-started - '
}

# kill-list
@test '`kill-list --help` should show help message' {
  run kill-list --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^kill-list - '
}

@test '`kill-list -h` should show help message' {
  run kill-list -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^kill-list - '
}

# list-dpkg-executables
@test '`list-dpkg-executables --help` should show help message' {
  run list-dpkg-executables --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^list-dpkg-executables - '
}

@test '`list-dpkg-executables -h` should show help message' {
  run list-dpkg-executables -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^list-dpkg-executables - '
}

# notify
@test '`notify --help` should show help message' {
  run notify --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^Usage: notify '
}

@test '`notify -h` should show help message' {
  run notify -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^Usage: notify '
}

# notify-ntfy
@test '`notify-ntfy --help` should show help message' {
  run notify-ntfy --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^Usage: notify-ntfy '
}

@test '`notify-ntfy -h` should show help message' {
  run notify-ntfy -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^Usage: notify-ntfy '
}

# pathshorten
@test '`pathshorten --help` should show help message' {
  run pathshorten --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^pathshorten - '
}

@test '`pathshorten -h` should show help message' {
  run pathshorten -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^pathshorten - '
}

# peco-reverse
@test '`peco-reverse --help` should show help message' {
  run peco-reverse --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^peco-reverse - '
}

@test '`peco-reverse -h` should show help message' {
  run peco-reverse -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^peco-reverse - '
}

# pomodoro-timer
@test '`pomodoro-timer --help` should show help message' {
  run pomodoro-timer --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^pomodoro-timer - '
}

@test '`pomodoro-timer -h` should show help message' {
  run pomodoro-timer -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^pomodoro-timer - '
}

# skip
@test '`skip --help` should show help message' {
  run skip --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^skip - '
}

@test '`skip -h` should show help message' {
  run skip -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^skip - '
}

# slice
@test '`slice --help` should show help message' {
  run slice --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^slice - '
}

@test '`slice -h` should show help message' {
  run slice -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^slice - '
}

# start
@test '`start --help` should show help message' {
  run start --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^start - '
}

@test '`start -h` should show help message' {
  run start -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^start - '
}

# vim-configure
@test '`vim-configure --help` should show help message' {
  run vim-configure --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^vim-configure - '
}

@test '`vim-configure -h` should show help message' {
  run vim-configure -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^vim-configure - '
}

# vim-configure-debug
@test '`vim-configure-debug --help` should show help message' {
  run vim-configure-debug --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^vim-configure-debug - '
}

@test '`vim-configure-debug -h` should show help message' {
  run vim-configure-debug -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^vim-configure-debug - '
}

# vim-configure-macos
@test '`vim-configure-macos --help` should show help message' {
  run vim-configure-macos --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^vim-configure-macos - '
}

@test '`vim-configure-macos -h` should show help message' {
  run vim-configure-macos -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^vim-configure-macos - '
}
