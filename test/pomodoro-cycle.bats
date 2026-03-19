#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
  # Ensure we use commands from this repository, not from PATH
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"

  # Create temp dir for mock commands (prepend to PATH to override real commands)
  MOCK_DIR="$(mktemp -d)"
  export PATH="$MOCK_DIR:$PATH"

  # Mock pomodoro-timer to record calls without sleeping
  cat > "$MOCK_DIR/pomodoro-timer" << 'EOF'
#!/bin/bash
echo "pomodoro-timer $*"
EOF
  chmod +x "$MOCK_DIR/pomodoro-timer"

  # Mock prompt to avoid blocking on input
  cat > "$MOCK_DIR/prompt" << 'EOF'
#!/bin/bash
echo "prompt $*"
EOF
  chmod +x "$MOCK_DIR/prompt"

  # Mock notify and notify-ntfy to avoid side effects
  cat > "$MOCK_DIR/notify" << 'EOF'
#!/bin/bash
echo "notify $*"
EOF
  chmod +x "$MOCK_DIR/notify"

  cat > "$MOCK_DIR/notify-ntfy" << 'EOF'
#!/bin/bash
echo "notify-ntfy $*"
EOF
  chmod +x "$MOCK_DIR/notify-ntfy"

  # Mock sleep to avoid waiting in the final step
  cat > "$MOCK_DIR/sleep" << 'EOF'
#!/bin/bash
echo "sleep $*"
EOF
  chmod +x "$MOCK_DIR/sleep"
}

teardown() {
  rm -rf "$MOCK_DIR"
}

# --- Help ---

@test '`pomodoro-cycle --help` should show help message' {
  run pomodoro-cycle --help
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^pomodoro-cycle - '
}

@test '`pomodoro-cycle -h` should show help message' {
  run pomodoro-cycle -h
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^pomodoro-cycle - '
}

@test '`pomodoro-cycle --help` should show usage and examples' {
  run pomodoro-cycle --help
  expects "$status" to_be 0
  expects "$output" to_contain 'Usage:'
  expects "$output" to_contain 'Examples:'
}

# --- Output header ---

@test '`pomodoro-cycle` should show 3 steps with 30 min each by default' {
  run pomodoro-cycle
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'Start pomodoro cycle: 3 steps with \[30 30 30\] minutes in each step'
}

@test '`pomodoro-cycle` should show custom step count in header' {
  run pomodoro-cycle 2
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'Start pomodoro cycle: 2 steps'
}

@test '`pomodoro-cycle` should show custom times in header' {
  run pomodoro-cycle 3 25 25 25
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'Start pomodoro cycle: 3 steps with \[25 25 25\] minutes in each step'
}

# --- Timer calls ---

@test '`pomodoro-cycle` should call `pomodoro-timer --clean` at the start' {
  run pomodoro-cycle 1
  expects "$status" to_be 0
  expects "$output" to_contain 'pomodoro-timer --clean'
}

@test '`pomodoro-cycle` should call work timer for each step with correct time' {
  run pomodoro-cycle 2 45 20
  expects "$status" to_be 0
  expects "$output" to_contain 'pomodoro-timer 45'
  expects "$output" to_contain 'pomodoro-timer 20'
}

@test '`pomodoro-cycle` should call rest timer and prompt between steps' {
  run pomodoro-cycle 2
  expects "$status" to_be 0
  expects "$output" to_contain 'pomodoro-timer --rest'
  expects "$output" to_contain 'prompt'
}

@test '`pomodoro-cycle` should NOT call rest timer after the last step' {
  run pomodoro-cycle 1
  expects "$status" to_be 0
  expects "$output" not to_contain 'pomodoro-timer --rest'
  expects "$output" not to_contain 'prompt'
}

@test '`pomodoro-cycle` should send desktop notification after the last step' {
  run pomodoro-cycle 1
  expects "$status" to_be 0
  expects "$output" to_contain 'notify pomodoro-cycle finished'
}

@test '`pomodoro-cycle` should NOT send ntfy notification without --ntfy' {
  run pomodoro-cycle 1
  expects "$status" to_be 0
  expects "$output" not to_contain 'notify-ntfy'
}

@test '`pomodoro-cycle --ntfy` should send ntfy notification after the last step' {
  run pomodoro-cycle --ntfy 1
  expects "$status" to_be 0
  expects "$output" to_contain 'notify-ntfy pomodoro-cycle finished'
  expects "$output" to_contain 'notify pomodoro-cycle finished'
}

@test '`pomodoro-cycle --ntfy` should still use positional args correctly' {
  run pomodoro-cycle --ntfy 2 45 20
  expects "$status" to_be 0
  expects "${lines[0]}" to_match 'Start pomodoro cycle: 2 steps with \[45 20'
}
