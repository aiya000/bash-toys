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
```shell-session
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
```shell-session
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

Display contents of executable files in PATH.

```bash
cat-which COMMAND
cat-which --no-bat COMMAND
```

Uses bat/batcat if available, falls back to cat.

**Examples**:
```shell-session
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

**Examples**:
```shell-session
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

Skip first n lines from input.

```bash
command | skip <n>
skip <n> <file>
```

**Examples**:
```shell-session
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

Extract fields from delimited input.

```bash
command | slice <delimiter> <from> [to]
```

**Examples**:
```shell-session
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
```shell-session
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

Run a command in background with no output.

```bash
start <command> [args...]
```

**Examples**:
```shell-session
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
```shell-session
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

Execute command2 after command1's output has been silent.

```bash
run-wait-output <milliseconds> <command1> <command2>
```

**Examples**:
```shell-session
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

Show the git repository root directory.

```bash
git-root
```

**Examples**:
```shell-session
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

Abbreviate path like Vim's pathshorten().

```bash
pathshorten <path>
```

**Examples**:
```shell-session
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
```shell-session
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

**Examples**:
```shell-session
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

### ctags-auto

Automatically generate ctags for git project.

```bash
ctags-auto [ctags options]
```

### is-in-wsl

Check if running in Windows Subsystem for Linux.

```bash
is-in-wsl
```

**Examples**:
```shell-session
# In WSL environment
$ is-in-wsl && echo 'WSL' || echo 'Not WSL'
WSL
# Exit status: 0

# Outside WSL (Linux, macOS, etc.)
$ is-in-wsl && echo 'WSL' || echo 'Not WSL'
Not WSL
# Exit status: 1

# Use in scripts
$ if is-in-wsl; then
>   echo "Running in WSL"
> fi
```

### list-dpkg-executables

List executable files from a dpkg package.

```bash
list-dpkg-executables <package_name>
```

**Examples**:
```shell-session
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

### photoframe

Display photos in fullscreen slideshow mode using feh.

```bash
photoframe <nas_local_mount_point> <nas_remote_photoframe_dir> <nas_remote_ip> [credentials]
```
