# AGENTS.md

## Bash Coding Style Conventions

This project follows specific bash coding style conventions for consistency and readability.

### String Comparison Style

**Use explicit string comparison instead of test operators:**

```bash
# Preferred (explicit)
[[ $foo == '' ]]
[[ $bar != '' ]]

# Avoid (implicit test operators)
[[ -n "$foo" ]]
[[ -z "$bar" ]]
```

### Conditional Statement Formatting

**Add spaces around semicolons in conditional statements:**

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

**Use bash-style double brackets instead of POSIX single brackets:**

```bash
# Preferred (bash-style)
[[ some condition ]]

# Avoid (POSIX sh-style)
[ some condition ]
```

### Indentation Style

**Use 2 spaces for indentation (not tabs or 4 spaces):**

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

### Rationale

These conventions prioritize:
- **Explicitness**: String comparisons are more readable when stated explicitly
- **Consistency**: Uniform formatting makes code easier to scan and maintain
- **Bash features**: Using `[[` provides better error handling and feature support than `[`
- **Spacing**: Consistent whitespace improves readability
- **Compactness**: 2-space indentation saves horizontal space while maintaining readability

### Application

These conventions should be applied to all bash scripts in this project, including:
- `bin/notify`
- `bin/notify-at`
- `bin/notify-cascade`
- All other bash utilities

When contributing or modifying scripts, please ensure adherence to these style guidelines.