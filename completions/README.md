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

### rm-dust

Provides intelligent completion for the `rm-dust` command:

- **Options**: Completes `--help`, `-h`, `--restore`
- **File paths**: Completes normal file paths when adding files to dustbox
- **Dustbox files**: When using `--restore`, completes with files currently in the dustbox

**Example usage**:

```bash
# Complete options
$ rm-dust --<TAB>
--help  --restore

# Complete with dustbox files when using --restore
$ rm-dust --restore <TAB>
+tmp+file1.txt_2026-02-03_13:32:52.txt  +tmp+file2.txt_2026-02-03_13:32:53.txt
```

## License

These completion scripts are part of bash-toys and are licensed under the MIT License.
