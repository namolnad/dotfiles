#!/bin/bash
# Create (or jump to) a tmux session for a project directory.
# Usage: project.sh [dir]   (defaults to $PWD)

set -e
export PATH="/opt/homebrew/bin:$PATH"

dir="${1:-$PWD}"

if [ ! -d "$dir" ]; then
  echo "project.sh: not a directory: $dir" >&2
  exit 1
fi

# Resolve to absolute path so basename-derived names are stable.
dir="$(cd "$dir" && pwd)"

# shellcheck source=sessions.sh
source "$(dirname "$0")/sessions.sh"

name="$(create_project_session "$dir")"

if [ -n "$TMUX" ]; then
  tmux switch-client -t "$name"
else
  tmux attach -t "$name"
fi
