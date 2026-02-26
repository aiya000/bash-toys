# sources/ Functions

Shell functions in the `sources/` directory. Source these files to use the functions in your shell.

```bash
# Source all functions
source /path/to/bash-toys/source-all.sh

# Or source individual files
source /path/to/bash-toys/sources/alias-of.sh
```

## Navigation

### cd-finddir

Interactively selects and cds to a directory.

```bash
cd-finddir
```

Lists directories (up to 6 depth with fd, 3 with find) and lets you select one using `BASH_TOYS_INTERACTIVE_FILTER`.

**Environment Variables**:
- `BASH_TOYS_INTERACTIVE_FILTER` - Interactive filter command for directory selection (default: `peco`)

**Examples**:
```bash
$ cd-finddir
# (Interactive filter shows directories)
# ./src
# ./src/components
# ./tests
# (Select a directory to cd into)
$ pwd
/path/to/project/src/components
```

### cd-to-git-root

Changes directory to git repository root.

```bash
cd-to-git-root
```

Supports WSL path conversion when running on Windows file systems.

**Examples**:
```bash
$ pwd
/path/to/repo/src/components/button
$ cd-to-git-root
$ pwd
/path/to/repo
```

### cd-to-node-root

Changes directory to Node.js project root.

```bash
cd-to-node-root
```

Searches upward for package.json and changes to that directory.

**Examples**:
```bash
$ pwd
/path/to/project/src/utils/helpers
$ cd-to-node-root
$ pwd
/path/to/project
$ ls package.json
package.json
```

## Variable Management

### define-alt

Defines variable if not already defined.

```bash
define-alt [--export] <var_name> [value...]
define-alt [--export] --empty-array <var_name>
```

**Options**:
- `--export` - Also export the variable (like `define-alt-export`)

**Examples**:
```bash
define-alt a 10                  # Define scalar: a=10
define-alt xs 1 2 3             # Define array: xs=(1 2 3)
define-alt --empty-array ys     # Define empty array
define-alt --export EDITOR vim  # Define and export
```

If variable already exists, value is not changed.

> **Note:** Array variables set with `--export` are accessible in the current
> shell, but **cannot be passed to child processes** via the environment. This
> is a POSIX limitation: the environment only supports string `key=value` pairs,
> so arrays are silently reduced to a scalar when exported. Neither bash nor zsh
> can work around this constraint.

### define-alt-export

Alias for `define-alt --export`. Defines and exports variable if not already defined.

```bash
define-alt-export <var_name> [value...]
```

**Examples**:
```bash
$ define-alt-export EDITOR vim
$ echo $EDITOR
vim
$ env | grep EDITOR
EDITOR=vim

# Does not override existing value
$ export PATH_BACKUP=/custom/path
$ define-alt-export PATH_BACKUP /default/path
$ echo $PATH_BACKUP
/custom/path
```

### get-var

Gets value of variable by name.

```bash
get-var <var_name>
```

**Example**:
```bash
name=42
get-var name    # Output: 42
get-var undefined || echo 'not found'
```

### force-unexport

Unexports a variable while keeping its value.

```bash
force-unexport <var_name>...
```

**Example**:
```bash
export FOO=1
force-unexport FOO
# FOO is now a local variable, not exported
```

## Type Checking

### is-array

Checks if variable is an array.

```bash
is-array <var_name>
```

**Example**:
```bash
foo=()
is-array foo && echo yes  # Output: yes

bar=1
is-array bar || echo no   # Output: no
```

### contains-value

Checks if array contains a value.

```bash
contains-value "${array[@]}" "value"
```

**Example**:
```bash
my_array=(apple banana cherry)
if contains-value "${my_array[@]}" "banana" ; then
  echo 'Found!'
fi
```

## Command Helpers

### alias-of

Creates alias if command exists.

```bash
alias-of <name> <detail>
```

**Example**:
```bash
alias-of rg 'rg --color always --hidden'
# Creates alias only if 'rg' command exists
```

### i-have

Checks if command exists.

```bash
i-have <command>
```

**Example**:
```bash
if i-have batcat ; then
  alias bat=batcat
fi
```

## Sourcing

### source-if-exists

Sources a file if it exists.

```bash
source-if-exists <file>
```

Silently skips if file doesn't exist. Useful for optional configuration files.

**Example**:
```bash
source-if-exists ~/.bashrc.local
source-if-exists /etc/profile.d/custom.sh
```

## Environment Loading

### load-my-env

Loads environment configurations for various tools.

```bash
load-my-env <env_name>
load-my-env help
```

**Available environments**:
- cabal, cargo, ccache, conda, docker, drawio, gcloud
- gradlew, idris, linuxbrew, mise, nvm, pkgsrc
- rbenv, stack, travis, virtualenv

**Example**:
```bash
load-my-env docker    # Sets up docker aliases
load-my-env nvm       # Loads nvm
```

## Neovim Integration

### nvim-parent-edit

Opens file in parent Neovim via RPC.

```bash
nvim-parent-edit <open_method> <filename>
```

**Open methods**: `tabnew`, `split`, `vsplit`

**Related functions**:
- `nvim-parent-tabnew <file>` - Open in new tab
- `nvim-parent-split <file>` - Open in horizontal split
- `nvim-parent-vsplit <file>` - Open in vertical split

**Examples**:
```bash
# Open file in parent Neovim's new tab
$ nvim-parent-tabnew README.md

# Open in horizontal split
$ nvim-parent-split config.lua

# Open in vertical split
$ nvim-parent-vsplit utils.lua

# Generic form
$ nvim-parent-edit tabnew /path/to/file.txt
```

**Requirements**: `NVIM_PARENT_ADDRESS` environment variable (set by parent Neovim)

**Setup** (in parent Neovim):
```lua
vim.fn.jobstart(vim.env.SHELL, {
  env = {
    NVIM_PARENT_ADDRESS = vim.v.servername,
  },
})
```
