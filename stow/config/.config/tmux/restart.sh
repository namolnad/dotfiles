#!/bin/bash
# Restart the tmux server: save everything (layout, plus claude session ids via
# tmux-assistant-resurrect), then kill the server and let start.sh bring it back
# and re-attach. nvim saves its own session as it's killed.
# Usage: restart.sh [--clean]   --clean comes back to freshly booted project sessions
export PATH="/opt/homebrew/bin:$PATH"

state_dir="$HOME/.local/state/tmux"

mode=restore
[ "$1" = "--clean" ] && mode=clean

if [ "$mode" = restore ]; then
  save="$(tmux show-option -gqv @resurrect-save-script-path)"
  if [ -z "$save" ] || ! "$save" quiet; then
    tmux display-message "restart.sh: couldn't save, so not restarting"
    exit 1
  fi
fi

mkdir -p "$state_dir"
echo "$mode" > "$state_dir/restart"
tmux kill-server
