# bin/ Commands

Executable scripts in the `bin/` directory. Add to PATH to use directly.

## Notification

### notify

Sends a notification with title and message to the GUI.

```bash
notify <title> <message> [sound]
```

**Platforms**: Windows (WSL), macOS, Linux

**Examples**:
```bash
# Basic notification
$ notify 'Task Complete' 'Your build has finished'
# (Desktop notification appears)

# With sound
$ notify 'Warning' 'Low disk space' /path/to/sound.mp3
# (Desktop notification appears with sound)
```

### notify-at

Schedules notification at specified time with flexible date formats.

```bash
notify-at [options] TIME title message [sound]
notify-at (-l | --list)
notify-at (-c | --cancel) JOB_ID
```

**TIME formats**:
- `HH:MM` - Time today (if past, then tomorrow)
- `MM-DD HH:MM` - Month-day-time
- `YYYY-MM-DD HH:MM` - Full date-time

**Options**:
- `--ntfy` - Send notification via ntfy.sh
- `--local` - Send to local desktop (default)

**Environment Variables**:
- `BASH_TOYS_NOTIFY_AT_DEFAULT_SOUND` - Default sound file path (default: `notification-1.mp3` from assets)
- `BASH_TOYS_NTFY_TOPIC` - Your ntfy.sh topic name (required when using `--ntfy`)

**Examples**:
```bash
# Schedule notification at 3 PM today
$ notify-at 15:00 'Meeting' 'Team standup'
Scheduled: title=Meeting, message=Team standup
Job ID: 42

# Schedule with specific date
$ notify-at '01-15 09:00' 'Event' 'New year kickoff'
Scheduled: title=Event, message=New year kickoff
Job ID: 43

# List scheduled notifications
$ notify-at --list
42    2026-02-03 15:00    Meeting - Team standup
43    2026-01-15 09:00    Event - New year kickoff

# Cancel a scheduled notification
$ notify-at --cancel 42
Cancelled job 42
```

### notify-cascade

Schedules cascade of notifications at specified intervals before target time.

```bash
notify-cascade [options] TIME title message [timing1] [timing2] ... [sound]
```

**Timing formats**: `now`, `4h`, `30m`, `45s`, `HH:MM`, `MM-DD HH:MM`

**Options**:
- `--ntfy` - Send notification via ntfy.sh (disables local notification unless `--local` is also specified)
- `--local` - Send to local desktop (default if no options specified)

**Environment Variables**:
- `BASH_TOYS_NOTIFY_AT_DEFAULT_SOUND` - Default sound file path (default: `notification-1.mp3` from assets)
- `BASH_TOYS_NTFY_TOPIC` - Your ntfy.sh topic name (required when using `--ntfy`)

**Note**: To receive notifications on both ntfy.sh and desktop, either:
- Specify both `--ntfy` and `--local` options
- Or install ntfy.sh on your host OS and subscribe to the same topic

**Examples**:
```bash
# Cascade notifications at 1h, 30m, 10m, 5m before
$ notify-cascade 15:00 'Meeting' 'Team meeting starts' 1h 30m 10m 5m
Cascade notifications scheduled for: 15:00
Title: Meeting
Message: Team meeting starts

1h notification: in 45 minutes
30m notification: in 1 hour 15 minutes
10m notification: in 1 hour 35 minutes
5m notification: in 1 hour 40 minutes

Process IDs: 12345 12346 12347 12348

# Include immediate notification with 'now'
$ notify-cascade 15:00 'Meeting' 'Team meeting' now 1h 30m
Sending immediate notification...
...

# Send to ntfy.sh only
$ notify-cascade 15:00 'Meeting' 'Team meeting' 1h 30m --ntfy

# Send to both ntfy.sh and local desktop
$ notify-cascade 15:00 'Meeting' 'Team meeting' 1h 30m --ntfy --local
```

### notify-ntfy

A CLI frontend for ntfy.sh.
Sends notification to devices that installed ntfy.sh (e.g., Android, iOS, Windows, macOS, Linux).

```bash
notify-ntfy <title> <message>
```

**Environment Variables**:
- `BASH_TOYS_NTFY_TOPIC` - Your ntfy.sh topic name (required)

**Examples**:
```bash
# Send notification
$ export BASH_TOYS_NTFY_TOPIC=my-topic
$ notify-ntfy 'Build Complete' 'Your CI build finished successfully'
# (Notification appears on your device)

# Missing topic (error)
$ unset BASH_TOYS_NTFY_TOPIC
$ notify-ntfy 'Title' 'Message'
Error: BASH_TOYS_NTFY_TOPIC environment variable is required
# Exit status: 1
```

## File Operations

### bak

Toggles backup (.bak) extension for files.

```bash
bak FILE...
```

**Examples**:
```bash
# Create backup
$ bak README.md
mv README.md README.bak.md

# Restore from backup (run again)
$ bak README.md
mv README.bak.md README.md

# Multiple files
$ bak file1.txt file2.txt
mv file1.txt file1.bak.txt
mv file2.txt file2.bak.txt

# File not found
$ bak nonexistent.txt
File not found. Skip: nonexistent.txt

# No arguments (error)
$ bak
Error: 1 or more arguments required
# Exit status: 1
```

### rm-dust

Alternative to rm that moves files and directories to dustbox instead of deletion.

```bash
rm-dust FILE|DIR...
rm-dust --restore [FILE|DIR...]
rm-dust --restore --keep [FILE|DIR...]
```

Files and directories are moved to `$BASH_TOYS_DUSTBOX_DIR` organized in date directories with encoded full paths.

**Storage Format** (Since PR-52):
- Directory structure: `YYYY-MM-DD/` (organized by date)
- Filename format: `+full+path+filename.HH:MM[.ext]` (for files)
- Directory format: `+full+path+dirname.HH:MM` (for directories)
- Path encoding: `/` is replaced with `+`, and `+` in filenames is escaped as `++`
- All paths are stored as absolute paths

**Options**:
- `--restore` - Restore files or directories from dustbox (interactive or specific items)
- `--keep` - Used with `--restore`: copy from dustbox instead of moving (leaves the original in dustbox intact)

**Environment Variables**:
- `BASH_TOYS_DUSTBOX_DIR` - Directory to store dustbox files (default: `~/.backup/dustbox`)
- `BASH_TOYS_RESTORE_KEEP` - Set to `1` to make `--keep` the default for `--restore`; `--keep` flag always takes precedence over this variable
- `BASH_TOYS_INTERACTIVE_FILTER` - Interactive filter command for `--restore` selection (default: `peco`)

**Examples**:
```bash
# Move files to dustbox (relative path)
$ cd /home/user/dir
$ rm-dust file-in-current-directory
mv file-in-current-directory /home/user/.backup/dustbox/2026-02-09/+home+user+dir+file-in-current-directory.13:58

# Move files to dustbox (absolute path)
$ rm-dust /full/path/file.ext
mv /full/path/file.ext /home/user/.backup/dustbox/2026-02-09/+full+path+file.13:58.ext

# Move directories to dustbox
$ cd /home/user
$ rm-dust my-dir
mv my-dir /home/user/.backup/dustbox/2026-02-09/+home+user+my-dir.13:58
$ ls /home/user/.backup/dustbox/2026-02-09/+home+user+my-dir.13:58/
file1.txt  file2.txt  subdir/

# Multiple versions at different times (all go into the same date directory)
$ rm-dust file.txt
mv file.txt /home/user/.backup/dustbox/2026-02-09/+home+user+dir+file.13:58.txt
$ # ... edit file.txt ...
$ rm-dust file.txt
mv file.txt /home/user/.backup/dustbox/2026-02-09/+home+user+dir+file.14:10.txt

# Restore files and directories interactively (shows human-readable format)
$ rm-dust --restore
# Display format: YYYY-MM-DD HH:MM: /original/path (directories end with /)
2026-02-09 13:58: /full/path/file.ext
2026-02-09 13:58: /home/user/dir/file-in-current-directory
2026-02-09 13:58: /home/user/my-dir/
2026-02-09 14:10: /home/user/dir/file.txt
# (Select files or directories to restore)

# Restore specific file by filename
$ rm-dust --restore "+home+user+dir+file.13:58.txt"
mv /home/user/.backup/dustbox/2026-02-09/+home+user+dir+file.13:58.txt /home/user/dir/file.txt

# Restore specific directory by filename
$ rm-dust --restore "+home+user+my-dir.13:58"
mv /home/user/.backup/dustbox/2026-02-09/+home+user+my-dir.13:58 /home/user/my-dir

# Restore specific file by full path
$ rm-dust --restore "2026-02-09/+home+user+dir+file.13:58.txt"
mv /home/user/.backup/dustbox/2026-02-09/+home+user+dir+file.13:58.txt /home/user/dir/file.txt

# Restore interactively but keep originals in dustbox (--keep)
$ rm-dust --restore --keep
# (Select files or directories to restore)
cp -ir /home/user/.backup/dustbox/2026-02-09/+home+user+dir+file.13:58.txt /home/user/dir/file.txt

# Restore specific file but keep in dustbox
$ rm-dust --restore --keep "+home+user+dir+file.13:58.txt"
cp -ir /home/user/.backup/dustbox/2026-02-09/+home+user+dir+file.13:58.txt /home/user/dir/file.txt

# --keep without --restore is an error
$ rm-dust --keep file.txt
Error: --keep requires --restore

# BASH_TOYS_RESTORE_KEEP=1: --keep is the default behavior
$ BASH_TOYS_RESTORE_KEEP=1 rm-dust --restore
# (Select files or directories to restore)
cp -ir /home/user/.backup/dustbox/2026-02-09/+home+user+dir+file.13:58.txt /home/user/dir/file.txt

# BASH_TOYS_RESTORE_KEEP=0: --keep is not the default (explicit is required)
$ BASH_TOYS_RESTORE_KEEP=0 rm-dust --restore
# (Select files or directories to restore)
mv -i /home/user/.backup/dustbox/2026-02-09/+home+user+dir+file.13:58.txt /home/user/dir/file.txt

# BASH_TOYS_RESTORE_KEEP=1 with --keep: keeps (--keep flag takes precedence)
$ BASH_TOYS_RESTORE_KEEP=1 rm-dust --restore --keep
cp -ir ...

# BASH_TOYS_RESTORE_KEEP=0 with --keep: keeps with warning (--keep flag takes precedence)
$ BASH_TOYS_RESTORE_KEEP=0 rm-dust --restore --keep
Warning: --keep specified but BASH_TOYS_RESTORE_KEEP=0; --keep takes precedence
cp -ir ...
```

**Completion** (bash / zsh):
To enable completion for all bash-toys commands at once:
```bash
# bash (~/.bashrc)
source /path/to/bash-toys/source-completions-all.sh

# zsh (~/.zshrc)
autoload -U +X bashcompinit && bashcompinit
source /path/to/bash-toys/source-completions-all.sh
```

Or to enable only for `rm-dust`:
```bash
source /path/to/bash-toys/completions/rm-dust.bash
```

Completion features:
- Option completion: `--help`, `-h`, `--restore`, `--keep`
- File/directory completion: normal paths when adding to dustbox
- Dustbox item completion: files and directories in dustbox when using `--restore`

**Migration from Old Formats**:

If you have files in the pre-PR-52 format (flat files with `_YYYY-MM-DD_HH:MM:SS` suffix):
```bash
bash /path/to/bash-toys/migration/rm-dust-PR-52.sh
```

If you have files in the `YYYY-MM-DD-HH/` directory format (added in PR-52, superseded by date-only format):
```bash
bash /path/to/bash-toys/migration/rm-dust-PR-59.sh
```

### cat-which

Displays contents of executable files in PATH.

```bash
cat-which COMMAND
cat-which --no-bat COMMAND
```

Uses bat/batcat if available, falls back to cat.

**Environment Variables**:
- `BASH_TOYS_NO_BAT` - Set to `1` to use `cat` instead of `bat`/`batcat`
- `BASH_TOYS_BATCAT_OPTIONS` - Additional options passed to `bat`/`batcat` (default: `--number`)

**Examples**:
```bash
# Display shell script contents
$ cat-which my-script
#!/bin/bash
echo "Hello World"
...

# Binary file (error)
$ cat-which zsh
Not a plain text: /bin/zsh
# Exit status: 1

# Command not found (error)
$ cat-which nonexistent-command
Command not found: nonexistent-command
# Exit status: 1

# No arguments (error)
$ cat-which
Usage: cat-which COMMAND
# Exit status: 1
```

### fast-sync

Efficiently syncs files using file list comparison.

```bash
fast-sync <source_dir> <target_dir>
fast-sync --init <directory_to_scan>
```

**Examples**:
```bash
# Initialize sync state for target
$ fast-sync --init /backup/target
Initialization mode: Creating '/home/user/.last_sync' for directory: /backup/target
Using 'fd' for file listing...
Done. Found 1234 files. '/home/user/.last_sync' created in the current directory.

# Sync from source to target
$ fast-sync /home/user/documents /backup/documents
Syncing from: /home/user/documents
         to: /backup/documents
Starting fast sync process...
Using 'fd' for file listing...
Step 1: Generating list of already synced files from target...
 -> Found 1000 files in target directory.
Step 2: Finding new files in source...
 -> Found 50 new files to sync.
Step 3: Syncing new files with rsync...
...
Sync complete! ✨
```

### take-until-empty

Outputs lines until first blank line.

```bash
command | take-until-empty
take-until-empty <file>
```

**Examples**:
```bash
# From pipe
$ printf "line1\nline2\n\nline3\nline4\n" | take-until-empty
line1
line2

# From file
$ cat myfile.txt
header1
header2

body content here
more content

$ take-until-empty myfile.txt
header1
header2
```

## Text Processing

### skip

Skips first n lines from input.

```bash
command | skip <n>
skip <n> <file>
```

**Examples**:
```bash
# Skip first 3 lines
$ seq 10 | skip 3
4
5
6
7
8
9
10

# From file
$ skip 2 myfile.txt
(outputs file contents starting from line 3)
```

### slice

Extracts fields from delimited input.

```bash
command | slice <delimiter> <from> [to]
```

**Examples**:
```bash
# Extract fields 2-3
$ echo "a,b,c,d" | slice , 2 3
b,c

# Extract from field 2 to end
$ echo "a,b,c,d" | slice , 2
b,c,d

# With colon delimiter
$ echo "user:x:1000:1000::/home/user:/bin/bash" | slice : 1 3
user:x:1000

# Multiple lines
$ printf "a,b,c\nx,y,z\n" | slice , 1 2
a,b
x,y
```

### expects

Jest-like test API for bash scripts.

```bash
expects VALUE MATCHER [EXPECTED]
expects VALUE not MATCHER [EXPECTED]
```

**Matchers**: `to_be`, `to_equal`, `to_be_less_than`, `to_be_greater_than`, `to_contain`, `to_match`, `to_be_true`, `to_be_false`, `to_be_defined`, `to_be_a_file`, `to_be_a_dir`

**Examples**:
```bash
# Successful assertion (exit status: 0)
$ expects 10 to_be 10 && echo "Test passed"
Test passed

# Failed assertion (exit status: 1)
$ expects 42 to_be 10
FAIL: expected {actual} to_be '10', but {actual} is '42'

# Negated assertion
$ expects 10 not to_be 42 && echo "Test passed"
Test passed

# String containment
$ expects "hello world" to_contain "world" && echo "Test passed"
Test passed

$ expects "hello" to_contain "xyz"
FAIL: expected {actual} to_contain 'xyz', but {actual} is 'hello'

# Pattern matching
$ expects "hello123" to_match "^[a-z]+[0-9]+$" && echo "Test passed"
Test passed

# Boolean assertions
$ expects true to_be_true && echo "Test passed"
Test passed

$ expects false to_be_true
FAIL: expected {actual} to_be_true, but {actual} is 'false'

# Defined check
$ var="some value"
$ expects "$var" to_be_defined && echo "Test passed"
Test passed

$ expects "" to_be_defined
FAIL: expected {actual} to_be_defined, but {actual} is (empty)

# File and directory assertions
$ expects /path/to/file.txt to_be_a_file && echo "Test passed"
Test passed

$ expects /no/such/file to_be_a_file
FAIL: expected {actual} to_be_a_file, but {actual} is '/no/such/file'

$ expects /path/to/dir to_be_a_dir && echo "Test passed"
Test passed
```

## Process Management

### start

Runs a command in background with no output.

```bash
start <command> [args...]
```

**Examples**:
```bash
# Launch VLC without blocking terminal
$ start vlc
# (VLC opens, terminal returns immediately)

# Launch with arguments
$ start firefox --new-window https://example.com
# (Firefox opens with specified URL)

# Compare without 'start':
$ vlc
VLC media player 3.0.16 Vetinari (revision 3.0.13-8-g41878ff4f2)
...
# (Ctrl+C required to return to shell)
```

### kill-list

Interactively selects and kills processes.

```bash
kill-list [signal]
```

**Environment Variables**:
- `BASH_TOYS_INTERACTIVE_FILTER` - Interactive filter command for process selection (default: `peco`)

**Examples**:
```bash
# Select and kill process with SIGKILL (default)
$ kill-list
# (Interactive filter appears with process list)
# (Select one or more processes)
Killed PID: 12345
Succeed

# Kill with SIGTERM
$ kill-list -15
# (Interactive filter appears)
Killed PID: 12345
Succeed

# Kill with signal name
$ kill-list -TERM
```

### kill-latest-started

Kills the most recently started process by name.

```bash
kill-latest-started [-signal] <process_name>
```

**Examples**:
```bash
# Kill the most recently started nvim
$ nvim  # [A] First instance
$ nvim  # [B] Second instance (on another terminal)
$ kill-latest-started nvim
# Only [B] is killed, [A] remains running

# With signal
$ kill-latest-started -9 nvim
$ kill-latest-started -KILL nvim
$ kill-latest-started nvim -9
```

### run-wait-output

Executes command2 after command1's output has been silent.

```bash
run-wait-output <milliseconds> <command1> <command2>
```

**Examples**:
```bash
# Run notification after build stabilizes
$ run-wait-output 1000 "npm run watch" "echo Build stable"
# command1 runs immediately
# command2 runs after 1000ms of silence from command1

# Notify when TypeScript compilation stabilizes
$ run-wait-output 500 "tsc --watch" "npm test"

# Send desktop notification when build completes
$ run-wait-output 2000 "make" "notify 'Done' 'Build complete'"
```

## Navigation & Git

### git-root

Shows the git repository root directory.

```bash
git-root
```

**Examples**:
```bash
# Inside a git repository
$ cd /path/to/git/repo/subdir
$ git-root
/path/to/git/repo

# Outside a git repository (error)
$ cd /tmp
$ git-root
# (no output)
# Exit status: 1
```

### git-common-root

Shows the git common root directory.

```bash
git-common-root
```

**Examples**:
```bash
# Inside a git repository
$ cd /path/to/git/repo/subdir
$ git-common-root
/path/to/git/repo

# Inside a worktree
$ cd /path/to/git/repo/some-worktree
$ git-common-root
/path/to/git/repo

# Outside a git repository (error)
$ cd /tmp
$ git-common-root
# (no output)
# Exit status: 1
```

### git-stash-rename

Renames a git stash message by editing the stash log file directly.

```bash
git-stash-rename <new_message>
git-stash-rename <stash_index> <new_message>
```

**Description**:

- If only one argument is provided, it renames `stash@{0}`
- Works correctly in git worktree environments

**Examples**:
```bash
# Rename stash@{0} (default)
$ git-stash-rename "Standard Dachshund"
Renamed stash@{0}
  from: WIP on main: abc1234 Previous work
  to: Standard Dachshund

# Rename stash@{0} explicitly
$ git-stash-rename 0 "Miniature Dachshund"
Renamed stash@{0}
  from: Standard Dachshund
  to: Miniature Dachshund

# Rename stash@{1}
$ git-stash-rename 1 "kaninchen dachshund"
Renamed stash@{1}
  from: WIP on feature: def5678 Other work
  to: kaninchen dachshund
```

### pathshorten

Abbreviates path like Vim's pathshorten().

```bash
pathshorten <path>
```

**Examples**:
```bash
# Shorten directory path (last component kept intact)
$ pathshorten ~/Repository/luarrow.lua/src/luarrow
~/Repo/luar/src/luarrow

# Shorten file path (filename kept intact)
$ pathshorten ~/Repository/luarrow.lua/src/luarrow/arrow.lua
~/Repo/luar/src/luar/arrow.lua

# Short paths remain unchanged
$ pathshorten ~/Documents
~/Documents
```

## Docker

### docker-attach-menu

Interactively selects and attaches to a running Docker container.

```bash
docker-attach-menu
```

**Environment Variables**:
- `BASH_TOYS_INTERACTIVE_FILTER` - Interactive filter command for container selection (default: `peco`)

**Examples**:
```bash
# Select and attach to a running container
$ docker-attach-menu
# (Interactive filter shows running containers)
# CONTAINER ID   IMAGE          COMMAND       CREATED        STATUS
# a1b2c3d4e5f6   ubuntu:latest  "/bin/bash"   2 hours ago    Up 2 hours
# (Select a container to attach)
```

### docker-kill-menu

Interactively selects and kills a running Docker container.

```bash
docker-kill-menu
```

**Environment Variables**:
- `BASH_TOYS_INTERACTIVE_FILTER` - Interactive filter command for container selection (default: `peco`)

**Examples**:
```bash
# Select and kill a running container
$ docker-kill-menu
# (Interactive filter shows running containers)
# CONTAINER ID   IMAGE          COMMAND       CREATED        STATUS
# a1b2c3d4e5f6   ubuntu:latest  "/bin/bash"   2 hours ago    Up 2 hours
# (Select a container to kill)
a1b2c3d4e5f6
```

## GitHub

### gh-issue-view-select

Shows GitHub issues in interactive filter and opens selected issue.

```bash
gh-issue-view-select
```

**Environment Variables**:
- `BASH_TOYS_INTERACTIVE_FILTER` - Interactive filter command for issue selection (default: `peco`)

**Examples**:
```bash
# Select and view an issue
$ gh-issue-view-select
# (Interactive filter shows issues)
# 42  Add dark mode support       feature
# 38  Fix login bug               bug
# (Select an issue to view its details)
title:  Add dark mode support
state:  OPEN
author: aiya000
...

# No issue selected
$ gh-issue-view-select
# (Press Escape in filter)
No issue selected
```

### gh-run-view-latest

Shows the latest GitHub Actions run.

```bash
gh-run-view-latest [gh run view options]
```

**Examples**:
```bash
# View latest run summary
$ gh-run-view-latest
✓ main CI · 1234567890
Triggered via push about 5 minutes ago
...

# View full log
$ gh-run-view-latest --log

# Open in browser
$ gh-run-view-latest --web
Opening github.com/user/repo/actions/runs/1234567890 in your browser.
```

## Time & Productivity

### pomodoro-timer

CLI pomodoro timer.

```bash
pomodoro-timer [minutes]
pomodoro-timer --rest [minutes]
pomodoro-timer --from HH:MM minutes
pomodoro-timer --from 'YYYY-MM-DD HH:MM' minutes
pomodoro-timer --set-count N
pomodoro-timer --get-count
pomodoro-timer --clean
```

**Environment Variables**:
- `BASH_TOYS_POMODORO_DEFAULT_INTERVAL` - Default work interval in minutes (default: `30`)
- `BASH_TOYS_WHEN_POMODORO_TIMER_FINISHED` - Command to run when timer finishes, executed via `eval` (default: `notify 'Pomodoro Timer' 'Pomodoro complete!'`)

**Examples**:
```bash
# Start 30-minute work session (default)
$ pomodoro-timer
> Starting 1-th work time
> 1 minutes / 30
> 2 minutes / 30
...
> The 1-th work hour is over

# Start 45-minute work session
$ pomodoro-timer 45
> Starting 1-th work time
> 1 minutes / 45
...

# Start 5-minute break
$ pomodoro-timer --rest
> Starting break time
> 1 minutes / 5
...
> Now it's time to get to work

# Check current pomodoro count
$ pomodoro-timer --get-count
3

# Reset pomodoro count
$ pomodoro-timer --clean
Removed: /tmp/pomodoro-3
```

### date-diff-seconds

Calculates time difference in minutes.

```bash
date-diff-seconds TIME1 TIME2
```

**TIME formats**: `YYYY-MM-DD HH:MM`, `MM-DD HH:MM`, or `HH:MM`

**Examples**:
```bash
# Calculate difference between two times (in minutes)
$ date-diff-seconds 21:47 22:33
46

# With specific dates
$ date-diff-seconds '08-05 21:47' '08-05 22:33'
46

# With full date and time
$ date-diff-seconds '2025-09-25 21:47' '2025-09-25 22:33'
46

# Negative result (TIME1 is later than TIME2)
$ date-diff-seconds 23:00 22:00
-60
```

### date-diff-seconds-now

Calculates time difference between given time and now.

```bash
date-diff-seconds-now TIME
```

**Examples**:
```bash
# Minutes until a future time (current time: 14:00)
$ date-diff-seconds-now 15:30
90

# Minutes since a past time (current time: 14:00)
$ date-diff-seconds-now 13:00
-60

# With specific date
$ date-diff-seconds-now '02-05 18:00'
240
```

## Vim Build Configuration

### vim-configure

Configures Vim source with modern flags (GUI, interpreters, etc).

```bash
vim-configure
```

**Examples**:
```bash
# Build Vim from source with full features
$ git clone https://github.com/vim/vim
$ cd vim
$ vim-configure
./configure \
    --prefix=/usr/local/ \
    --enable-fail-if-missing \
    --enable-gui=yes \
    ...
$ make && sudo make install
```

### vim-configure-debug

Configures Vim source for debugging with minimal features.

```bash
vim-configure-debug
```

**Examples**:
```bash
# Build Vim with minimal features for fast debugging
$ git clone https://github.com/vim/vim
$ cd vim
$ vim-configure-debug
./configure \
    --prefix=/usr/local/ \
    --enable-gui=no \
    ...
$ make
```

### vim-configure-macos

Configures Vim source for macOS with Homebrew paths.

```bash
vim-configure-macos
```

**Examples**:
```bash
# Build Vim on macOS with Homebrew dependencies
$ git clone https://github.com/vim/vim
$ cd vim
$ vim-configure-macos
./configure \
    --prefix=/usr/local/ \
    --with-lua-prefix=/usr/local/Cellar/luajit/2.0.5 \
    ...
$ make && sudo make install
```

## Other Utilities

### confirm

Prompts the user with a yes/no question and exits with status based on the answer.

```bash
confirm [--full-message] [--always-true] <message>
```

**Options**:
- `--full-message` - Use message as-is for the prompt (without ` (y/n): ` suffix)
- `--always-true` - Always exit 0 regardless of the answer

**Examples**:
```bash
# Basic confirmation
$ confirm 'Do you want to continue?'
Do you want to continue? (y/n): y
# Exit status: 0

# Denied confirmation
$ confirm 'Delete all files?'
Delete all files? (y/n): n
# Exit status: 1

# Use in scripts to guard destructive operations
$ confirm 'Remove all temporary files?' && rm-dust /tmp/my-temp-files

# Custom prompt (no '(y/n):' suffix)
$ confirm --full-message 'Are you sure? '
Are you sure? y
# Exit status: 0

# Always succeed regardless of answer
$ confirm --always-true 'Proceed?'
Proceed? (y/n): n
# Exit status: 0

# No message (error)
$ confirm
Error: message is required
# Exit status: 2
```

### prompt

Displays a prompt and waits for the user to press Enter. Always exits with 0.

```bash
prompt [message]
```

A convenient wrapper around `confirm --always-true --full-message`.

**Examples**:
```bash
# Default message
$ prompt
Enter to continue...
# (waits for input)
# Exit status: 0

# Custom message
$ prompt 'Press Enter to deploy: '
Press Enter to deploy:
# (waits for input)
# Exit status: 0

# Use in scripts to pause execution
$ build && prompt 'Build done. Press Enter to deploy: ' && deploy
```

### bookmark-open

Opens a selected bookmark in the default browser.

```bash
bookmark-open
```

**Environment Variables**:
- `BASH_TOYS_BOOKMARK_OPEN_BOOKMARKS` - Bookmark definitions in `(Name=URL)` format, separated by `|`
- `BASH_TOYS_INTERACTIVE_FILTER` - Interactive filter command for bookmark selection (default: `peco`)

**Examples**:
```bash
# Set up bookmarks
$ export BASH_TOYS_BOOKMARK_OPEN_BOOKMARKS='(GitHub=https://github.com)|(Google=https://google.com)'

# Select and open bookmark
$ bookmark-open
# (Interactive filter shows)
# GitHub: https://github.com
# Google: https://google.com
# (Select to open in browser)
```

### calc-japanese-remaining-working-hours

Calculate required daily working hours for remaining business days.

```bash
calc-japanese-remaining-working-hours HOURS:MINUTES
```

**Examples**:
```bash
# Calculate daily hours needed for 108h 37m remaining
$ calc-japanese-remaining-working-hours 108:37
Remaining working hours: 108:37
Remaining business days: 15
Required daily hours: 7:14

# Another example
$ calc-japanese-remaining-working-hours 80:00
Remaining working hours: 80:00
Remaining business days: 15
Required daily hours: 5:20
```

Automatically fetches Japanese holidays from public API.

### clamdscan-full

Full system virus scan using ClamAV.

```bash
clamdscan-full [DIRECTORY...]
```

**Examples**:
```bash
# Full system scan (default)
$ clamdscan-full
0.00001
0.00002
...
# (Progress percentage shown)

# Scan specific directories
$ clamdscan-full /home/user /var/www
0.00001
...
```

### ctags-auto

Automatically generates ctags for git project.

```bash
ctags-auto [ctags options]
```

**Examples**:
```bash
# Generate tags in git repository
$ cd /path/to/git/repo
$ ctags-auto
ctags-auto: generating to '/path/to/git/repo/.git/tags-tmp'
Generated: /path/to/git/repo/.git/tags

# Exclude directories
$ ctags-auto --exclude=node_modules --exclude=vendor
ctags-auto: generating to '/path/to/git/repo/.git/tags-tmp'
Generated: /path/to/git/repo/.git/tags
```

### is-in-wsl

Check if running in Windows Subsystem for Linux.

```bash
is-in-wsl
```

**Examples**:
```bash
# In WSL environment
$ is-in-wsl && echo 'WSL' || echo 'Not WSL'
WSL
# Exit status: 0

# Outside WSL (Linux, macOS, etc.)
$ is-in-wsl && echo 'WSL' || echo 'Not WSL'
Not WSL
# Exit status: 1

# Use in scripts
$ if is-in-wsl ; then
>   echo "Running in WSL"
> fi
```

### list-dpkg-executables

Lists executable files from a dpkg package.

```bash
list-dpkg-executables <package_name>
```

**Examples**:
```bash
$ list-dpkg-executables wslu
/usr/bin/wslact
/usr/bin/wslclip
/usr/bin/wslfetch
/usr/bin/wslgsu
/usr/bin/wslsys
/usr/bin/wslupath
/usr/bin/wslusc
/usr/bin/wslvar
/usr/bin/wslview

$ list-dpkg-executables git
/usr/bin/git
/usr/bin/git-receive-pack
/usr/bin/git-shell
/usr/bin/git-upload-archive
/usr/bin/git-upload-pack
```

### peco-reverse

Reverse order interactive filter using peco.

```bash
command | peco-reverse [peco options]
```

**Examples**:
```bash
# Show history with newest first
$ history | peco-reverse
# (Interactive filter with reversed order)

# Use as default interactive filter
$ export BASH_TOYS_INTERACTIVE_FILTER=peco-reverse
```

### photoframe

Displays photos in fullscreen slideshow mode using feh.

```bash
photoframe <nas_local_mount_point> <nas_remote_photoframe_dir> <nas_remote_ip> [<nas_remote_username> [nas_remote_user_dir]]
```

**Examples**:
```bash
# Start photoframe with already mounted NAS
$ photoframe /home/pi/NAS /Pictures/Family 192.168.1.20
Using NAS directory: /home/pi/NAS
# (feh starts fullscreen slideshow)

# Auto-mount NAS with username (prompts for password)
$ photoframe /home/pi/NAS /Pictures/Family 192.168.1.20 myuser
NAS directory is not mounted. Try mounting to /home/pi/NAS
Enter password for myuser: 
# (Password entered securely, mounts NAS, then starts slideshow)

# With user directory
$ photoframe /home/pi/NAS /Pictures/Family 192.168.1.20 myuser myuser
Enter password for myuser:
# (Refers to /home/pi/NAS/myuser/Pictures/Family)
```
