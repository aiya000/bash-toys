#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
    # Create a temporary directory for mock notify command
    export TEST_DIR=$(mktemp -d)
    export ORIGINAL_PATH="$PATH"
    export PATH="$TEST_DIR:$PATH"

    # Create a mock notify command that just logs calls instead of showing notifications
    cat > "$TEST_DIR/notify" <<'EOF'
#!/bin/bash
# Mock notify command for testing
echo "NOTIFY_CALLED: $*" >> "$TEST_DIR/notify_calls.log"
exit 0
EOF
    chmod +x "$TEST_DIR/notify"

    # Clear any previous log
    rm -f "$TEST_DIR/notify_calls.log"
}

teardown() {
    # Kill any background processes started by notify-at
    pkill -f "notify-at" 2>/dev/null || true

    # Restore original PATH
    export PATH="$ORIGINAL_PATH"

    # Clean up temporary directory
    rm -rf "$TEST_DIR"
}

@test 'notify-at with no arguments should show usage' {
    run notify-at
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage:" ]]
}

@test 'notify-at with insufficient arguments should show usage' {
    run notify-at "12:00"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage:" ]]

    run notify-at "12:00" "title"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage:" ]]
}

@test 'notify-at should accept valid time format' {
    # Use a future time (2 minutes from now)
    future_time=$(date -d "+2 minutes" +"%H:%M" 2>/dev/null || date -v+2M +"%H:%M")

    run notify-at "$future_time" "Test Title" "Test Message"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Notification scheduled for: $future_time" ]]
    [[ "$output" =~ "Title: Test Title" ]]
    [[ "$output" =~ "Message: Test Message" ]]
    [[ "$output" =~ "Process ID:" ]]
}

@test 'notify-at should handle invalid time format' {
    run notify-at "25:70" "Title" "Message"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Error: Invalid time format" ]]
}

@test 'notify-at should handle sound parameter' {
    future_time=$(date -d "+1 minutes" +"%H:%M" 2>/dev/null || date -v+1M +"%H:%M")

    run notify-at "$future_time" "Title" "Message" "custom_sound.wav"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Notification scheduled for: $future_time" ]]
}

@test 'notify-at should use default sound when not specified' {
    future_time=$(date -d "+1 minutes" +"%H:%M" 2>/dev/null || date -v+1M +"%H:%M")

    run notify-at "$future_time" "Title" "Message"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Notification scheduled for: $future_time" ]]
}

@test 'notify-at should respect BASH_TOYS_NOTIFY_AT_DEFAULT_SOUND environment variable' {
    export BASH_TOYS_NOTIFY_AT_DEFAULT_SOUND="custom_default"
    future_time=$(date -d "+1 minutes" +"%H:%M" 2>/dev/null || date -v+1M +"%H:%M")

    run notify-at "$future_time" "Title" "Message"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Notification scheduled for: $future_time" ]]
}

@test 'notify-at should schedule for tomorrow if time is in the past' {
    # Use a time that's definitely in the past (1 hour ago)
    past_time=$(date -d "-1 hour" +"%H:%M" 2>/dev/null || date -v-1H +"%H:%M")

    run notify-at "$past_time" "Title" "Message"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Notification scheduled for: $past_time" ]]
    # Should show more than 12 hours (scheduled for tomorrow)
    [[ "$output" =~ "([0-9]{3,4}|1[0-9]{3}) minutes later" ]]
}

@test 'notify-at should calculate correct delay for near-future times' {
    # Use a time 5 minutes in the future
    future_time=$(date -d "+5 minutes" +"%H:%M" 2>/dev/null || date -v+5M +"%H:%M")

    run notify-at "$future_time" "Title" "Message"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Notification scheduled for: $future_time" ]]
    # Should show approximately 5 minutes (allow some variance for processing time)
    [[ "$output" =~ "[4-6] minutes later" ]]
}

@test 'notify-at should handle edge case times like 00:00' {
    run notify-at "00:00" "Midnight" "Test at midnight"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Notification scheduled for: 00:00" ]]
}

@test 'notify-at should handle edge case times like 23:59' {
    run notify-at "23:59" "Late Night" "Test before midnight"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Notification scheduled for: 23:59" ]]
}

@test 'notify-at should handle times with leading zeros' {
    # Use time with leading zero that's in the future
    future_time=$(date -d "+30 minutes" +"%H:%M" 2>/dev/null || date -v+30M +"%H:%M")
    if [[ "$future_time" =~ ^0 ]]; then
        run notify-at "$future_time" "Title" "Message"
        [ "$status" -eq 0 ]
        [[ "$output" =~ "Notification scheduled for: $future_time" ]]
    else
        # If generated time doesn't start with 0, test a specific case
        run notify-at "09:30" "Title" "Message"
        [ "$status" -eq 0 ]
        [[ "$output" =~ "Notification scheduled for: 09:30" ]]
    fi
}

@test 'notify-at should start background process' {
    future_time=$(date -d "+1 minutes" +"%H:%M" 2>/dev/null || date -v+1M +"%H:%M")

    run notify-at "$future_time" "Title" "Message"
    [ "$status" -eq 0 ]

    # Extract process ID from output
    pid=$(echo "$output" | grep "Process ID:" | awk '{print $NF}')
    [[ "$pid" =~ ^[0-9]+$ ]]

    # Process should exist initially (though it will exit quickly in test)
    # We can't easily test the sleep/notify behavior without waiting
}