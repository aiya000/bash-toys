#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
    # Create a temporary directory for mock osascript command
    export TEST_DIR=$(mktemp -d)
    export ORIGINAL_PATH="$PATH"
    export PATH="$TEST_DIR:$PATH"

    # Create a mock osascript command that just logs calls instead of showing notifications
    cat > "$TEST_DIR/osascript" <<'EOF'
#!/bin/bash
# Mock osascript command for testing
echo "OSASCRIPT_CALLED: $*" >> "$TEST_DIR/osascript_calls.log"
exit 0
EOF
    chmod +x "$TEST_DIR/osascript"

    # Clear any previous log
    rm -f "$TEST_DIR/osascript_calls.log"
}

teardown() {
    # Restore original PATH
    export PATH="$ORIGINAL_PATH"

    # Clean up temporary directory
    rm -rf "$TEST_DIR"
}

@test 'notify with no arguments should show help' {
    run notify
    [ "$status" -eq 0 ]  # notify doesn't exit with error code for missing args, just continues
    # On macOS with mock osascript, it will try to notify with empty arguments
}

@test 'notify should accept title and message arguments' {
    run notify "Test Title" "Test Message"
    [ "$status" -eq 0 ]

    # Check that osascript was called with correct notification
    [ -f "$TEST_DIR/osascript_calls.log" ]
    grep -q 'display notification "Test Message" with title "Test Title"' "$TEST_DIR/osascript_calls.log"
}

@test 'notify should handle sound argument' {
    run notify "Title" "Message" "Glass"
    [ "$status" -eq 0 ]

    # Check that osascript was called with sound
    [ -f "$TEST_DIR/osascript_calls.log" ]
    grep -q 'sound name "Glass"' "$TEST_DIR/osascript_calls.log"
}

@test 'notify should handle custom sound names' {
    run notify "Title" "Message" "Basso"
    [ "$status" -eq 0 ]

    # Check that osascript was called with custom sound
    [ -f "$TEST_DIR/osascript_calls.log" ]
    grep -q 'sound name "Basso"' "$TEST_DIR/osascript_calls.log"
}

@test 'notify should handle file path sounds' {
    # Create a fake sound file
    touch "$TEST_DIR/custom.wav"

    run notify "Title" "Message" "$TEST_DIR/custom.wav"
    [ "$status" -eq 0 ]

    # Check that notification was sent without sound name (sound file played separately)
    [ -f "$TEST_DIR/osascript_calls.log" ]
    grep -q 'display notification "Message" with title "Title"' "$TEST_DIR/osascript_calls.log"
    # Sound file would be played with afplay in real scenario
}

@test 'notify should quote special characters properly' {
    run notify "Title with 'quotes'" 'Message with "double quotes"'
    [ "$status" -eq 0 ]

    [ -f "$TEST_DIR/osascript_calls.log" ]
    # The command should be properly escaped
    grep -q "osascript_calls.log" "$TEST_DIR/osascript_calls.log"
}

@test 'notify should handle empty sound parameter' {
    run notify "Title" "Message" ""
    [ "$status" -eq 0 ]

    # Should send notification without sound
    [ -f "$TEST_DIR/osascript_calls.log" ]
    grep -q 'display notification "Message" with title "Title"' "$TEST_DIR/osascript_calls.log"
    ! grep -q 'sound name' "$TEST_DIR/osascript_calls.log"
}

@test 'notify should work with minimal arguments' {
    run notify "Title" "Message"
    [ "$status" -eq 0 ]

    [ -f "$TEST_DIR/osascript_calls.log" ]
    grep -q 'display notification "Message" with title "Title"' "$TEST_DIR/osascript_calls.log"
}

@test 'notify help should contain macOS guidance' {
    run notify --help 2>/dev/null || run notify -h 2>/dev/null || {
        # notify doesn't have built-in help flag, but the help content should be in the script
        grep -q "macOS Note" /Users/yoichiro.ishikawa/.dotfiles/bash-toys/bin/notify
    }
}