# :dog2: bash-toys :dog2:

Welcome to **bash-toys**!

![Test](https://github.com/github/docs/actions/workflows/test.yml/badge.svg)

![](./readme/cat-which-dust.png)

## :bookmark_tabs: Table of Contents

- [Overview](#bookmark_tabs-overview)
- [Scripts](#bookmark_tabs-scripts)
    - [Bin](#bin)
    - [Sources](#sources)
- [Show help for commands](#bookmark_tabs-show-help-for-commands)
- [Installation](#bookmark_tabs-installation)
    - [Install all tools](#install-all-tools)
    - [Simple](#simple)
    - [Custom](#custom)
    - [Install each of the tools](#install-each-of-the-tools)
- [All Options](#bookmark_tabs-all-options)
- [Optional Dependencies](#bookmark_tabs-optional-dependencies)
- [Contributing](#bookmark_tabs-contributing)
- [License](#bookmark_tabs-license)

## :bookmark_tabs: Overview

**bash-toys** is "Tiny Tools that Reach the Finer Details."

It's a collection of shell scripts and aliases for bash/zsh designed to simplify your life and make your terminal experience more enjoyable.

**Nothing complicated.**

## :bookmark_tabs: Scripts

Rest assured, bash-toys scripts are almost with **few of dependencies**.

For a complete list of scripts, please visit [./bin](https://github.com/aiya000/bash-toys/tree/main/bin) and [./sources](https://github.com/aiya000/bash-toys/tree/main/sources).

### Bin

'bin' contains utility scripts that can run as child processes (in a subshell).

- `dust`: An alternative to `rm`, moving files to a dustbox instead. Similar to [gomi](https://github.com/babarot/gomi), but with no dependencies (no Golang required).
    - `$ alias rm=dust` is highly recommended!
- `pomodoro-timer`: A simplest **Pomodoro Timer** implementation in shell script
  - Please also see `pomodoro-timer-start-from`
- `clamdscan-full`: Performs a full virus scan using ClamAV. Or scans only specified directories.
- `cat-which`: A shorthand for `cat $(which cmd)`. Automatically uses [bat (batcat)](https://github.com/sharkdp/bat) instead of `cat` if available.
- `expects`: A smaller test API like [jest](https://jestjs.io/ja/docs/expect) for bash script.
- `take-until-empty`: Takes input lines until a blank line appears. [Example](./test/take-until-empty.bats)
- `git-root`: Shows the git root directory of the current directory. This is a shorthand for `git rev-parse --show-toplevel 2> /dev/null || return 1`.
- `start`: A shorthand for `"$@" > /dev/null 2>&1 &`. Starts a process in the background without output. This is often useful for running GUI applications from the CLI.
- `vim-configure`: Executes `./configure` for Vim source with modern flags. Requires some packages. See [here](https://vim-jp.org/docs/build_linux.html) for details.

and etc.

### Sources

'Sources' are utility scripts that affect the parent shell. In simple terms, they are like the `cd` command.

- `define-alt`: Defines a shell variable named 'foo' if the 'foo' variable is not defined.
- `define-alt-export`: Similar to `define-alt`, but this defines environment variables.
- `force-unexport`: Unexports an environment variable.
- `cd-finddir`: Shows all directories up to 6 levels deep (if `fd` is available, or 3 levels for `find`), and `cd` to a directory you select.
- `contains_value`: A simple utility that checks if an array contains a value.
- `alias_of`: Creates an alias and overwrites a taken name if you have a specified command (e.g., `alias_of rg 'rg --color always --hidden'` defines a ripgrep alias only if you have the command).

and etc.

## :bookmark_tabs: Show help for commands

Use `bash-toys-help` to display help for any command:

```shell-session
# Show help for bin commands
$ bash-toys-help dust

# Show help for source commands (Don't forget appending .sh extension)
$ bash-toys-help cd-to-git-root.sh

# Show help with markdown rendering (if glow is available)
$ bash-toys-help --disable-glow dust  # Disable markdown rendering
```

## :bookmark_tabs: Installation

In this section, we assumed you are using bash and `~/.bashrc`.
If you are using zsh, replace `~/.bashrc` with `~/.zshrc`.

### Install all tools

Please see the ['Install each of the tools'](#install-each-of-the-tools) section for instructions on how to download each of the tools.

This section presents the easiest way to do this.

1. Clone the repository and start exploring the scripts

```shell-session
$ git clone --depth 1 https://github.com/aiya000/bash-toys.git path/to/bash-toys
```

2. (**Optional**) Configure your options **if necessary**

NOTE: You can use your favorite editor intead of `vim`.

```shell-session
$ cd path/to/bash-toys
$ vim define-options.sh  # Configure your options
```

<details>
<summary>An example of your define-options.sh</summary>

```shell-session
$ cat define-options.sh
export BASH_TOYS_INTERACTIVE_FILTER=fzf
export BASH_TOYS_DUSTBOX_DIR="$HOME/dustbox"
export BASH_TOYS_BATCAT_OPTIONS=''
```

</details>

3. Source the `source-all.sh` script in your `.bashrc` or `.zshrc`

```shell-session
$ echo 'source path/to/bash-toys/source-all.sh' >> ~/.bashrc
```

### Install each of the tools

Here is how to install each of the tools.

1. Install a few of dependencies
    - [fun.sh](https://github.com/ssledz/bash-fun)

You can choice a path instead of `~/lib/bash-toys` freely.

```shell-session
$ mkdir -p ~/lib/bash-toys || true
$ echo ~/lib/bash-toys
$ curl https://raw.githubusercontent.com/aiya000/bash-toys/refs/heads/main/lib/fun.sh -o ~/lib/bash-toys/fun.sh
$ curl https://raw.githubusercontent.com/aiya000/bash-toys/refs/heads/main/define-options.sh -o ~/lib/bash-toys/define-options.sh
$ echo 'source ~/lib/bash-toys/fun.sh' >> ~/.bashrc
$ echo 'source path/to/sources/define-options.sh' >> ~/.bashrc
$ echo 'export PATH=$PATH:~/lib/bash-toys' >> ~/.bashrc
```

2. Install a tool you want into your `$PATH`

For example, in this case, assumed you want to install 'bak'.
Also the following assumes that `$PATH` contains `~/bin`.
You can choice an another path contained by `$PATH` instead of `~/bin`.

```shell-session
$ curl https://raw.githubusercontent.com/aiya000/bash-toys/refs/heads/main/bin/bak -o ~/bin/bak
```

For `./sources/*`, please don't forget, execute `$ source`.
```shell-session
$ curl https://raw.githubusercontent.com/aiya000/bash-toys/refs/heads/main/sources/cd-to-git-root.sh -o path/to/sources/cd-to-git-root.sh
$ echo 'source path/to/sources/cd-to-git-root.sh' >> ~/.bashrc  # or your .zshrc
```

## :bookmark_tabs: All Options

Please see `./define-options.sh` and configure your options as needed.

## :bookmark_tabs: Optional Dependencies

- `vlc`: For `pomodoro-start` (if `$BASH_TOYS_MUSIC_PLAYER` is set to the default value).

## :bookmark_tabs: Contributing

We welcome contributions! Please follow these steps.

1. Create an issue for the feature you want to add.
1. Wait for maintainers to approve the feature.
   - Unless it's a really bad idea, they probably won't say no :dog2:
1. Open a pull request!

## :bookmark_tabs: License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Happy scripting! :dog2:
