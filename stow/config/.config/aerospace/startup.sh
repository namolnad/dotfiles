#!/bin/bash
# AeroSpace startup script — launches terminal + tmux only.
# Apps launch on demand; on-window-detected rules route them to workspaces.

sleep 1  # Wait for AeroSpace to fully initialize

# Create all tmux sessions
~/.config/tmux/sessions.sh

# Launch single wezterm attached to tmux into workspace T
aerospace workspace T
wezterm start &
