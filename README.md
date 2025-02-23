# :dog2: bash-toys :dog2:

Welcome to **bash-toys**!

## Overview

**bash-toys** is "Tiny Tools that Reach the Finer Details". It's a collection of shell scripts and aliases for bash/zsh designed to simplify your life and make your terminal experience more enjoyable.

## Scripts

- `dust`: An alternative to `rm`, moving files to a dustbox instead. Similar to [gomi](https://github.com/babarot/gomi), but with no dependencies (no Golang required).
- `which-bin`: A shorthand for `cat $(which cmd)`. Automatically uses [bat (batcat)](https://github.com/sharkdp/bat) instead of `cat` if available.
- `pomodoro-start`: A basic CLI Pomodoro timer implementation in shell script.
- `vim-configure`: Executes `./configure` for Vim source with modern flags. Requires some packages. See https://vim-jp.org/docs/build_linux.html for details.
- `vim-configure-debug`: Executes `./configure` for Vim source for testing purposes. Requires some packages. See https://vim-jp.org/docs/build_linux.html for details.

## Getting Started

1. Clone the repository and start exploring the scripts:

```shell-session
$ git clone https://github.com/aiya000/bash-toys.git path/to/bash-toys
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

2. Add the `bin` directory to your `$PATH`:

```shell-session
$ echo 'export PATH=$PATH:path/to/bash-toys/bin' >> ~/.bashrc
$ source ~/.bashrc
```

3. Source the functions in your shell:

```bash
$ vim ~/.bashrc  # or your .zshrc

for script in path/to/bash-toys/functions/*.sh ; do
  source "$script"
done
```

Note: Functions should be sourced in the parent shell and cannot execute in a subshell, as they affect the parent shell's state.

## All Options

Please see `./default-options.sh` and configure your options as needed.

## Optional Dependencies

### If macOS

- `mpg123`: For `pomodoro-start` (if `$BASH_TOYS_MUSIC_PLAYER` is set to the default value).

### If Linux (Non WSL)

- `vlc`: For `pomodoro-start` (if `$BASH_TOYS_MUSIC_PLAYER` is set to the default value).

## Contributing

We welcome contributions! Please follow these steps:

1. Create an issue for the feature you want to add.
2. Wait for maintainers to approve the feature.
   - Unless it's a really bad idea, they probably won't say no :dog2:
3. Open a pull request!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

- - -

Happy scripting! :dog2:
