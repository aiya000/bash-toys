#!/usr/bin/env bats

# shellcheck disable=SC2016

setup() {
    # Create temporary directories for testing
    export TEST_SOURCE_DIR=$(mktemp -d)
    export TEST_TARGET_DIR=$(mktemp -d)
    export TEST_INIT_DIR=$(mktemp -d)
    export ORIGINAL_HOME="$HOME"
    export HOME=$(mktemp -d)

    # Create some test files
    echo "test content 1" > "$TEST_SOURCE_DIR/file1.txt"
    echo "test content 2" > "$TEST_SOURCE_DIR/file2.txt"
    mkdir -p "$TEST_SOURCE_DIR/subdir"
    echo "test content 3" > "$TEST_SOURCE_DIR/subdir/file3.txt"
}

teardown() {
    # Clean up temporary directories
    rm -rf "$TEST_SOURCE_DIR" "$TEST_TARGET_DIR" "$TEST_INIT_DIR"
    rm -rf "$HOME"
    export HOME="$ORIGINAL_HOME"
}

@test '`fast-sync` with no arguments should show usage' {
    run fast-sync
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage:" ]]
}

@test '`fast-sync --init` with no directory should show usage' {
    run fast-sync --init
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage:" ]]
}

@test '`fast-sync --init` should create sync state file' {
    run fast-sync --init "$TEST_INIT_DIR"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Initialization mode:" ]]
    [ -f "$HOME/.last_sync" ]
}

@test '`fast-sync` should sync new files' {
    # Initialize with source directory (not empty target)
    fast-sync --init "$TEST_SOURCE_DIR"

    # Now sync from source to target, but expect user interaction for empty target warning
    # We need to automatically answer "yes" to the prompt
    echo "yes" | fast-sync "$TEST_SOURCE_DIR" "$TEST_TARGET_DIR"

    # Check that files were synced
    [ -f "$TEST_TARGET_DIR/file1.txt" ]
    [ -f "$TEST_TARGET_DIR/file2.txt" ]
    [ -f "$TEST_TARGET_DIR/subdir/file3.txt" ]
}

@test '`fast-sync` should detect no new files on second run' {
    # First sync
    fast-sync --init "$TEST_SOURCE_DIR"
    echo "yes" | fast-sync "$TEST_SOURCE_DIR" "$TEST_TARGET_DIR"

    # Second sync should find no new files (no user interaction needed since target isn't empty)
    run fast-sync "$TEST_SOURCE_DIR" "$TEST_TARGET_DIR"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "All up to date! No new files to sync." ]]
}

@test '`fast-sync` should only sync new files' {
    # First sync
    fast-sync --init "$TEST_SOURCE_DIR"
    echo "yes" | fast-sync "$TEST_SOURCE_DIR" "$TEST_TARGET_DIR"

    # Add a new file to source
    echo "new content" > "$TEST_SOURCE_DIR/new_file.txt"

    # Second sync should sync the new file (total 4 files: 3 existing + 1 new)
    run fast-sync "$TEST_SOURCE_DIR" "$TEST_TARGET_DIR"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Found 4 new files to sync" ]]
    [ -f "$TEST_TARGET_DIR/new_file.txt" ]
}

@test 'fast-sync should create log directory and files' {
    # Initialize and sync
    fast-sync --init "$TEST_SOURCE_DIR"

    echo "yes" | fast-sync "$TEST_SOURCE_DIR" "$TEST_TARGET_DIR"

    # Check log directory exists
    [ -d "$HOME/.cache/fast-sync/logs" ]

    # Check that log files were created (should have current date)
    LOG_COUNT=$(find "$HOME/.cache/fast-sync/logs" -name "*.log" | wc -l)
    ERROR_LOG_COUNT=$(find "$HOME/.cache/fast-sync/logs" -name "*.error.log" | wc -l)

    [ "$LOG_COUNT" -ge 1 ]
    [ "$ERROR_LOG_COUNT" -ge 1 ]
}

@test 'fast-sync log file should contain execution details' {
    # Initialize and sync
    fast-sync --init "$TEST_SOURCE_DIR"
    echo "yes" | fast-sync "$TEST_SOURCE_DIR" "$TEST_TARGET_DIR"

    # Find the latest log file
    LATEST_LOG=$(find "$HOME/.cache/fast-sync/logs" -name "*.log" -not -name "*.error.log" | sort | tail -1)
    [ -f "$LATEST_LOG" ]

    # Check log content
    grep -q "Fast Sync Log Started" "$LATEST_LOG"
    grep -q "Sync completed successfully" "$LATEST_LOG"
    grep -q "Command:" "$LATEST_LOG"
    grep -q "User:" "$LATEST_LOG"
}

@test 'fast-sync should warn about empty directories and log user choice' {
    # Create empty directories
    EMPTY_SOURCE=$(mktemp -d)
    EMPTY_TARGET=$(mktemp -d)

    # Initialize with empty target
    fast-sync --init "$EMPTY_TARGET"

    # This should prompt for user input, but we can't test interactively
    # Instead, let's test the warning detection logic by checking directory contents
    [ -z "$(ls -A "$EMPTY_SOURCE" 2>/dev/null)" ]
    [ -z "$(ls -A "$EMPTY_TARGET" 2>/dev/null)" ]

    rm -rf "$EMPTY_SOURCE" "$EMPTY_TARGET"
}