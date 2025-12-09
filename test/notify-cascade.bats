#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
    # Create a temporary directory for mock notify-at command
    export TEST_DIR=$(mktemp -d)
    export ORIGINAL_PATH="$PATH"
    export PATH="$TEST_DIR:$PATH"

    # Create a mock notify-at command that just logs calls instead of scheduling notifications
    cat > "$TEST_DIR/notify-at" <<'EOF'
#!/bin/bash
# Mock notify-at command for testing
echo "NOTIFY_AT_CALLED: $*" >> "$TEST_DIR/notify_at_calls.log"
echo "Notification scheduled for: $1 (mock)"
echo "Title: $2"
echo "Message: $3"
echo "Process ID: $$"
exit 0
EOF
    chmod +x "$TEST_DIR/notify-at"

    # Clear any previous log
    rm -f "$TEST_DIR/notify_at_calls.log"
}

teardown() {
    # Restore original PATH
    export PATH="$ORIGINAL_PATH"

    # Kill any background processes started by notify-cascade
    pkill -f "notify-cascade" 2>/dev/null || true

    # Clean up temporary directory
    rm -rf "$TEST_DIR"
}

@test 'notify-cascade with no arguments should show usage' {
    run notify-cascade
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage:" ]]
    [[ "$output" =~ "Examples:" ]]
}

@test 'notify-cascade with insufficient arguments should show usage' {
    run notify-cascade "12:00"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage:" ]]

    run notify-cascade "12:00" "title"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage:" ]]
}

@test 'notify-cascade should accept basic valid arguments' {
    # Use a future time (2 minutes from now)
    future_time=$(date -d "+2 minutes" +"%H:%M" 2>/dev/null || date -v+2M +"%H:%M")

    run notify-cascade "$future_time" "Test Title" "Test Message"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Cascade notifications scheduled for: $future_time" ]]
    [[ "$output" =~ "Title: Test Title" ]]
    [[ "$output" =~ "Message: Test Message" ]]
}

@test 'notify-cascade should parse single timing argument' {
    future_time=$(date -d "+2 minutes" +"%H:%M" 2>/dev/null || date -v+2M +"%H:%M")

    run notify-cascade "$future_time" "Title" "Message" "30s"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "30s notification:" ]]
    [[ "$output" =~ "Process IDs:" ]]
}

@test 'notify-cascade should parse multiple timing arguments' {
    future_time=$(date -d "+5 minutes" +"%H:%M" 2>/dev/null || date -v+5M +"%H:%M")

    run notify-cascade "$future_time" "Title" "Message" "2m" "1m" "30s"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "2m notification:" ]]
    [[ "$output" =~ "1m notification:" ]]
    [[ "$output" =~ "30s notification:" ]]
    [[ "$output" =~ "Process IDs:" ]]
}

@test 'notify-cascade should distinguish timing from sound file arguments' {
    future_time=$(date -d "+2 minutes" +"%H:%M" 2>/dev/null || date -v+2M +"%H:%M")

    run notify-cascade "$future_time" "Title" "Message" "30s" "10s" "custom_sound.wav"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "30s notification:" ]]
    [[ "$output" =~ "10s notification:" ]]
    # The sound file should be parsed as the sound parameter (not shown in output but used internally)
}

@test 'notify-cascade should handle invalid time format' {
    run notify-cascade "25:70" "Title" "Message"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Error: Invalid time format" ]]
}

@test 'notify-cascade should skip past timing notifications' {
    # Use a time that's 1 minute in the future, but request a 2-minute-before notification
    future_time=$(date -d "+1 minutes" +"%H:%M" 2>/dev/null || date -v+1M +"%H:%M")

    run notify-cascade "$future_time" "Title" "Message" "2m"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Skipping 2m notification (time already passed)" ]]
}

@test 'notify-cascade should handle no timing arguments (single notification)' {
    future_time=$(date -d "+1 minutes" +"%H:%M" 2>/dev/null || date -v+1M +"%H:%M")

    run notify-cascade "$future_time" "Title" "Message"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Single notification:" ]]
    [[ "$output" =~ "Process ID:" ]]
}

@test 'notify-cascade should respect environment variable for default sound' {
    export BASH_TOYS_NOTIFY_CASCADE_DEFAULT_SOUND="custom_default"
    future_time=$(date -d "+1 minutes" +"%H:%M" 2>/dev/null || date -v+1M +"%H:%M")

    run notify-cascade "$future_time" "Title" "Message"
    [ "$status" -eq 0 ]
    # Sound parameter is used internally but not shown in output
    # We can't easily test the actual sound usage without running the notification
}

@test 'notify-cascade should accept various timing formats' {
    future_time=$(date -d "+10 minutes" +"%H:%M" 2>/dev/null || date -v+10M +"%H:%M")

    # Test hours, minutes, and seconds
    run notify-cascade "$future_time" "Title" "Message" "1h" "30m" "45s"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "1h notification:" ]]
    [[ "$output" =~ "30m notification:" ]]
    [[ "$output" =~ "45s notification:" ]]
}

@test 'notify-cascade timing conversion should work correctly' {
    future_time=$(date -d "+2 hours" +"%H:%M" 2>/dev/null || date -v+2H +"%H:%M")

    # Test that hour timing gets converted properly (should show appropriate minutes)
    run notify-cascade "$future_time" "Title" "Message" "1h"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "1h notification: in" ]]
    # Should show approximately 60 minutes (give or take a minute for processing time)
    [[ "$output" =~ "in [5-6][0-9] minutes" ]]
}

@test 'notify-cascade should handle tomorrow scheduling' {
    # Use a time earlier than current time (should be scheduled for tomorrow)
    past_time=$(date -d "-1 hour" +"%H:%M" 2>/dev/null || date -v-1H +"%H:%M")

    run notify-cascade "$past_time" "Title" "Message" "10s"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Cascade notifications scheduled for: $past_time" ]]
    # Should schedule for tomorrow, so timing should be valid
}

@test 'notify-cascade should call notify-at with correct arguments' {
    future_time=$(date -d "+2 minutes" +"%H:%M" 2>/dev/null || date -v+2M +"%H:%M")

    run notify-cascade "$future_time" "Title" "Message" "1m"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "1m notification:" ]]

    # Check that notify-at was called with correct timing-specific message
    [ -f "$TEST_DIR/notify_at_calls.log" ]
    grep -q "Message (1m before)" "$TEST_DIR/notify_at_calls.log"
}

@test 'notify-cascade should handle single notification without timing' {
    future_time=$(date -d "+1 minutes" +"%H:%M" 2>/dev/null || date -v+1M +"%H:%M")

    run notify-cascade "$future_time" "Single Title" "Single Message"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Single notification:" ]]

    # Check that notify-at was called with original message (no timing suffix)
    [ -f "$TEST_DIR/notify_at_calls.log" ]
    grep -q "$future_time Single Title Single Message" "$TEST_DIR/notify_at_calls.log"
}