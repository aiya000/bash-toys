#!/usr/bin/env bats

# shellcheck disable=SC2016

# ZLE widget behavior requires an interactive zsh session and cannot be tested here.
# _bash_toys_flash_find_next_motion() is pure (no ZLE calls) and is tested below.

setup() {
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

# Helper: source the plugin and call _bash_toys_flash_find_next_motion, then print
# the computed motion.
# Usage: run_next_motion <widget_name> <zle_motion> <native_dir> <counterpart> <last_widget>
# Prints _bash_toys_flash_find_computed_motion.
ZSH_NEXT_MOTION_HELPER='
  source ./sources/zsh-vi-flash-find.sh

  function run_sequence () {
    local args
    args=("$@")
    local i=1
    while (( i <= ${#args[@]} )); do
      local widget="${args[$i]}"  ; (( i++ ))
      local motion="${args[$i]}"  ; (( i++ ))
      local dir="${args[$i]}"     ; (( i++ ))
      local counter="${args[$i]}" ; (( i++ ))
      local last="${args[$i]}"    ; (( i++ ))
      _bash_toys_flash_find_next_motion "$widget" "$motion" "$dir" "$counter" "$last"
    done
    echo "$_bash_toys_flash_find_computed_motion"
  }
'

# ─── help ─────────────────────────────────────────────────────────────────────

@test '`zsh-vi-flash-find-setup --help` should show help message' {
  run zsh -c 'source ./source-all.sh && zsh-vi-flash-find-setup --help'
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^zsh-vi-flash-find - '
}

@test '`zsh-vi-flash-find-setup -h` should show help message' {
  run zsh -c 'source ./source-all.sh && zsh-vi-flash-find-setup -h'
  expects "$status" to_be 0
  expects "${lines[0]}" to_match '^zsh-vi-flash-find - '
}

@test 'sourcing zsh-vi-flash-find.sh in bash should be a no-op' {
  run bash -c 'source ./sources/zsh-vi-flash-find.sh && type zsh-vi-flash-find-setup 2>&1; echo "exit:$?"'
  expects "$output" to_match 'not found|no zsh-vi-flash-find-setup'
}

# ─── first keypress: always a new search ──────────────────────────────────────

@test 'first f: should call vi-find-next-char' {
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" ""
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-find-next-char'
}

@test 'first F: should call vi-find-prev-char' {
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::F" "vi-find-prev-char" "backward" "bash-toys::flash-find::f" ""
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-find-prev-char'
}

@test 'first t: should call vi-find-next-char-skip' {
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::t" "vi-find-next-char-skip" "forward" "bash-toys::flash-find::T" ""
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-find-next-char-skip'
}

@test 'first T: should call vi-find-prev-char-skip' {
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::T" "vi-find-prev-char-skip" "backward" "bash-toys::flash-find::t" ""
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-find-prev-char-skip'
}

# ─── same key repeat (fa → ff → ff) ───────────────────────────────────────────

@test 'ff (second f after f): should vi-repeat-find' {
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "" \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "bash-toys::flash-find::f"
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-repeat-find'
}

@test 'FF (second F after F): should vi-repeat-find' {
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::F" "vi-find-prev-char" "backward" "bash-toys::flash-find::f" "" \
      "bash-toys::flash-find::F" "vi-find-prev-char" "backward" "bash-toys::flash-find::f" "bash-toys::flash-find::F"
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-repeat-find'
}

@test 'tt (second t after t): should vi-repeat-find' {
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::t" "vi-find-next-char-skip" "forward" "bash-toys::flash-find::T" "" \
      "bash-toys::flash-find::t" "vi-find-next-char-skip" "forward" "bash-toys::flash-find::T" "bash-toys::flash-find::t"
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-repeat-find'
}

@test 'TT (second T after T): should vi-repeat-find' {
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::T" "vi-find-prev-char-skip" "backward" "bash-toys::flash-find::t" "" \
      "bash-toys::flash-find::T" "vi-find-prev-char-skip" "backward" "bash-toys::flash-find::t" "bash-toys::flash-find::T"
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-repeat-find'
}

# ─── counterpart key reverse (fa → FF) ────────────────────────────────────────

@test 'fF (F after f): should vi-rev-repeat-find' {
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "" \
      "bash-toys::flash-find::F" "vi-find-prev-char" "backward" "bash-toys::flash-find::f" "bash-toys::flash-find::f"
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-rev-repeat-find'
}

@test 'Ff (f after F): should vi-rev-repeat-find' {
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::F" "vi-find-prev-char" "backward" "bash-toys::flash-find::f" "" \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "bash-toys::flash-find::F"
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-rev-repeat-find'
}

@test 'tT (T after t): should vi-rev-repeat-find' {
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::t" "vi-find-next-char-skip" "forward" "bash-toys::flash-find::T" "" \
      "bash-toys::flash-find::T" "vi-find-prev-char-skip" "backward" "bash-toys::flash-find::t" "bash-toys::flash-find::t"
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-rev-repeat-find'
}

@test 'Tt (t after T): should vi-rev-repeat-find' {
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::T" "vi-find-prev-char-skip" "backward" "bash-toys::flash-find::t" "" \
      "bash-toys::flash-find::t" "vi-find-next-char-skip" "forward" "bash-toys::flash-find::T" "bash-toys::flash-find::T"
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-rev-repeat-find'
}

# ─── multi-step sequences ──────────────────────────────────────────────────────

@test 'faf followed by ff: both should vi-repeat-find' {
  # faf = new search, then f (repeat), then f (repeat again)
  # We test the third f here
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "" \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "bash-toys::flash-find::f" \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "bash-toys::flash-find::f"
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-repeat-find'
}

@test 'faf followed by FF: should vi-rev-repeat-find (fafF bug fix)' {
  # faf = new search + repeat; next F must reverse not forward
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "" \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "bash-toys::flash-find::f" \
      "bash-toys::flash-find::F" "vi-find-prev-char" "backward" "bash-toys::flash-find::f" "bash-toys::flash-find::f"
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-rev-repeat-find'
}

@test 'fafFF: second F should also vi-rev-repeat-find' {
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "" \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "bash-toys::flash-find::f" \
      "bash-toys::flash-find::F" "vi-find-prev-char" "backward" "bash-toys::flash-find::f" "bash-toys::flash-find::f" \
      "bash-toys::flash-find::F" "vi-find-prev-char" "backward" "bash-toys::flash-find::f" "bash-toys::flash-find::F"
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-rev-repeat-find'
}

# ─── non-f/F/t/T key interrupts sequence ──────────────────────────────────────

@test 'f after 0 (non-find widget): should start a new search' {
  # Sequence: fa (new), then 0 pressed (non-ours), then f again
  # last_widget for the second f is '0' (not one of ours) -> new search
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "" \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "digit-or-beginning-of-line"
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-find-next-char'
}

@test 'F after non-find widget: should start a new search' {
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::F" "vi-find-prev-char" "backward" "bash-toys::flash-find::f" "" \
      "bash-toys::flash-find::F" "vi-find-prev-char" "backward" "bash-toys::flash-find::f" "vi-backward-char"
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-find-prev-char'
}

# ─── regression: faf then 0f (0 interrupts sequence) ─────────────────────────
# Bug: in the original implementation _bash_toys_flash_find_last was never cleared
# by non-f/F/t/T widgets, so pressing 0 then f would still call vi-repeat-find.
# Fixed by checking $LASTWIDGET: if the previous widget is not one of ours, reset.

@test 'faf then 0f: f after 0 should start a new search (not repeat)' {
  # Step1: fa  (new search, last_widget='')
  # Step2: f   (repeat,     last_widget='bash-toys::flash-find::f')
  # Step3: f   (0 was pressed between steps, last_widget='vi-digit-or-beginning-of-line') -> new search
  run zsh --no-rcs -c "$ZSH_NEXT_MOTION_HELPER"'
    run_sequence \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "" \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "bash-toys::flash-find::f" \
      "bash-toys::flash-find::f" "vi-find-next-char" "forward" "bash-toys::flash-find::F" "vi-digit-or-beginning-of-line"
  '
  expects "$status" to_be 0
  expects "$output" to_equal 'vi-find-next-char'
}
