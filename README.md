<div align="center">

# :dog2: bash-toys :dog2:

**Tiny Tools that Reach the Finer Details**

![Shell: bash/zsh](https://img.shields.io/badge/Shell-bash%20%7C%20zsh-green)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Dependencies: minimal](https://img.shields.io/badge/Dependencies-minimal-blue)

![](./readme/cat-which-rm-dust.png)

</div>

## :bookmark_tabs: Table of Contents

- [Quick Start](#bookmark_tabs-quick-start)
- [Scripts](#bookmark_tabs-scripts)
- [Installation](#bookmark_tabs-installation)
- [Help](#bookmark_tabs-show-help-for-commands)
- [Contributing](#bookmark_tabs-contributing)
- [License](#bookmark_tabs-license)

## :bookmark_tabs: Quick Start

```bash
git clone --depth 1 https://github.com/aiya000/bash-toys.git /path/to/bash-toys
```

If using bash:
```bash
echo 'source /path/to/bash-toys/source-all.sh' >> ~/.bashrc
```

If using zsh:
```bash
echo 'source /path/to/bash-toys/source-all.sh' >> ~/.zshrc
```

## :bookmark_tabs: Scripts

For a complete list of scripts, visit [./bin](https://github.com/aiya000/bash-toys/tree/main/bin) and [./sources](https://github.com/aiya000/bash-toys/tree/main/sources).

### :small_blue_diamond: Executables ([./bin](https://github.com/aiya000/bash-toys/tree/main/bin))

bash-toys scripts have **minimal dependencies**.
These dependencies are documented at the beginning of the script.

| Script | Description | Quick Example | Test |
|--------|-------------|---------------|:----:|
| [`bak`](./bin/bak) | Toggle backup (.bak) extension for files | `$ bak file.txt # mv to file.bak.txt` | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-bak.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-bak.yml) |
| [`bookmark-open`](./bin/bookmark-open) | Opens a selected bookmark in the default browser | `$ bookmark-open # select & open` | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-bookmark-open.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-bookmark-open.yml) |
| [`calc-japanese-remaining-working-hours`](./bin/calc-japanese-remaining-working-hours) | Calculate required daily working hours for remaining business days | `$ calc-japanese-remaining-working-hours # calc hours` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`cat-which`](./bin/cat-which) | A shorthand for `cat $(which cmd)`. Uses [bat](https://github.com/sharkdp/bat) if available | `$ cat-which rm-dust # show source` | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-cat-which.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-cat-which.yml) |
| [`clamdscan-full`](./bin/clamdscan-full) | Performs a full virus scan using ClamAV | `$ clamdscan-full / # scan root` | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-clamdscan-full.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-clamdscan-full.yml) |
| [`ctags-auto`](./bin/ctags-auto) | Automatically determine git project and generate ctags | `$ ctags-auto # generate tags` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`date-diff-seconds`](./bin/date-diff-seconds) | Calculate time difference in minutes between two times | `$ date-diff-seconds 21:47 22:33 # => 46 mins` | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-date-diff-seconds.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-date-diff-seconds.yml) |
| [`date-diff-seconds-now`](./bin/date-diff-seconds-now) | Calculate time difference between given time and now | `$ date-diff-seconds-now 22:30 # mins until` | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-date-diff-seconds-now.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-date-diff-seconds-now.yml) |
| [`docker-attach-menu`](./bin/docker-attach-menu) | Attach to a Docker container selected from interactive menu | `$ docker-attach-menu # select & attach` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`docker-kill-menu`](./bin/docker-kill-menu) | Kill a Docker container selected from interactive menu | `$ docker-kill-menu # select & kill` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`expects`](./bin/expects) | A smaller test API like [jest](https://jestjs.io/ja/docs/expect) for bash script | `$ expects "$x" to_be 10 # assert x=10` | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-expects.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-expects.yml) |
| [`fast-sync`](./bin/fast-sync) | Efficiently sync files from source to target by comparing file lists | `$ fast-sync /src /dst # sync new only` | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-fast-sync.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-fast-sync.yml) |
| [`gh-issue-view-select`](./bin/gh-issue-view-select) | Show GitHub issues in interactive filter and open selected issue | `$ gh-issue-view-select # select & view` | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-gh-issue-view-select.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-gh-issue-view-select.yml) |
| [`gh-run-view-latest`](./bin/gh-run-view-latest) | Show the latest GitHub Actions run preview and log | `$ gh-run-view-latest # view latest run` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`git-root`](./bin/git-root) | Shows the git root directory of the current directory | `$ git-root # => /path/to/repo` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`is-in-wsl`](./bin/is-in-wsl) | Check if current shell is running in WSL | `$ is-in-wsl && echo WSL # detect WSL` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`kill-latest-started`](./bin/kill-latest-started) | Kill the latest started background process | `$ kill-latest-started # kill last bg` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`kill-list`](./bin/kill-list) | Display and kill processes selected from interactive menu | `$ kill-list # select & kill` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`list-dpkg-executables`](./bin/list-dpkg-executables) | List executable files provided by a dpkg package | `$ list-dpkg-executables git # list bins` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`notify`](./bin/notify) | Send desktop notification with title and message | `$ notify "Title" "Msg" # show popup` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`notify-at`](./bin/notify-at) | Send notification at specified time with flexible date formats | `$ notify-at 12:00 "T" "M" # at noon` | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-notify-at.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-notify-at.yml) |
| [`notify-at-at`](./bin/notify-at-at) | Send notification at specified time using at command (Linux/WSL) | `$ notify-at-at 12:00 "T" "M" # Linux` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`notify-at-launchd`](./bin/notify-at-launchd) | Send notification at specified time using launchd (macOS) | `$ notify-at-launchd 12:00 "T" "M" # macOS` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`notify-cascade`](./bin/notify-cascade) | Send cascade of notifications at specified intervals before target time | `$ notify-cascade 15:00 "M" "M" 30m 5m # 30m,5m before` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`notify-ntfy`](./bin/notify-ntfy) | Send notification to mobile via ntfy.sh | `$ notify-ntfy "T" "M" # to mobile` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`pathshorten`](./bin/pathshorten) | Abbreviate file path with shortened parent directories | `$ pathshorten ~/Documents/Proj # => ~/Docu/Proj` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`peco-reverse`](./bin/peco-reverse) | Reverse order interactive filter using peco | `$ ls \| peco-reverse # reversed filter` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`photoframe`](./bin/photoframe) | Display photos in fullscreen slideshow mode using feh | `$ photoframe ~/Pictures # slideshow` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`pomodoro-timer`](./bin/pomodoro-timer) | A simplest Pomodoro Timer implementation in shell script | `$ pomodoro-timer 25 # start 25min` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`rm-dust`](./bin/rm-dust) | An alternative to `rm`, moving files to a dustbox instead. `alias rm=rm-dust` is recommended! | `$ rm-dust file.txt # mv to dustbox` | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-dust.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-dust.yml) |
| [`run-wait-output`](./bin/run-wait-output) | Run two commands sequentially, with second triggered after first becomes silent | `$ run-wait-output 1000 "npm watch" "echo Done" # after silent` | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-run-wait-output.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-run-wait-output.yml) |
| [`skip`](./bin/skip) | Skip n-lines from the beginning of output | `$ seq 10 \| skip 3 # => 4,5,...,10` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`slice`](./bin/slice) | Slice fields from input lines | `$ echo "a,b,c" \| slice , 2 3 # => b,c` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`start`](./bin/start) | Starts a process in the background without output | `$ start firefox # run silently` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`take-until-empty`](./bin/take-until-empty) | Takes input lines until a blank line appears | `$ cat file \| take-until-empty # stop at blank` | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-take-until-empty.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-take-until-empty.yml) |
| [`vim-configure`](./bin/vim-configure) | Executes `./configure` for Vim source with modern flags | `$ vim-configure # run ./configure` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`vim-configure-debug`](./bin/vim-configure-debug) | Execute Vim source configure script with debug flags | `$ vim-configure-debug # with debug` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`vim-configure-macos`](./bin/vim-configure-macos) | Execute Vim source configure script with modern macOS flags | `$ vim-configure-macos # for macOS` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |

### :small_blue_diamond: Sources ([./sources](https://github.com/aiya000/bash-toys/tree/main/sources))

'Sources' are utility scripts that affect the parent shell (like the `cd` command).

| Script | Description | Quick Example | Test |
|--------|-------------|---------------|:----:|
| [`alias-of`](./sources/alias-of.sh) | Creates an alias only if the command exists | `$ alias-of rg 'rg --color always' # if rg exists` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`cd-finddir`](./sources/cd-finddir.sh) | Shows directories and `cd` to a selected one via interactive filter | `$ cd-finddir # fuzzy cd` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`cd-to-git-root`](./sources/cd-to-git-root.sh) | Change directory to the git root, with WSL path recovery support | `$ cd-to-git-root # cd to repo root` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`cd-to-node-root`](./sources/cd-to-node-root.sh) | Change directory to the nearest parent directory containing `package.json` | `$ cd-to-node-root # cd to pkg dir` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`contains-value`](./sources/contains-value.sh) | Checks if an array contains a value | `$ contains-value "${arr[@]}" "val" # check in arr` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`define-alt`](./sources/define-alt.sh) | Defines a shell variable named 'foo' if not defined | `$ define-alt EDITOR vim # set if unset` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`define-alt-export`](./sources/define-alt-export.sh) | Similar to `define-alt`, but for environment variables | `$ define-alt-export EDITOR vim # export if unset` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`force-unexport`](./sources/force-unexport.sh) | Unexports an environment variable | `$ force-unexport MY_VAR # remove env` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`get-var`](./sources/get-var.sh) | Read and output the value of a variable by name | `$ get-var HOME # => /home/user` | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-get-var.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-get-var.yml) |
| [`i-have`](./sources/i-have.sh) | Check if a specified command exists in the system | `$ i-have bat && echo yes # check cmd` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`is-array`](./sources/is-array.sh) | Detect if a variable is an array (supports Bash and Zsh) | `$ is-array arr && echo yes # check array` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`load-my-env`](./sources/load-my-env.sh) | Load environment-specific settings and aliases for various tools and runtimes | `$ load-my-env # load settings` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`nvim-parent-edit`](./sources/nvim-parent-edit.sh) | Open files in parent Neovim instance via RPC from child terminal | `$ nvim-parent-edit file.txt # edit in parent` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| [`source-if-exists`](./sources/source-if-exists.sh) | Conditionally source a file if it exists | `$ source-if-exists ~/.local.sh # source if exists` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |

### :small_blue_diamond: Recommended Scripts

Here are some scripts that can boost your daily workflow:

<details>
<summary>File Operations</summary> <!-- {{{ -->

**[`rm-dust`](./bin/rm-dust)** - Safe alternative to `rm`. Never lose files by accident again!

```shell-session
$ rm-dust important.txt        # Moves to dustbox instead of deleting
$ rm-dust *.log                # Clean up logs safely
$ alias rm=rm-dust             # Recommended: replace rm globally
```

**[`bak`](./bin/bak)** - Quick backup toggle. One command to backup, one to restore.

```shell-session
$ bak config.yaml              # Creates config.bak.yaml
$ vim config.yaml              # Edit the original
$ bak config.yaml              # Restore from backup if needed
```

**[`nvim-parent-edit`](./sources/nvim-parent-edit.sh)** - Edit files in parent Neovim from nested terminal. (Show also an example: [nvim.lua](https://github.com/aiya000/dotfiles/blob/906c7ed230e74c3dbaf2be7797d7537616470647/.config/nvim/lua/nvim.lua#L305-L307), [keymaps.lua](https://github.com/aiya000/dotfiles/blob/906c7ed230e74c3dbaf2be7797d7537616470647/.config/nvim/lua/keymaps.lua#L212-L217))

```shell-session
# Inside Neovim's :terminal
$ nvim-parent-edit file.txt   # Opens in parent Neovim, not a nested instance (not Neovim in Neovim)
$ nvim-parent-edit *.js       # Open multiple files
```

**[`fast-sync`](./bin/fast-sync)** - Efficient file sync by comparing file lists first.

```shell-session
$ fast-sync --init ~/photos    # Initialize sync state
$ fast-sync ~/photos /backup   # Only syncs new/changed files
# Much faster than full rsync for large directories
```

<!-- }}} -->
</details>

<details>
<summary>Testing</summary> <!-- {{{ -->

**[`expects`](./bin/expects)** - Jest-like assertions for shell scripts. Write readable tests!

Many tests in this project ([./test](./test)) are written with `expects`.

```shell-session
$ x=10 ; expects "$x" to_be 42
FAIL: expected {actual} to_be '42', but {actual} is '10'

$ x=42
$ expects "$x" to_be 42                          # No output on success (exit 0)
$ expects "$x" to_be 42 && echo "PASS"           # Equality check
PASS
$ expects "$x" not to_be 0 && echo "PASS"        # Negation
PASS
$ expects "hello world" to_contain "world"       # String containment
```

And more assertions are available.
See [`expects`](./bin/expects).

<!-- }}} -->
</details>

<details>
<summary>Notifications & Timers</summary> <!-- {{{ -->

**[`notify`](./bin/notify)** - Simple desktop notification. Works on macOS, Linux, and WSL.

```shell-session
$ notify "Build Done" "Your project compiled successfully"
$ make && notify "Success" "Build complete" || notify "Failed" "Build error"
```

**[`notify-ntfy`](./bin/notify-ntfy)** - Send notifications to your phone via [ntfy.sh](https://ntfy.sh).

```shell-session
$ notify-ntfy "Backup Done" "Server backup completed"  # Sends to mobile
$ long-running-task && notify-ntfy "Done" "Task finished"
# Requires: export BASH_TOYS_NTFY_TOPIC="your-topic-name"
# See https://ntfy.sh for setup
# See ./bin/notify-ntfy for usage
```

**[`notify-at`](./bin/notify-at)** - Schedule notifications with human-friendly time formats. (A wrapper for `notify`, and `at` command (Linux) or `launchd` (macOS).)

```shell-session
$ notify-at 15:00 "Meeting" "Team standup starting"         # Show notification to desktop at 3 PM
$ notify-at 15:00 "Meeting" "Team standup starting" --local # --local (Show notification to desktop) by default (Same as above)
$ notify-at "01-15 09:00" "Reminder" "Project deadline"     # Show notification to desktop on Jan 15 at 9 AM
$ notify-at 12:00 "Lunch" "Take a break" --mobile           # Send notification to mobile via ntfy.sh (if want to send both mobile and desktop, See below)
$ notify-at 18:00 "Dinner" "Cook" 1h --mobile --local       # Show/Send notification to both mobile and desktop
```

**[`notify-cascade`](./bin/notify-cascade)** - Get reminded at multiple intervals before an event. (A wrapper for `notify-at`.)

```shell-session
$ notify-cascade 15:00 "Meeting" "Standup" 30m 10m 5m    # Show notification at 14:30, 14:50, and 14:55
$ notify-cascade 18:00 "Dinner" "Cook" 1h 30m --mobile   # Send notification to mobile (requires notify-ntfy setup)
$ notify-cascade 18:00 "Dinner" "Cook" 1h 30m --local    # Desktop only (default)
$ notify-cascade 18:00 "Dinner" "Cook" 1h --mobile --local  # Both mobile and desktop
```

**[`pomodoro-timer`](./bin/pomodoro-timer)** - Simple Pomodoro technique timer with notifications.

```shell-session
$ pomodoro-timer              # Default 30 minutes
$ pomodoro-timer 25           # Classic 25-minute pomodoro
$ pomodoro-timer --rest 5     # 5-minute break timer
```

<!-- }}} -->
</details>

<details>
<summary>Text Processing</summary> <!-- {{{ -->

**[`skip`](./bin/skip)** & **[`slice`](./bin/slice)** - Simple but powerful text manipulation.

```shell-session
$ cat data.csv | skip 1                    # Skip header row
$ echo "a,b,c,d" | slice , 2 3             # Extract fields 2-3: "b,c"
$ ps aux | skip 1 | slice ' ' 1 2          # Get PID and user columns
```

**[`take-until-empty`](./bin/take-until-empty)** - Read until blank line. Perfect for parsing sections.

```shell-session
$ cat changelog.md | take-until-empty          # Get first section only
$ git log --format="%B" -1 | take-until-empty  # Get commit title only
```

**[`pathshorten`](./bin/pathshorten)** - Shorten paths like Vim's `pathshorten()`. Great for prompts!

```shell-session
$ pathshorten ~/Documents/Projects/myapp/src  # => ~/Docu/Proj/myap/src
$ PS1="\$(pathshorten \$PWD) $ "              # Use in bash prompt
```

<!-- }}} -->
</details>

<details>
<summary>Navigation & Development</summary> <!-- {{{ -->

**[`cd-finddir`](./sources/cd-finddir.sh)** - Fuzzy directory navigation. Never type long paths again!

```shell-session
$ cd-finddir                  # Shows directory picker
...
luarrow.lua/src/
luarrow.lua/spec/
luarrow.lua/scripts/
luarrow.lua/luarrow.bak.lua/
luarrow.lua/doc/
luarrow.lua/
chotto.lua/src/
chotto.lua/spec/
chotto.lua/scripts/
chotto.lua/readme/
chotto.lua/doc/
chotto.lua/
...
> (Type partial name to filter, select to cd)
```

**[`cd-to-git-root`](./sources/cd-to-git-root.sh)** & **[`git-root`](./bin/git-root)** - Quick access to repository root.

```shell-session
$ cd-to-git-root              # Jump to repo root from anywhere
$ cat $(git-root)/README.md   # Reference files from repo root
```

**[`cd-to-node-root`](./sources/cd-to-node-root.sh)** - Jump to nearest `package.json` directory.

```shell-session
$ pwd
/project/src/components/ui
$ cd-to-node-root
$ pwd
/project                      # Jumped to package.json directory!
$ npm test                    # Now you can run npm commands
```

**[`cat-which`](./bin/cat-which)** - Instantly view any script's source code.

```shell-session
$ cat-which rm-dust           # See how rm-dust works
$ cat-which my-script         # Debug your own scripts
```

<!-- }}} -->
</details>

<details>
<summary>Background Processes</summary> <!-- {{{ -->

**[`start`](./bin/start)** - Launch GUI apps without terminal noise.

```shell-session
$ start firefox               # Opens Firefox, returns prompt immediately
$ start code .                # Open VS Code without blocking
$ start vlc music.mp3         # Play music in background
```

**[`kill-list`](./bin/kill-list)** - Interactive process killer. No more memorizing PIDs!

```shell-session
$ kill-list
  PID START                     COMMAND
...
12345 Thu Jan 30 10:15:00 2025  node server.js
12346 Thu Jan 30 10:15:01 2025  npm run watch
12347 Thu Jan 30 10:20:30 2025  python script.py
...
> Select process to kill (fuzzy search, multi-select with Tab)
```

<!-- }}} -->
</details>

<details>
<summary>Security</summary> <!-- {{{ -->

**[`clamdscan-full`](./bin/clamdscan-full)** - Full system virus scan with ClamAV.

```shell-session
$ clamdscan-full /            # Scan entire system
$ clamdscan-full ~/Downloads  # Scan specific directory
# Requires ClamAV daemon (clamd) running
```

<!-- }}} -->
</details>

## :bookmark_tabs: Show help for commands

Most commands support `--help` option:

```shell-session
$ rm-dust --help
rm-dust - Alternative to rm that moves files to dustbox instead of deletion

Usage:
  rm-dust FILE...
  rm-dust --help
...
```

If a command doesn't have `--help`, use `bash-toys-help` to extract help from script comments:

```shell-session
$ bash-toys-help rm-dust

# For 'source' commands (don't forget .sh extension)
$ bash-toys-help cd-to-git-root.sh

# Disable markdown rendering
$ bash-toys-help --disable-glow rm-dust
```

## :bookmark_tabs: Installation

In this section, we assumed you are using bash and `~/.bashrc`.
If you are using zsh, replace `~/.bashrc` with `~/.zshrc`.

### :small_blue_diamond: Install all tools

1. Clone the repository

```shell-session
$ git clone --depth 1 https://github.com/aiya000/bash-toys.git /path/to/bash-toys
```

2. Source the `source-all.sh` script in your `.bashrc` or `.zshrc`

```shell-session
$ echo 'source /path/to/bash-toys/source-all.sh' >> ~/.bashrc
```

3. (**Optional**) Configure options if necessary

```shell-session
$ vim /path/to/bash-toys/define-options.sh
```

Or set in your `.bashrc`:

```bash
export BASH_TOYS_DUSTBOX_DIR="$HOME/dustbox"
export BASH_TOYS_MUSIC_PLAYER='afplay /System/Library/Sounds/Funk.aiff'
export BASH_TOYS_MUSIC_PLAYER_OPTIONS=''
```

<details>
<summary>Example configuration</summary>

```bash
export BASH_TOYS_INTERACTIVE_FILTER=fzf
export BASH_TOYS_DUSTBOX_DIR="$HOME/dustbox"
export BASH_TOYS_BATCAT_OPTIONS=''
```

</details>

### :small_blue_diamond: Options

Please see `./define-options.sh` and configure your options as needed.

### :small_blue_diamond: Optional Dependencies

- `vlc`: For `pomodoro-start` (if `$BASH_TOYS_MUSIC_PLAYER` is set to the default value)

### :small_blue_diamond: Install each of the tools

Here is how to install individual tools.

1. Create base directory

```shell-session
$ mkdir -p ~/lib/bash-toys || true
$ echo 'export PATH=$PATH:~/lib/bash-toys' >> ~/.bashrc
```

2. (**Optional**) Install dependencies if needed

```shell-session
$ curl https://raw.githubusercontent.com/aiya000/bash-toys/refs/heads/main/lib/fun.sh -o ~/lib/bash-toys/fun.sh
$ echo 'source ~/lib/bash-toys/fun.sh' >> ~/.bashrc
```

3. (**Optional**) Configure environment variables if necessary

Some scripts require environment variables to be configured. You can either:

Download and source `define-options.sh`:

```shell-session
$ curl https://raw.githubusercontent.com/aiya000/bash-toys/refs/heads/main/define-options.sh -o ~/lib/bash-toys/define-options.sh
$ echo 'source ~/lib/bash-toys/define-options.sh' >> ~/.bashrc
```

Or set the variables directly in your `.bashrc` (or `.zshrc` for zsh):

```bash
export BASH_TOYS_INTERACTIVE_FILTER=fzf
export BASH_TOYS_DUSTBOX_DIR="$HOME/dustbox"
export BASH_TOYS_BATCAT_OPTIONS=''
```

4. Install a tool you want

```shell-session
$ curl https://raw.githubusercontent.com/aiya000/bash-toys/refs/heads/main/bin/bak -o ~/bin/bak
```

For `./sources/*`, don't forget to `source`:

```shell-session
$ curl https://raw.githubusercontent.com/aiya000/bash-toys/refs/heads/main/sources/cd-to-git-root.sh -o /path/to/sources/cd-to-git-root.sh
$ echo 'source /path/to/sources/cd-to-git-root.sh' >> ~/.bashrc
```

## :bookmark_tabs: Contributing

We welcome contributions! Please follow these steps.

1. Create an issue for the feature you want to add
1. Wait for maintainers to approve the feature
1. Open a pull request!

## :bookmark_tabs: License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Happy scripting! :dog2:
