#!/bin/bash

# Migration script for rm-dust PR-52
# Converts old format to new format
#
# Old format: filename_YYYY-MM-DD_HH:MM:SS[.ext]
# New format: YYYY-MM-DD-HH/+full+path+filename.HH:MM[.ext]
#
# See: https://github.com/aiya000/bash-toys/pull/52
# Documentation: ../doc/bin.md (rm-dust section)

set -euo pipefail

# Detect search command (prefer fd/fdfind, fallback to find)
if command -v fd &> /dev/null ; then
  FD_CMD="fd"
  USE_FIND=false
elif command -v fdfind &> /dev/null ; then
  FD_CMD="fdfind"
  USE_FIND=false
elif command -v find &> /dev/null ; then
  USE_FIND=true
else
  echo "Error: fd, fdfind, or find command not found."
  exit 1
fi

# Get dustbox directory
if [[ -z ${BASH_TOYS_DUSTBOX_DIR:-} ]] ; then
  BASH_TOYS_DUSTBOX_DIR="$HOME/.backup/dustbox"
fi

# List items in old format (depth 1, absolute paths)
list_old_format_items() {
  local dir="$1"
  if [[ $USE_FIND == true ]] ; then
    find "$dir" -maxdepth 1 -mindepth 1 -name "*_????-??-??_*"
  else
    "$FD_CMD" -d 1 -a ".*_[0-9]{4}-[0-9]{2}-[0-9]{2}_.*" "$dir"
  fi
}

echo "=== rm-dust Migration Script (PR-52) ==="
echo "Dustbox directory: $BASH_TOYS_DUSTBOX_DIR"
echo

# Check if dustbox exists
if [[ ! -d $BASH_TOYS_DUSTBOX_DIR ]] ; then
  echo "Error: Dustbox directory does not exist: $BASH_TOYS_DUSTBOX_DIR"
  exit 1
fi

# Count old format files and directories
old_files=$(list_old_format_items "$BASH_TOYS_DUSTBOX_DIR" | wc -l)

if [[ $old_files -eq 0 ]] ; then
  echo "No old format files or directories found. Nothing to migrate."
  exit 0
fi

echo "Found $old_files file(s) and/or directory(ies) in old format."
echo

# Confirm migration
read -p "Do you want to migrate these files and directories to the new format? (y/N): " -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
  echo "Migration cancelled."
  exit 0
fi

# Process each file
migrated=0
failed=0
temp_file=$(mktemp)

list_old_format_items "$BASH_TOYS_DUSTBOX_DIR" | while IFS= read -r old_path ; do
  filename=$(basename "$old_path")

  # Parse old format: name_YYYY-MM-DD_HH:MM:SS[.ext] (for both files and directories)
  # Extract timestamp: YYYY-MM-DD_HH:MM:SS
  # Support both : and _ as time separators for compatibility
  # Remove trailing / if it's a directory
  filename="${filename%/}"
  if [[ $filename =~ _([0-9]{4}-[0-9]{2}-[0-9]{2})_([0-9]{2})[:_]([0-9]{2})[:_]([0-9]{2})(\..+)?$ ]] ; then
    date_part="${BASH_REMATCH[1]}"      # YYYY-MM-DD
    hour="${BASH_REMATCH[2]}"           # HH
    minute="${BASH_REMATCH[3]}"         # MM
    # second="${BASH_REMATCH[4]}"       # SS (not used in new format)
    ext_part="${BASH_REMATCH[5]}"       # .ext or empty

    # Remove timestamp and extension from filename to get base name
    base_name="${filename%_${date_part}_*}"

    # Create date-hour directory
    date_hour="$date_part-$hour"
    date_hour_dir="$BASH_TOYS_DUSTBOX_DIR/$date_hour"

    if [[ ! -d $date_hour_dir ]] ; then
      mkdir -p "$date_hour_dir"
    fi

    # Build new name: +path+name.HH:MM[.ext] (for both files and directories)
    # Note: Old format may not have full path, so we keep the base as-is
    new_name="${base_name}.${hour}:${minute}${ext_part}"
    new_path="$date_hour_dir/$new_name"

    # Check if destination already exists
    if [[ -e $new_path ]] ; then
      echo "Warning: Destination already exists, skipping: $new_name"
      echo "failed" >> "$temp_file"
      continue
    fi

    # Move file or directory
    if mv "$old_path" "$new_path" ; then
      echo "Migrated: $filename -> $date_hour/$new_name"
      echo "migrated" >> "$temp_file"
    else
      echo "Error: Failed to migrate: $filename"
      echo "failed" >> "$temp_file"
    fi
  else
    echo "Warning: Filename does not match expected pattern, skipping: $filename"
    echo "failed" >> "$temp_file"
  fi
done

# Count results
migrated=0
failed=0
if [[ -f $temp_file ]] ; then
  migrated=$(grep -c "^migrated$" "$temp_file" 2>/dev/null || echo "0")
  failed=$(grep -c "^failed$" "$temp_file" 2>/dev/null || echo "0")
  rm -f "$temp_file"
fi

echo
echo "=== Migration Complete ==="
echo "Migrated: $migrated file(s) and/or directory(ies)"
if [[ $failed -gt 0 ]] 2>/dev/null ; then
  echo "Failed/Skipped: $failed file(s) and/or directory(ies)"
fi
echo
echo "Please verify the migration was successful before deleting any backup files."

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
