#!/bin/bash
# AeroSpace startup script — launches apps into context workspaces
# Called via after-startup-command in aerospace.toml

sleep 1  # Wait for AeroSpace to fully initialize

# --- Terminal (single instance with tmux) ---

# Create all tmux sessions
~/.config/tmux/sessions.sh

# Launch single wezterm attached to tmux
aerospace workspace T
wezterm start -- tmux attach -t camino &
sleep 2

# --- Gmail web apps (auto-assigned via on-window-detected) ---
open -a "Gmail - Personal" 2>/dev/null
open -a "Gmail - Camino" 2>/dev/null
# Uncomment when created:
# open -a "Gmail - Loman Group" 2>/dev/null
# open -a "Gmail - DML" 2>/dev/null

sleep 1

# --- Calendar web apps (auto-assigned via on-window-detected) ---
open -a "Calendar - Personal" 2>/dev/null
open -a "Calendar - Camino" 2>/dev/null
# Uncomment when created:
# open -a "Calendar - Loman Group" 2>/dev/null
# open -a "Calendar - DML" 2>/dev/null

sleep 1

# --- Global apps ---
open -a "Slack" 2>/dev/null
open -a "Music" 2>/dev/null
open -a "Reminders" 2>/dev/null

# Return to terminal
sleep 1
aerospace workspace T
aerospace mode main
