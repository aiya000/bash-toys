# bin/ Commands

Executable scripts in the `bin/` directory. Add to PATH to use directly.

## Notification

### notify

Send a notification with title and message to the GUI.

```bash
notify <title> <message> [sound]
```

**Platforms**: Windows (WSL), macOS, Linux

### notify-at

Schedule notification at specified time with flexible date formats.

```bash
notify-at [options] TIME title message [sound]
notify-at -l | --list
notify-at -c JOB_ID | --cancel JOB_ID
```

**TIME formats**:
- `HH:MM` - Time today (if past, then tomorrow)
- `MM-DD HH:MM` - Month-day-time
- `YYYY-MM-DD HH:MM` - Full date-time

**Options**:
- `--ntfy` - Send notification via ntfy.sh
- `--local` - Send to local desktop (default)

### notify-cascade

Schedule cascade of notifications at specified intervals before target time.

```bash
notify-cascade [options] TIME title message [timing1] [timing2] ... [sound]
```

**Timing formats**: `now`, `4h`, `30m`, `45s`, `HH:MM`, `MM-DD HH:MM`

### notify-ntfy

Send notification via ntfy.sh.

```bash
notify-ntfy <title> <message>
```

**Requires**: `BASH_TOYS_NTFY_TOPIC` environment variable

## File Operations

### bak

Toggle backup (.bak) extension for files.

```bash
bak FILE...
```

**Examples**:
```bash
bak README.md        # Creates README.bak.md
bak README.md        # Restores to README.md
```

### rm-dust

Alternative to rm that moves files to dustbox instead of deletion.

```bash
rm-dust FILE...
```

Files are moved to `$BASH_TOYS_DUSTBOX_DIR` with timestamp.

### cat-which

Display contents of executable files in PATH.

```bash
cat-which COMMAND
cat-which --no-bat COMMAND
```

Uses bat/batcat if available, falls back to cat.

### fast-sync

Efficiently sync files using file list comparison.

```bash
fast-sync <source_dir> <target_dir>
fast-sync --init <directory_to_scan>
```

### take-until-empty

Output lines until first blank line.

```bash
command | take-until-empty
take-until-empty <file>
```

## Text Processing

### skip

Skip first n lines from input.

```bash
command | skip <n>
skip <n> <file>
```

**Example**: `seq 10 | skip 3` outputs 4-10

### slice

Extract fields from delimited input.

```bash
command | slice <delimiter> <from> [to]
```

**Example**: `echo "a,b,c,d" | slice , 2 3` outputs `b,c`

### expects

Jest-like test API for bash scripts.

```bash
expects VALUE MATCHER [EXPECTED]
expects VALUE not MATCHER [EXPECTED]
```

**Matchers**: `to_be`, `to_equal`, `to_be_less_than`, `to_be_greater_than`, `to_contain`, `to_match`, `to_be_true`, `to_be_false`, `to_be_defined`

**Example**:
```bash
expects 10 to_be 10
expects "hello" to_contain "ell"
expects "$var" not to_be_defined
```

## Process Management

### start

Run a command in background with no output.

```bash
start <command> [args...]
```

**Example**: `start vlc` launches VLC without blocking terminal

### kill-list

Interactively select and kill processes.

```bash
kill-list [signal]
```

Uses `BASH_TOYS_INTERACTIVE_FILTER` for selection.

### kill-latest-started

Kill the most recently started process by name.

```bash
kill-latest-started [-signal] <process_name>
```

**Examples**:
```bash
kill-latest-started nvim
kill-latest-started -9 nvim
```

### run-wait-output

Execute command2 after command1's output has been silent.

```bash
run-wait-output <milliseconds> <command1> <command2>
```

**Example**: `run-wait-output 1000 "npm run watch" "echo Build stable"`

## Navigation & Git

### git-root

Show the git repository root directory.

```bash
git-root
```

Returns exit code 1 if not inside a git repository.

### pathshorten

Abbreviate path like Vim's pathshorten().

```bash
pathshorten <path>
```

**Example**: `pathshorten ~/Repository/luarrow.lua/src/luarrow` outputs `~/Repo/luar/src/luarrow`

## Docker

### docker-attach-menu

Interactively select and attach to a running Docker container.

```bash
docker-attach-menu
```

### docker-kill-menu

Interactively select and kill a running Docker container.

```bash
docker-kill-menu
```

## GitHub

### gh-issue-view-select

Show GitHub issues in interactive filter and open selected issue.

```bash
gh-issue-view-select
```

### gh-run-view-latest

Show the latest GitHub Actions run.

```bash
gh-run-view-latest [gh run view options]
```

**Examples**:
```bash
gh-run-view-latest
gh-run-view-latest --log
gh-run-view-latest --web
```

## Time & Productivity

### pomodoro-timer

CLI pomodoro timer.

```bash
pomodoro-timer [minutes]
pomodoro-timer --rest [minutes]
pomodoro-timer --from HH:MM minutes
pomodoro-timer --set-count N
pomodoro-timer --get-count
pomodoro-timer --clean
```

### date-diff-seconds

Calculate time difference in minutes.

```bash
date-diff-seconds TIME1 TIME2
```

**TIME formats**: `MM-DD HH:MM` or `HH:MM`

### date-diff-seconds-now

Calculate time difference between given time and now.

```bash
date-diff-seconds-now TIME
```

## Vim Build Configuration

### vim-configure

Configure Vim source with modern flags (GUI, interpreters, etc).

```bash
vim-configure
```

### vim-configure-debug

Configure Vim source for debugging with minimal features.

```bash
vim-configure-debug
```

### vim-configure-macos

Configure Vim source for macOS with Homebrew paths.

```bash
vim-configure-macos
```

## Other Utilities

### bookmark-open

Opens a selected bookmark in the default browser.

```bash
bookmark-open
```

Bookmarks defined in `BASH_TOYS_BOOKMARK_OPEN_BOOKMARKS` (separated by `|`).

### calc-japanese-remaining-working-hours

Calculate required daily working hours for remaining business days.

```bash
calc-japanese-remaining-working-hours HOURS:MINUTES
```

**Example**: `calc-japanese-remaining-working-hours 108:37`

### clamdscan-full

Full system virus scan using ClamAV.

```bash
clamdscan-full [DIRECTORY...]
```

### ctags-auto

Automatically generate ctags for git project.

```bash
ctags-auto [ctags options]
```

### is-in-wsl

Check if running in Windows Subsystem for Linux.

```bash
is-in-wsl && echo 'WSL' || echo 'Not WSL'
```

### list-dpkg-executables

List executable files from a dpkg package.

```bash
list-dpkg-executables <package_name>
```

### peco-reverse

Reverse order interactive filter using peco.

```bash
command | peco-reverse [peco options]
```

### photoframe

Display photos in fullscreen slideshow mode using feh.

```bash
photoframe <nas_local_mount_point> <nas_remote_photoframe_dir> <nas_remote_ip> [credentials]
```
