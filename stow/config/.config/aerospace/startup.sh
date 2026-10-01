#!/bin/bash
# AeroSpace startup script — launches the terminal only.
# Apps launch on demand; on-window-detected rules route them to workspaces.
# tmux isn't started here: the terminal's start.sh brings it up, restoring the
# last save, and a server started first would leave it nothing to restore.

sleep 1  # Wait for AeroSpace to fully initialize

# One WezTerm, attached to tmux, in workspace T. Opened as the app rather than
# with `wezterm start`, so it's the same instance macOS reopens at login and
# Karabiner opens, instead of a second one beside it.
aerospace workspace T
open -a WezTerm
