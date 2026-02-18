#!/bin/bash

# Migration script for rm-dust PR-59
# Converts old YYYY-MM-DD-HH directories to YYYY-MM-DD directories
#
# Old format: YYYY-MM-DD-HH/+full+path+filename.HH:MM[.ext]
# New format: YYYY-MM-DD/+full+path+filename.HH:MM[.ext]
#
# The hour portion was redundant since HH is already in each filename's timestamp.
#
# See: https://github.com/aiya000/bash-toys/pull/59
# Documentation: ../doc/bin.md (rm-dust section)

set -euo pipefail

# Get dustbox directory
if [[ -z ${BASH_TOYS_DUSTBOX_DIR:-} ]] ; then
  BASH_TOYS_DUSTBOX_DIR="$HOME/.backup/dustbox"
fi

echo "=== rm-dust Migration Script (YYYY-MM-DD-HH -> YYYY-MM-DD) ==="
echo "Dustbox directory: $BASH_TOYS_DUSTBOX_DIR"
echo

# Check if dustbox exists
if [[ ! -d $BASH_TOYS_DUSTBOX_DIR ]] ; then
  echo "Error: Dustbox directory does not exist: $BASH_TOYS_DUSTBOX_DIR"
  exit 1
fi

# Collect old-format directories (YYYY-MM-DD-HH)
old_dirs=()
while IFS= read -r dir ; do
  [[ -z $dir ]] && continue
  basename_dir=$(basename "$dir")
  if [[ $basename_dir =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}$ ]] ; then
    old_dirs+=("$dir")
  fi
done < <(ls -1d "$BASH_TOYS_DUSTBOX_DIR"/*/ 2>/dev/null || true)

if [[ ${#old_dirs[@]} -eq 0 ]] ; then
  echo "No old-format directories (YYYY-MM-DD-HH) found. Nothing to migrate."
  exit 0
fi

echo "Found ${#old_dirs[@]} old-format directory(ies):"
for dir in "${old_dirs[@]}" ; do
  echo "  $(basename "$dir")"
done
echo

# Confirm migration
read -p "Migrate these to YYYY-MM-DD format? (y/N): " -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
  echo "Migration cancelled."
  exit 0
fi

migrated=0
skipped=0
failed=0

for old_dir in "${old_dirs[@]}" ; do
  old_dir_name=$(basename "$old_dir")
  # Extract YYYY-MM-DD from YYYY-MM-DD-HH
  new_dir_name="${old_dir_name%-??}"
  new_dir="$BASH_TOYS_DUSTBOX_DIR/$new_dir_name"

  echo "--- $old_dir_name -> $new_dir_name ---"

  if [[ ! -d $new_dir ]] ; then
    mkdir -p "$new_dir"
  fi

  # Move each entry from old dir to new dir
  while IFS= read -r entry ; do
    [[ -z $entry ]] && continue
    src="$old_dir/$entry"
    dst="$new_dir/$entry"

    if [[ -e $dst ]] ; then
      echo "  Skip (conflict): $entry"
      (( skipped += 1 ))
      continue
    fi

    if mv "$src" "$dst" ; then
      echo "  Moved: $entry"
      (( migrated += 1 ))
    else
      echo "  Error: Failed to move: $entry"
      (( failed += 1 ))
    fi
  done < <(ls -1 "$old_dir" 2>/dev/null || true)

  # Remove old dir if now empty
  if [[ -z "$(ls -A "$old_dir" 2>/dev/null)" ]] ; then
    rmdir "$old_dir"
    echo "  Removed empty directory: $old_dir_name"
  else
    echo "  Warning: Directory not empty (some entries skipped/failed), leaving: $old_dir_name"
  fi
done

echo
echo "=== Migration Complete ==="
echo "Moved:   $migrated"
echo "Skipped: $skipped (destination already existed)"
if [[ $failed -gt 0 ]] ; then
  echo "Failed:  $failed"
fi

# https://github.com/aiya000/bash-toys
#
# The MIT License (MIT)
#
# Copyright (c) 2025- aiya000
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
