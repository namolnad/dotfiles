#!/bin/bash

# Remove trailing whitespace from file after Claude Code edits
# Usage: remove-trailing-whitespace.sh <file_path>

FILE_PATH="$1"

if [ -z "$FILE_PATH" ]; then
    echo "Usage: $0 <file_path>"
    exit 1
fi

if [ ! -f "$FILE_PATH" ]; then
    echo "File not found: $FILE_PATH"
    exit 1
fi

# Remove trailing whitespace from all lines using sed
# -i '' for in-place editing on macOS
# This removes trailing whitespace from every line in the file
sed -i '' 's/[[:space:]]*$//' "$FILE_PATH"

echo "Removed trailing whitespace from: $FILE_PATH"