#!/bin/bash
# Tmux session helpers + auto-boot for dotfiles.
#
# Run directly to create the auto-boot sessions (idempotent).
# Source from another script (e.g. project.sh) to use the helpers without auto-booting.

DOTFILES_DIR="$HOME/Developer/dotfiles"

# --- Helpers ---

# Sanitize a directory basename into a valid tmux session name (no dots, lowercase).
session_name_from_dir() {
  basename "$1" | tr '[:upper:]' '[:lower:]' | tr '. ' '__' | tr -cd '[:alnum:]_-'
}

# Create a session for an arbitrary project directory, auto-detecting type.
# Always: nvim, claude, lazygit, shell. Adds: server (if bin/dev), console (if Gemfile).
create_project_session() {
  local dir="$1"
  local name="${2:-$(session_name_from_dir "$dir")}"

  if tmux has-session -t "$name" 2>/dev/null; then
    echo "$name"
    return
  fi

  tmux new-session -d -s "$name" -c "$dir" -n nvim
  tmux send-keys -t "$name:nvim" 'nvim' Enter

  tmux new-window -t "$name" -n claude -c "$dir"
  tmux send-keys -t "$name:claude" 'claude' Enter
  #
  # tmux new-window -t "$name" -n lazygit -c "$dir"
  # tmux send-keys -t "$name:lazygit" 'lazygit' Enter
  #
  # tmux new-window -t "$name" -n shell -c "$dir"

  if [ -x "$dir/bin/dev" ]; then
    tmux new-window -t "$name" -n server -c "$dir"
    tmux send-keys -t "$name:server" 'bin/dev' Enter
  fi

  if [ -f "$dir/Gemfile" ]; then
    tmux new-window -t "$name" -n console -c "$dir"
    tmux send-keys -t "$name:console" 'rails c' Enter
  fi

  tmux select-window -t "$name:nvim"
  echo "$name"
}

# --- Auto-boot ---

main() {
  create_project_session "$DOTFILES_DIR" "dotfiles"
}

# Only run main if executed directly (not when sourced).
if [ "${BASH_SOURCE[0]:-$0}" = "$0" ]; then
  main "$@"
fi
