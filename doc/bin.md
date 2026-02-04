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

**Requires**: `BASH_TOYS_NTFY_TOPIC` environment variable

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

Alternative to rm that moves files to dustbox instead of deletion.

```bash
rm-dust FILE...
```

Files are moved to `$BASH_TOYS_DUSTBOX_DIR` with timestamp.

**Examples**:
```bash
$ rm-dust test.txt
mv test.txt /home/user/.backup/dustbox/test.txt_2026-02-03_13:32:52.txt

# Multiple files
$ rm-dust file1.txt file2.txt
mv file1.txt /home/user/.backup/dustbox/file1.txt_2026-02-03_13:32:52.txt
mv file2.txt /home/user/.backup/dustbox/file2.txt_2026-02-03_13:32:53.txt

# Preserves extension
$ rm-dust document.pdf
mv document.pdf /home/user/.backup/dustbox/document.pdf_2026-02-03_13:32:52.pdf
```

### cat-which

Displays contents of executable files in PATH.

```bash
cat-which COMMAND
cat-which --no-bat COMMAND
```

Uses bat/batcat if available, falls back to cat.

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

**Matchers**: `to_be`, `to_equal`, `to_be_less_than`, `to_be_greater_than`, `to_contain`, `to_match`, `to_be_true`, `to_be_false`, `to_be_defined`

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

Uses `BASH_TOYS_INTERACTIVE_FILTER` for selection.

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
pomodoro-timer --set-count N
pomodoro-timer --get-count
pomodoro-timer --clean
```

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

**TIME formats**: `MM-DD HH:MM` or `HH:MM`

**Examples**:
```bash
# Calculate difference between two times (in minutes)
$ date-diff-seconds 21:47 22:33
46

# With specific dates
$ date-diff-seconds '08-05 21:47' '08-05 22:33'
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

### bookmark-open

Opens a selected bookmark in the default browser.

```bash
bookmark-open
```

Bookmarks defined in `BASH_TOYS_BOOKMARK_OPEN_BOOKMARKS` (separated by `|`).

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
photoframe <nas_local_mount_point> <nas_remote_photoframe_dir> <nas_remote_ip> [credentials]
```

**Examples**:
```bash
# Start photoframe with already mounted NAS
$ photoframe /home/pi/NAS /Pictures/Family 192.168.1.20
Using NAS directory: /home/pi/NAS
# (feh starts fullscreen slideshow)

# Auto-mount NAS with credentials
$ photoframe /home/pi/NAS /Pictures/Family 192.168.1.20 myuser mypassword
NAS directory is not mounted. Try mounting to /home/pi/NAS
# (Mounts NAS, then starts slideshow)

# With user directory
$ photoframe /home/pi/NAS /Pictures/Family 192.168.1.20 myuser mypassword myuser
# (Refers to /home/pi/NAS/myuser/Pictures/Family)
```
