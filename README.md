# :dog2: bash-toys :dog2:

Welcome to **bash-toys**!

## Overview

bash-toys is "Tiny Tools that Reach the Finer Details".
A collection of shell script and aliases for bash/zsh.

## Scripts

- `dust`: An alternative of `rm`, but move to dustbox instead. Like [gomi](https://github.com/babarot/gomi), but no dependencies (no golang requirement)
- `which-bin`: A shorthand to `cat $(which cmd)`. This uses [bat (batcat)](https://github.com/sharkdp/bat) instead of `cat` if available automatically
- `pomodoro-start`: A basic CLI pomodoro timer implementation in shell script
- `vim-configure`: Executes ./configure of Vim source with modern flags. This requires some packages. Please also see https://vim-jp.org/docs/build_linux.html
- `vim-configure-debug`: Executes ./configure of Vim source for testing Vim. This requires some packages. Please also see https://vim-jp.org/docs/build_linux.html

## Getting Started

1. To get started with bash-toys, simply clone the repository and start exploring the scripts:

```shell-session
$ git clone https://github.com/aiya000/bash-toys.git path/to/bash-toys
$ cp path-to/bash-toys/default-options.sh ~/my-bash-toys-options.sh
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

2. Add bin to `$PATH`

```shell-session
$ echo 'export $PATH=$PATH:path/to/bash-toys'
```

3. `source` functions in your shell

```bash
$ vim ~/.bashrc  # or your .zshrc

for script in path/to/bash-toys/functions/*.sh ; do
  source "$script"
done
```

'functions' should be executed on parent shell and cannot execute in sub shell, because functions effects parent shell's state.

## All Options

Please see ./default-options.sh and configure yourself if needed.

## Optional Dependencies

### If macOS

- mpg123: for `pomodoro-start` (if `$BASH_TOYS_MUSIC_PLAYER` is default value)

### If Linux (Non WSL)

- vlc: for `pomodoro-start` (if `$BASH_TOYS_MUSIC_PLAYER` is default value)

## Contributing

PR is welcome!
Please follow below instruction.

1. Create an issue for the feature you want to add
1. Create PR when maintainers when maintainers OKs the feature
    - unless it's a really bad feature request, they probably won't NG it :dog2:
1. Open a pull request!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

- - -

Happy scripting! :dog2:
