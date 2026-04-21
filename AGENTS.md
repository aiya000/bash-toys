# AGENTS.md

When contributing or modifying scripts, please ensure adherence to these style guidelines.

## Bash Coding Style Conventions

This project follows specific bash coding style conventions for consistency and readability.

### String Comparison Style

Use explicit string comparison instead of test operators:

```bash
# Preferred (explicit)
[[ $foo == '' ]]
[[ $bar != '' ]]

# Avoid (implicit test operators)
[[ -n "$foo" ]]
[[ -z "$bar" ]]
```

### Quoting Style

#### Normal Command Arguments

```bash
# Preferred (no quotes)
cmd arg1 arg2

# Preferred (variables needs double quotes)
cmd "$variable"

# Avoid (plain strings doesn't need quotes)
cmd "arg1" "arg2"
cmd 'arg1' 'arg2'
```

#### Test Expressions Lhs

```bash
# Preferred (no quotes)
[[ $variable == 'value' ]]

# Avoid (unnecessary quotes)
[[ "$variable" == 'value' ]]

# Avoid (unnecessary quotes)
[[ $variable == 'value' ]]
```

#### Test Expressions Rhs

```bash
# Preferred (single quotes)
[[ $variable == 'value' ]]

# Avoid (double quotes)
[[ "$variable" == "value" ]]
```

### Conditional Statement Formatting

Add spaces around semicolons in conditional statements:

```bash
# Preferred (spaces around semicolon)
if some condition ; then
    # code here
fi

# Avoid (no space before semicolon)
if some condition; then
    # code here
fi
```

### Test Command Style

Use bash-style double brackets instead of POSIX single brackets:

```bash
# Preferred (bash-style)
[[ some condition ]]

# Avoid (POSIX sh-style)
[ some condition ]
```

### Indentation Style

Use 2 spaces for indentation (not tabs or 4 spaces):

```bash
# Preferred (2 spaces)
if [[ condition ]] ; then
  echo "two spaces"
  if [[ nested ]] ; then
    echo "four spaces for nested"
  fi
fi

# Avoid (4 spaces or tabs)
if [[ condition ]] ; then
    echo "four spaces - avoid"
    if [[ nested ]] ; then
        echo "eight spaces - avoid"
    fi
fi
```

## Test Injection via DEBUG_BASHTOYS_*

Scripts may support `DEBUG_BASHTOYS_*` environment variables to enable test-friendly behavior without modifying core logic.

### DEBUG_BASHTOYS_PARSE_ONLY

When a script sets `DEBUG_BASHTOYS_PARSE_ONLY=1`, it outputs parsed configuration values and exits before performing any side effects (e.g., running Docker, making network requests).

Use this in tests to verify argument/env-var parsing in isolation:

```bash
run env DEBUG_BASHTOYS_PARSE_ONLY=1 some-command --host 192.168.1.10
expects "$output" to_match 'host=192.168.1.10'
```

To unset an env var for a specific test run, use `env -u VAR`:

```bash
run env -u BASH_TOYS_NTFY_SERVING_URL DEBUG_BASHTOYS_PARSE_ONLY=1 some-command
```

## Running Tests

Use the project-local bats binary to run tests:

```bash
lib/bats/bin/bats test/<name>.bats
```

## Checklist When Modifying bin/ Commands

When adding or changing options/behavior of a command in `bin/`, update **all** of the following that exist for that command:

- **`bin/`** — The command itself
- **`completions/`** — Bash/Zsh completion files (add new options to the completion word list)
- **`test/`** — Bats test files (add tests for new behavior; no-argument/empty-state tests can run without `BASH_TOYS_TEST_REAL_JOBS=1`)
- **`doc/bin.md`** — Usage description, options list, and examples
- **`README.md`** — Add a row to the Executables table; add an entry to the Recommended Scripts section if the command is noteworthy

## Checklist When Modifying sources/ Functions

When adding or changing a function in `sources/`, update the following:

- **`sources/`** — The function file itself
- **`doc/sources.md`** — Always update alongside the implementation
- **`completions/`** — Update the corresponding `.bash` file if one exists for that function (not all sources have completions)
- **`test/`** — Update the corresponding `.bats` file if one exists for that function (not all sources have tests)

## Option Implementation Guidelines

### Position-Independent Options

When adding command-line options to scripts, options must work regardless of their position in the argument list:

```bash
# Both of these must work identically
script --option arg
script arg --option
```

Implementation pattern:

```bash
option_flag=false
args=()
for arg in "$@"; do
  if [[ $arg == --option ]]; then
    option_flag=true
  else
    args+=("$arg")
  fi
done
set -- "${args[@]}"
```
