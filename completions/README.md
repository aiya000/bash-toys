# Completion Scripts

This directory contains shell completion scripts for bash-toys commands.

The scripts use the bash completion API (`complete`, `compgen`, `COMPREPLY`),
which works in both **bash** and **zsh** (via `bashcompinit`).

Note: `.bash` is a naming convention for completion scripts using the bash completion API.

## Installation

### Bash

Add the following to your `~/.bashrc`:

```bash
source /path/to/bash-toys/source-completions-all.sh
```

### Zsh

Add the following to your `~/.zshrc`:

```zsh
autoload -U +X bashcompinit && bashcompinit
source /path/to/bash-toys/source-completions-all.sh
```

### Individual completion

Or for a specific command only:

```bash
# bash
source /path/to/bash-toys/completions/rm-dust.bash

# zsh (after bashcompinit is loaded)
autoload -U +X bashcompinit && bashcompinit
source /path/to/bash-toys/completions/rm-dust.bash
```

## Available Completions

### bin commands

| Command | Options | Argument completion |
|---|---|---|
| `bak` | `--help`, `-h` | files |
| `bookmark-open` | `--help`, `-h` | — |
| `calc-japanese-remaining-working-hours` | `--help`, `-h` | — |
| `cat-which` | `--help`, `-h`, `--no-bat` | command names |
| `clamdscan-full` | `--help`, `-h` | directories |
| `ctags-auto` | `--help`, `-h` | — |
| `date-diff-seconds` | `--help`, `-h` | — |
| `date-diff-seconds-now` | `--help`, `-h` | — |
| `docker-attach-menu` | `--help`, `-h` | — |
| `docker-kill-menu` | `--help`, `-h` | — |
| `expects` | `--help`, `-h` | matchers (`to_be`, `to_equal`, `not`, …) |
| `fast-sync` | `--help`, `-h`, `--init` | directories |
| `gh-issue-view-select` | `--help`, `-h` | — |
| `gh-run-view-latest` | `--help`, `-h`, `--log`, `--web`, `--json` | — |
| `git-common-root` | `--help`, `-h` | — |
| `git-root` | `--help`, `-h` | — |
| `git-stash-rename` | `--help`, `-h` | — |
| `is-in-wsl` | `--help`, `-h` | — |
| `list-dpkg-executables` | `--help`, `-h` | package names |
| `notify` | `--help`, `-h` | — |
| `notify-at` | `--help`, `-h`, `--ntfy`, `--local`, `-l`, `--list`, `-c`, `--cancel` | — |
| `notify-at-at` | `--help`, `-h`, `--ntfy`, `--local`, `-l`, `--list`, `-c`, `--cancel` | — |
| `notify-at-launchd` | `--help`, `-h`, `--ntfy`, `--local`, `-l`, `--list`, `-c`, `--cancel` | — |
| `notify-cascade` | `--help`, `-h`, `--ntfy`, `--local` | — |
| `notify-ntfy` | `--help`, `-h` | — |
| `pathshorten` | `--help`, `-h` | — |
| `peco-reverse` | `--help`, `-h` | — |
| `photoframe` | `--help`, `-h` | files |
| `pomodoro-timer` | `--help`, `-h`, `--rest`, `--from`, `--set-count`, `--get-count`, `--clean` | — |
| `rm-dust` | `--help`, `-h`, `--restore`, `--keep` | files / dustbox entries |
| `run-wait-output` | `--help`, `-h` | — |
| `skip` | `--help`, `-h` | files |
| `slice` | `--help`, `-h` | — |
| `start` | `--help`, `-h` | command names |
| `take-until-empty` | `--help`, `-h` | files |
| `vim-configure` | `--help`, `-h` | — |
| `vim-configure-debug` | `--help`, `-h` | — |
| `vim-configure-macos` | `--help`, `-h` | — |

### source functions

| Function | Options | Argument completion |
|---|---|---|
| `alias-of` | `--help`, `-h` | command names |
| `cd-finddir` | `--help`, `-h` | — |
| `cd-to-git-root` | `--help`, `-h` | — |
| `cd-to-node-root` | `--help`, `-h` | — |
| `contains-value` | `--help`, `-h` | — |
| `define-alt` | `--help`, `-h`, `--empty-array` | — |
| `define-alt-export` | `--help`, `-h` | — |
| `force-unexport` | `--help`, `-h` | exported variable names |
| `get-var` | `--help`, `-h` | variable names |
| `i-have` | `--help`, `-h` | command names |
| `is-array` | `--help`, `-h` | variable names |
| `load-my-env` | `--help`, `-h` | env names (`cabal`, `cargo`, `nvm`, …) |
| `nvim-parent-edit` | `--help`, `-h` | open methods (`tabnew`, `split`, `vsplit`) then files |
| `source-if-exists` | `--help`, `-h` | files |

### rm-dust (detailed)

Provides intelligent completion for the `rm-dust` command:

- **Options**: Completes `--help`, `-h`, `--restore`, `--keep`
- **File paths**: Completes normal file paths when adding files to dustbox
- **Dustbox files**: When using `--restore`, completes with files currently in the dustbox

**Example usage**:

```bash
# Complete options
$ rm-dust --<TAB>
--help  --restore  --keep

# Complete with dustbox files when using --restore
$ rm-dust --restore <TAB>
+tmp+file1.txt_2026-02-03_13:32:52.txt  +tmp+file2.txt_2026-02-03_13:32:53.txt
```

## License

These completion scripts are part of bash-toys and are licensed under the MIT License.
