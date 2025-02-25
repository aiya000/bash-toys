# :dog2: bash-toys :dog2:

Welcome to **bash-toys**!

![](./readme/cat-which-dust.png)

## :bookmark_tabs: Table of Contents

- [Overview](#overview)
- [Scripts](#scripts)
  - [Bin](#bin)
  - [Functions](#functions)
- [Show help for commands](#show-help-for-commands)
- [Installation](#installation)
  - [Simple](#simple)
  - [Custom](#custom)
- [All Options](#all-options)
- [Optional Dependencies](#optional-dependencies)
- [Contributing](#contributing)
- [License](#license)

## :bookmark_tabs: Overview

**bash-toys** is "Tiny Tools that Reach the Finer Details." It's a collection of shell scripts and aliases for bash/zsh designed to simplify your life and make your terminal experience more enjoyable.

**Nothing complicated.**

## :bookmark_tabs: Scripts

Rest assured, bash-toys scripts are almost with **no/few dependencies**.

For a complete list of scripts, please visit [./bin](https://github.com/aiya000/bash-toys/tree/main/bin) and [./functions](https://github.com/aiya000/bash-toys/tree/main/functions).

### Bin

'bin' contains utility scripts that can run as child processes (in a subshell).

- `dust`: An alternative to `rm`, moving files to a dustbox instead. Similar to [gomi](https://github.com/babarot/gomi), but with no dependencies (no Golang required).
    - `$ alias rm=dust` is highly recommended!
- `pomodoro-timer`: A simplest **Pomodoro Timer** implementation in shell script
  - Please also see `pomodoro-timer-start-from`
- `clamdscan-full`: Performs a full virus scan using ClamAV. Or scans only specified directories.
- `cat-which`: A shorthand for `cat $(which cmd)`. Automatically uses [bat (batcat)](https://github.com/sharkdp/bat) instead of `cat` if available.
- `start`: A shorthand for `"$@" > /dev/null 2>&1 &`. Starts a process in the background without output. This is often useful for running GUI applications from the CLI.
- `git-root`: Shows the git root directory of the current directory. This is a shorthand for `git rev-parse --show-toplevel 2> /dev/null || return 1`.
- `vim-configure`: Executes `./configure` for Vim source with modern flags. Requires some packages. See [here](https://vim-jp.org/docs/build_linux.html) for details.
- `vim-configure-debug`: Executes `./configure` for Vim source for testing purposes. Requires some packages. See [here](https://vim-jp.org/docs/build_linux.html) for details.

and etc.

### Functions

'Functions' are utility scripts that affect the parent shell. In simple terms, they are like the `cd` command.

- `define-alt`: Defines a shell variable named 'foo' if the 'foo' variable is not defined.
- `define-alt-export`: Similar to `define-alt`, but this defines environment variables.
- `force-unexport`: Unexports an environment variable.
- `cd-finddir`: Shows all directories up to 6 levels deep (if `fd` is available, or 3 levels for `find`), and `cd` to a directory you select.
- `contains_value`: A simple utility that checks if an array contains a value.
- `alias_of`: Creates an alias and overwrites a taken name if you have a specified command (e.g., `alias_of rg 'rg --color always --hidden'` defines a ripgrep alias only if you have the command).

and etc.

## :bookmark_tabs: Show help for commands

Just we can use `cat-which`!

```shell-session
# `cat-which {cmd-name}` for ./bin/*
# For example:
$ cat-which dust
```

```shell-session
# `cat-which {source-name}.sh` for ./functions/*
# **Please don't forget `.sh`**
$ cat-which cd-to-git-root.sh
```

## :bookmark_tabs: Installation

### Install all tools

1. Clone the repository and start exploring the scripts:

```shell-session
$ git clone https://github.com/aiya000/bash-toys.git path/to/bash-toys
```

2. Configure your options if necessary:

```shell-session
$ cp path/to/bash-toys/default-options.sh ~/my-bash-toys-options.sh
$ vim ~/my-bash-toys-options.sh  # Configure your options
```

<details>
<summary>An example of ~/my-bash-toys-options.sh</summary>

```bash
export BASH_TOYS_INTERACTIVE_FILTER=fzf
export BASH_TOYS_DUSTBOX_DIR="$HOME/dustbox"
export BASH_TOYS_BATCAT_OPTIONS=''
```

</details>

Next, you can choose between two methods.

### Simple

If you want a quick setup, just do this. It will set the appropriate `$PATH` and load all functions automatically.

```shell-session
$ echo 'source path/to/bash-toys/source-all.sh' >> ~/.bashrc  # or your .zshrc
```

In this case, the setup is complete!

### Custom

If you want more control over your environment, follow these steps.

1. Add the `bin` directory to your `$PATH`:

```shell-session
$ echo 'export PATH=$PATH:path/to/bash-toys/bin' >> ~/.bashrc
$ source ~/.bashrc  # If necessary
```

2. Source the functions in your shell:
    - Note: Functions should be sourced in the parent shell and cannot execute in a subshell, as they affect the parent shell's state.

```bash
$ vim ~/.bashrc  # or your .zshrc

# Add this
for script in path/to/bash-toys/functions/*.sh ; do
  source "$script"
done
```

Or source only the ones you want:

```bash
$ vim ~/.bashrc  # or your .zshrc

# Add these
source path/to/bash-toys/functions/source_if_exists.sh
source path/to/bash-toys/functions/force-unexport.sh
source path/to/bash-toys/functions/cd-finddir.sh
source path/to/bash-toys/functions/contains_value.sh
```

### Install each of the tools

You can download into your `$PATH` via `wget` or `curl`.
(The following assumes that `path/to/bin` goes through `$PATH`.)

```shell-session
$ wget https://raw.githubusercontent.com/aiya000/bash-toys/refs/heads/main/bin/bak -O path/to/bin/bak
# or
$ curl https://raw.githubusercontent.com/aiya000/bash-toys/refs/heads/main/bin/bak -o path/to/bin/bak
```

For `./functions/*`, please don't forget, execute `$ source`.
```shell-session
$ wget https://raw.githubusercontent.com/aiya000/bash-toys/refs/heads/main/functions/cd-to-git-root.sh -O path/to/assets/cd-to-git-root.sh
$ source path/to/assets/cd-to-git-root.sh
```

Keep in mind, however, that this method does not allow `git pull`.

## :bookmark_tabs: All Options

Please see `./default-options.sh` and configure your options as needed.

## :bookmark_tabs: Optional Dependencies

- `vlc`: For `pomodoro-start` (if `$BASH_TOYS_MUSIC_PLAYER` is set to the default value).

## :bookmark_tabs: Contributing

We welcome contributions! Please follow these steps:

1. Create an issue for the feature you want to add.
1. Wait for maintainers to approve the feature.
   - Unless it's a really bad idea, they probably won't say no :dog2:
1. Open a pull request!

## :bookmark_tabs: License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Happy scripting! :dog2:
