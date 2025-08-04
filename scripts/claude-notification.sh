#!/bin/bash

# Claude Code notification script
# Smart notification: sound if not muted, alert if muted and not in Claude window

# Get current working directory
PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename "$PROJECT_DIR")

# Get timestamp
TIMESTAMP=$(date '+%H:%M:%S')

# Check if system is muted (macOS)
MUTED=$(osascript -e "output muted of (get volume settings)")

# Check if Claude Code is the active application (check if we're in a terminal with claude running)
ACTIVE_APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')
CLAUDE_RUNNING=$(ps aux | grep -c "claude" | grep -v grep)

# Determine if we're likely in a Claude Code session
IN_CLAUDE_WINDOW=false
if [[ "$ACTIVE_APP" == "WezTerm" || "$ACTIVE_APP" == "wezterm-gui" || "$ACTIVE_APP" == "Terminal" || "$ACTIVE_APP" == "iTerm2" ]]; then
    if [[ $CLAUDE_RUNNING -gt 1 ]]; then
        IN_CLAUDE_WINDOW=true
    fi
fi

if [ "$MUTED" = "false" ]; then
    # System not muted - just play sound
    afplay /System/Library/Sounds/Ping.aiff
elif [ "$IN_CLAUDE_WINDOW" = "false" ]; then
    # System muted AND not in Claude window - show dialog
    MESSAGE="Project: $PROJECT_NAME
Directory: $PROJECT_DIR
Time: $TIMESTAMP

Claude Code needs your attention."
    
    osascript -e "tell application \"System Events\" to display dialog \"$MESSAGE\" buttons {\"OK\"} default button 1 with title \"Claude Code Alert\""
fi

# If muted AND in Claude window, do nothing (user is already looking at Claude)