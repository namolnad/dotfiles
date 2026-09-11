#!/bin/bash
# Wrapper for wezterm default_prog: ensure sessions exist, then attach.
export PATH="/opt/homebrew/bin:$PATH"

# sessions.sh echoes the name of the session it created/found.
session="$(~/.config/tmux/sessions.sh 2>/dev/null | tail -n1)"
[ -n "$session" ] || session="dotfiles"

# -A: attach if it exists, create it otherwise. Never fails to give a shell.
exec tmux new-session -A -s "$session" -c "$HOME/Developer/dotfiles"
