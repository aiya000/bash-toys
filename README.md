<div align="center">

# :dog2: bash-toys :dog2:

**Tiny Tools that Reach the Finer Details**

![Shell: bash/zsh](https://img.shields.io/badge/Shell-bash%20%7C%20zsh-green)
[![Test](https://github.com/aiya000/bash-toys/actions/workflows/test.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test.yml)
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

```shell-session
$ git clone --depth 1 https://github.com/aiya000/bash-toys.git /path/to/bash-toys
```

If using bash:
```shell-session
$ echo 'source /path/to/bash-toys/source-all.sh' >> ~/.bashrc
```

If using zsh:
```shell-session
$ echo 'source /path/to/bash-toys/source-all.sh' >> ~/.zshrc
```

## :bookmark_tabs: Scripts

For a complete list of scripts, visit [./bin](https://github.com/aiya000/bash-toys/tree/main/bin) and [./sources](https://github.com/aiya000/bash-toys/tree/main/sources).

### :small_blue_diamond: Executables ([./bin](https://github.com/aiya000/bash-toys/tree/main/bin))

bash-toys scripts have **minimal dependencies**.

| Script | Description | Test |
|--------|-------------|:----:|
| `bak` | Toggle backup (.bak) extension for files | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-bak.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-bak.yml) |
| `bash-toys-help` | Show help for bash-toys commands | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `bookmark-open` | Opens a selected bookmark in the default browser | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-bookmark-open.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-bookmark-open.yml) |
| `calc-japanese-remaining-working-hours` | Calculate required daily working hours for remaining business days | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `cat-which` | A shorthand for `cat $(which cmd)`. Uses [bat](https://github.com/sharkdp/bat) if available | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-cat-which.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-cat-which.yml) |
| `clamdscan-full` | Performs a full virus scan using ClamAV | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-clamdscan-full.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-clamdscan-full.yml) |
| `ctags-auto` | Automatically determine git project and generate ctags | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `date-diff-seconds` | Calculate time difference in minutes between two times | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-date-diff-seconds.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-date-diff-seconds.yml) |
| `date-diff-seconds-now` | Calculate time difference between given time and now | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-date-diff-seconds-now.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-date-diff-seconds-now.yml) |
| `docker-attach-menu` | Attach to a Docker container selected from interactive menu | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `docker-kill-menu` | Kill a Docker container selected from interactive menu | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `expects` | A smaller test API like [jest](https://jestjs.io/ja/docs/expect) for bash script | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-expects.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-expects.yml) |
| `fast-sync` | Efficiently sync files from source to target by comparing file lists | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-fast-sync.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-fast-sync.yml) |
| `gh-issue-view-select` | Show GitHub issues in interactive filter and open selected issue | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-gh-issue-view-select.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-gh-issue-view-select.yml) |
| `gh-run-view-latest` | Show the latest GitHub Actions run preview and log | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `git-root` | Shows the git root directory of the current directory | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `is-in-wsl` | Check if current shell is running in WSL | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `kill-latest-started` | Kill the latest started background process | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `kill-list` | Display and kill processes selected from interactive menu | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `list-dpkg-executables` | List executable files provided by a dpkg package | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `notify` | Send desktop notification with title and message | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `notify-at` | Send notification at specified time with flexible date formats | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-notify-at.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-notify-at.yml) |
| `notify-at-at` | Send notification at specified time using at command (Linux/WSL) | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `notify-at-launchd` | Send notification at specified time using launchd (macOS) | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `notify-cascade` | Send cascade of notifications at specified intervals before target time | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `notify-ntfy` | Send notification to mobile via ntfy.sh | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `pathshorten` | Abbreviate file path with shortened parent directories | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `peco-reverse` | Reverse order interactive filter using peco | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `photoframe` | Display photos in fullscreen slideshow mode using feh | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `pomodoro-timer` | A simplest Pomodoro Timer implementation in shell script | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `rm-dust` | An alternative to `rm`, moving files to a dustbox instead. `alias rm=rm-dust` is recommended! | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-dust.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-dust.yml) |
| `run-wait-output` | Run two commands sequentially, with second triggered after first becomes silent | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-run-wait-output.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-run-wait-output.yml) |
| `skip` | Skip n-lines from the beginning of output | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `slice` | Slice fields from input lines | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `start` | Starts a process in the background without output | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `take-until-empty` | Takes input lines until a blank line appears | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-take-until-empty.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-take-until-empty.yml) |
| `vim-configure` | Executes `./configure` for Vim source with modern flags | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `vim-configure-debug` | Execute Vim source configure script with debug flags | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `vim-configure-macos` | Execute Vim source configure script with modern macOS flags | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |

### :small_blue_diamond: Sources ([./sources](https://github.com/aiya000/bash-toys/tree/main/sources))

'Sources' are utility scripts that affect the parent shell (like the `cd` command).

| Script | Description | Test |
|--------|-------------|:----:|
| `alias_of` | Creates an alias only if the command exists | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `cd-finddir` | Shows directories and `cd` to a selected one via interactive filter | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `cd-to-git-root` | Change directory to the git root, with WSL path recovery support | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `cd-to-node-root` | Change directory to the nearest parent directory containing `package.json` | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `contains_value` | Checks if an array contains a value | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `define-alt` | Defines a shell variable named 'foo' if not defined | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `define-alt-export` | Similar to `define-alt`, but for environment variables | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `force-unexport` | Unexports an environment variable | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `get-var` | Read and output the value of a variable by name | [![Test](https://github.com/aiya000/bash-toys/actions/workflows/test-get-var.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test-get-var.yml) |
| `i_have` | Check if a specified command exists in the system | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `is_array` | Detect if a variable is an array (supports Bash and Zsh) | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `load-my-env` | Load environment-specific settings and aliases for various tools and runtimes | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `nvim-parent-edit` | Open files in parent Neovim instance via RPC from child terminal | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |
| `source_if_exists` | Conditionally source a file if it exists | ![No Test](https://img.shields.io/badge/Test-N%2FA-lightgray) |

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
$ git clone --depth 1 https://github.com/aiya000/bash-toys.git path/to/bash-toys
```

2. Source the `source-all.sh` script in your `.bashrc` or `.zshrc`

```shell-session
$ echo 'source path/to/bash-toys/source-all.sh' >> ~/.bashrc
```

3. (**Optional**) Configure options if necessary

```shell-session
$ vim path/to/bash-toys/define-options.sh
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
$ curl https://raw.githubusercontent.com/aiya000/bash-toys/refs/heads/main/sources/cd-to-git-root.sh -o path/to/sources/cd-to-git-root.sh
$ echo 'source path/to/sources/cd-to-git-root.sh' >> ~/.bashrc
```

## :bookmark_tabs: Contributing

We welcome contributions! Please follow these steps.

1. Create an issue for the feature you want to add
1. Wait for maintainers to approve the feature
   - Unless it's a really bad idea, they probably won't say no :dog2:
1. Open a pull request!

## :bookmark_tabs: License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Happy scripting! :dog2:
