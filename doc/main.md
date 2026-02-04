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
