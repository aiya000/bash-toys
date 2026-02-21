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
| `cat-which` | `--help`, `-h`, `--no-bat` | command names |
| `expects` | `--help`, `-h` | matchers (`to_be`, `to_equal`, `not`, …) |
| `fast-sync` | `--help`, `-h`, `--init` | directories |
| `gh-run-view-latest` | `--help`, `-h`, `--log`, `--web`, `--json` | — |
| `list-dpkg-executables` | `--help`, `-h` | package names |
| `notify-at` | `--help`, `-h`, `--ntfy`, `--local`, `-l`, `--list`, `-c`, `--cancel` | — |
| `notify-at-at` | `--help`, `-h`, `--ntfy`, `--local`, `-l`, `--list`, `-c`, `--cancel` | — |
| `notify-at-launchd` | `--help`, `-h`, `--ntfy`, `--local`, `-l`, `--list`, `-c`, `--cancel` | — |
| `notify-cascade` | `--help`, `-h`, `--ntfy`, `--local` | — |
| `pomodoro-timer` | `--help`, `-h`, `--rest`, `--from`, `--set-count`, `--get-count`, `--clean` | — |
| `rm-dust` | `--help`, `-h`, `--restore`, `--keep` | files / dustbox entries |
| `start` | `--help`, `-h` | command names |

### source functions

| Function | Options | Argument completion |
|---|---|---|
| `alias-of` | `--help`, `-h` | command names |
| `define-alt` | `--help`, `-h`, `--empty-array` | — |
| `force-unexport` | `--help`, `-h` | exported variable names |
| `get-var` | `--help`, `-h` | variable names |
| `i-have` | `--help`, `-h` | command names |
| `is-array` | `--help`, `-h` | variable names |
| `load-my-env` | `--help`, `-h` | env names (`cabal`, `cargo`, `nvm`, …) |
| `nvim-parent-edit` | `--help`, `-h` | open methods (`tabnew`, `split`, `vsplit`) then files |

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
