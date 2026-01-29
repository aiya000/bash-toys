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
