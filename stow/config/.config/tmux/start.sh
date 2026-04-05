#!/bin/bash
# Wrapper for wezterm default_prog: ensure sessions exist, then attach
export PATH="/opt/homebrew/bin:$PATH"

~/.config/tmux/sessions.sh
exec tmux attach -t camino
