#!/bin/bash

# Claude Code notification script
# Smart notification: sound if not muted, alert if muted and not in Claude window

# Get current working directory
PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename "$PROJECT_DIR")

# Get timestamp
TIMESTAMP=$(date '+%H:%M:%S')

# Get terminal tab information
TAB_INFO="Unknown"
WORKSPACE_INFO=""

if command -v wezterm &> /dev/null; then
    # Get the active pane info from WezTerm
    ACTIVE_PANE=$(wezterm cli list --format json 2>/dev/null | jq --arg cwd "$PROJECT_DIR" '[.[] | select(.cwd == $cwd)] | .[0] // ([.[] | select(.is_active == true)] | .[0])')

    if [ -n "$ACTIVE_PANE" ] && [ "$ACTIVE_PANE" != "null" ]; then
        WINDOW_ID=$(echo "$ACTIVE_PANE" | jq -r '.window_id')
        TAB_ID=$(echo "$ACTIVE_PANE" | jq -r '.tab_id')
        WORKSPACE=$(echo "$ACTIVE_PANE" | jq -r '.workspace')
        TAB_TITLE=$(echo "$ACTIVE_PANE" | jq -r '.tab_title // .title')

        # Calculate tab number (index within the window)
        TAB_NUMBER=$(wezterm cli list --format json 2>/dev/null | jq --arg win "$WINDOW_ID" --arg tab "$TAB_ID" '[.[] | select(.window_id == ($win | tonumber))] | unique_by(.tab_id) | sort_by(.tab_id) | to_entries | .[] | select(.value.tab_id == ($tab | tonumber)) | .key + 1')

        # Build tab info string
        TAB_INFO="Tab $TAB_NUMBER"
        if [ -n "$TAB_TITLE" ] && [ "$TAB_TITLE" != "null" ] && [ "$TAB_TITLE" != "" ]; then
            TAB_INFO="$TAB_INFO ($TAB_TITLE)"
        fi

        # Add workspace if available
        if [ -n "$WORKSPACE" ] && [ "$WORKSPACE" != "null" ] && [ "$WORKSPACE" != "" ]; then
            WORKSPACE_INFO="Workspace: $WORKSPACE"
        fi
    fi
fi

# Fallback to trying to get terminal tab name via AppleScript
if [ "$TAB_INFO" = "Unknown" ] || [ -z "$TAB_INFO" ]; then
    TAB_INFO=$(osascript -e 'tell application "System Events"
        set frontApp to name of first application process whose frontmost is true
        if frontApp is "WezTerm" or frontApp is "wezterm-gui" then
            tell process frontApp to get name of front window
        else if frontApp is "iTerm2" then
            tell application "iTerm" to get name of current session of current window
        else if frontApp is "Terminal" then
            tell application "Terminal" to get name of front window
        end if
    end tell' 2>/dev/null)

    if [ -z "$TAB_INFO" ] || [ "$TAB_INFO" = "null" ]; then
        TAB_INFO="Current Tab"
    fi
fi

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
    MESSAGE="$TAB_INFO"
    if [ -n "$WORKSPACE_INFO" ]; then
        MESSAGE="$MESSAGE
$WORKSPACE_INFO"
    fi
    MESSAGE="$MESSAGE
Project: $PROJECT_NAME
Directory: $PROJECT_DIR
Time: $TIMESTAMP

Claude Code needs your attention."

    osascript -e "tell application \"System Events\" to display dialog \"$MESSAGE\" buttons {\"OK\"} default button 1 with title \"Claude Code Alert\""
fi

# If muted AND in Claude window, do nothing (user is already looking at Claude)