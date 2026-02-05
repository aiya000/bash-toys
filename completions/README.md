# Bash Completion Scripts

This directory contains bash completion scripts for bash-toys commands.

## Installation

To enable bash completion, add the following to your `~/.bashrc`:

```bash
# Source bash-toys completions
for completion in /path/to/bash-toys/completions/*.bash; do
  source "$completion"
done
```

Or for a specific command:

```bash
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
