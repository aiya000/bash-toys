<div align="center">

# :dog2: bash-toys :dog2:

**Tiny Tools that Reach the Finer Details**

[![Test](https://github.com/aiya000/bash-toys/actions/workflows/test.yml/badge.svg)](https://github.com/aiya000/bash-toys/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Shell: bash/zsh](https://img.shields.io/badge/Shell-bash%20%7C%20zsh-green)
![Dependencies: minimal](https://img.shields.io/badge/Dependencies-minimal-blue)

![](./readme/cat-which-rm-dust.png)

</div>

> [!NOTE]
> Each command in this repository may often contain breaking changes and numerous bugs or work in progress.

## :bookmark_tabs: Table of Contents

- [Quick Start](#quick-start)
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

bash-toys scripts are almost with **minimal dependencies**.

| Script | Description |
|--------|-------------|
| `bak` | Toggle backup (.bak) extension for files |
| `bash-toys-help` | Show help for bash-toys commands |
| `bookmark-open` | Opens a selected bookmark in the default browser |
| `calc-japanese-remaining-working-hours` | Calculate required daily working hours for remaining business days |
| `cat-which` | A shorthand for `cat $(which cmd)`. Uses [bat](https://github.com/sharkdp/bat) if available |
| `clamdscan-full` | Performs a full virus scan using ClamAV |
| `ctags-auto` | Automatically determine git project and generate ctags |
| `date-diff-seconds` | Calculate time difference in minutes between two times |
| `date-diff-seconds-now` | Calculate time difference between given time and now |
| `docker-attach-menu` | Attach to a Docker container selected from interactive menu |
| `docker-kill-menu` | Kill a Docker container selected from interactive menu |
| `expects` | A smaller test API like [jest](https://jestjs.io/ja/docs/expect) for bash script |
| `fast-sync` | Efficiently sync files from source to target by comparing file lists |
| `gh-issue-view-select` | Show GitHub issues in interactive filter and open selected issue |
| `gh-run-view-latest` | Show the latest GitHub Actions run preview and log |
| `git-root` | Shows the git root directory of the current directory |
| `is-in-wsl` | Check if current shell is running in WSL |
| `kill-latest-started` | Kill the latest started background process |
| `kill-list` | Display and kill processes selected from interactive menu |
| `list-dpkg-executables` | List executable files provided by a dpkg package |
| `notify` | Send desktop notification with title and message |
| `notify-at` | Send notification at specified time with flexible date formats |
| `notify-at-at` | Send notification at specified time using at command (Linux/WSL) |
| `notify-at-launchd` | Send notification at specified time using launchd (macOS) |
| `notify-cascade` | Send cascade of notifications at specified intervals before target time |
| `notify-ntfy` | Send notification to mobile via ntfy.sh |
| `pathshorten` | Abbreviate file path with shortened parent directories |
| `peco-reverse` | Reverse order interactive filter using peco |
| `photoframe` | Display photos in fullscreen slideshow mode using feh |
| `pomodoro-timer` | A simplest Pomodoro Timer implementation in shell script |
| `rm-dust` | An alternative to `rm`, moving files to a dustbox instead. `alias rm=rm-dust` is recommended! |
| `run-wait-output` | Run two commands sequentially, with second triggered after first becomes silent |
| `skip` | Skip n-lines from the beginning of output |
| `slice` | Slice fields from input lines |
| `start` | Starts a process in the background without output |
| `take-until-empty` | Takes input lines until a blank line appears |
| `vim-configure` | Executes `./configure` for Vim source with modern flags |
| `vim-configure-debug` | Execute Vim source configure script with debug flags |
| `vim-configure-macos` | Execute Vim source configure script with modern macOS flags |

### :small_blue_diamond: Sources ([./sources](https://github.com/aiya000/bash-toys/tree/main/sources))

'Sources' are utility scripts that affect the parent shell (like the `cd` command).

| Script | Description |
|--------|-------------|
| `alias_of` | Creates an alias only if the command exists |
| `cd-finddir` | Shows directories and `cd` to a selected one via interactive filter |
| `cd-to-git-root` | Change directory to the git root, with WSL path recovery support |
| `cd-to-node-root` | Change directory to the nearest parent directory containing `package.json` |
| `contains_value` | Checks if an array contains a value |
| `define-alt` | Defines a shell variable named 'foo' if not defined |
| `define-alt-export` | Similar to `define-alt`, but for environment variables |
| `force-unexport` | Unexports an environment variable |
| `get-var` | Read and output the value of a variable by name |
| `i_have` | Check if a specified command exists in the system |
| `is_array` | Detect if a variable is an array (supports Bash and Zsh) |
| `load-my-env` | Load environment-specific settings and aliases for various tools and runtimes |
| `nvim-parent-edit` | Open files in parent Neovim instance via RPC from child terminal |
| `source_if_exists` | Conditionally source a file if it exists |

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

3. Install a tool you want

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
