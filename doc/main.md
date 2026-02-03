# bash-toys Documentation

bash-toys is a collection of useful shell scripts and functions for everyday command-line tasks.

## Quick Start

```bash
# Add bin/ to PATH
export PATH="$PATH:/path/to/bash-toys/bin"

# Source functions
source /path/to/bash-toys/source-all.sh
```

## Help System

All commands and functions support `-h` and `--help` options:

```bash
# Commands
notify --help
bak -h

# Functions
alias-of --help
cd-to-git-root -h
```

## Documentation

- [bin/ Commands](./bin.md) - Executable scripts in `bin/`
- [sources/ Functions](./sources.md) - Sourceable shell functions in `sources/`

## Categories

### Notification System

- `notify` - Send desktop notifications (cross-platform)
- `notify-at` - Schedule notifications at specific times
- `notify-cascade` - Schedule multiple notifications before an event
- `notify-ntfy` - Send mobile notifications via ntfy.sh

### File Operations

- `bak` - Toggle .bak extension for backup/restore
- `rm-dust` - Safe deletion (moves to dustbox instead of deleting)
- `cat-which` - Display contents of executable files
- `fast-sync` - Efficient file synchronization using file lists

### Text Processing

- `skip` - Skip first n lines from input
- `slice` - Extract fields from delimited input
- `take-until-empty` - Output lines until first blank line
- `expects` - Jest-like test assertions for shell scripts

### Process Management

- `start` - Run command in background silently
- `kill-list` - Interactive process killer
- `kill-latest-started` - Kill most recently started process by name
- `run-wait-output` - Run commands with output-triggered execution

### Navigation

- `cd-finddir` - Interactive directory selection
- `cd-to-git-root` - Navigate to git repository root
- `cd-to-node-root` - Navigate to Node.js project root
- `git-root` - Print git repository root path

### Development Tools

- `ctags-auto` - Auto-generate ctags for git projects
- `expects` - Shell script testing framework
- `vim-configure` / `vim-configure-debug` / `vim-configure-macos` - Vim build configuration

### Docker

- `docker-attach-menu` - Interactive container attach
- `docker-kill-menu` - Interactive container kill

### GitHub

- `gh-issue-view-select` - Interactive issue viewer
- `gh-run-view-latest` - View latest GitHub Actions run

### Time & Productivity

- `pomodoro-timer` - CLI pomodoro timer
- `date-diff-seconds` / `date-diff-seconds-now` - Time difference calculation

## Environment Variables

Key configuration options:

| Variable | Description |
|----------|-------------|
| `BASH_TOYS_INTERACTIVE_FILTER` | Interactive filter command (default: fzf) |
| `BASH_TOYS_DUSTBOX_DIR` | Directory for rm-dust deleted files |
| `BASH_TOYS_NTFY_TOPIC` | ntfy.sh topic for mobile notifications |
| `BASH_TOYS_BATCAT_OPTIONS` | Options passed to bat/batcat |

See individual command help for more environment variables.

## License

MIT License - See [LICENSE](../LICENSE) for details.
