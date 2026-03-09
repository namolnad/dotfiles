#!/bin/bash
# AeroSpace startup script — launches apps into context workspaces
# Called via after-startup-command in aerospace.toml

sleep 1  # Wait for AeroSpace to fully initialize

# --- Terminals (one per context) ---

# Personal (P-T) — already the active workspace on startup
wezterm start --cwd "$HOME/Developer" &
sleep 2

# Work (W-T)
aerospace workspace W-T
sleep 0.5
wezterm start --cwd "$HOME/Developer/camino-app" &
sleep 2

# Loman Group (L-T)
aerospace workspace L-T
sleep 0.5
wezterm start --cwd "$HOME/Developer/shopify-app-suite" &
sleep 2

# DML Foundation (D-T)
aerospace workspace D-T
sleep 0.5
wezterm start --cwd "$HOME/Developer/davelomandotcom" &
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

# Return to personal context
sleep 1
aerospace workspace P-T
aerospace mode main
