#!/bin/bash
# Tmux session creation script — idempotent, safe to re-run
# Called from aerospace startup.sh or manually

CAMINO_DIR="$HOME/Developer/camino-app"
SHOPIFY_DIR="$HOME/Developer/shopify-app-suite"
DML_DIR="$HOME/Developer/davelomandotcom"
FYLGJA_DIR="$HOME/Developer/fylgja"
RUNE_DIR="$HOME/Developer/rune"
ALPIN_DIR="$HOME/Developer/alpin"
DOTFILES_DIR="$HOME/Developer/dotfiles"
LIFEOS_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents/LifeOS"

# --- Helper functions ---

create_rails_session() {
  local name="$1"
  local dir="$2"
  local server_cmd="${3:-bin/dev}"
  local ngrok_cmd="$4"  # optional

  if tmux has-session -t "$name" 2>/dev/null; then return; fi

  tmux new-session -d -s "$name" -c "$dir" -n nvim
  tmux send-keys -t "$name:nvim" 'nvim' Enter

  tmux new-window -t "$name" -n shell -c "$dir"

  tmux new-window -t "$name" -n server -c "$dir"
  tmux send-keys -t "$name:server" "$server_cmd" Enter

  # Console window: dev (top) + prod (bottom)
  tmux new-window -t "$name" -n console -c "$dir"
  tmux send-keys -t "$name:console" 'rails c' Enter
  tmux split-window -v -t "$name:console" -c "$dir"
  tmux send-keys -t "$name:console.2" 'bin/kamal console' Enter
  tmux select-pane -t "$name:console.1"

  # Ngrok window (optional)
  if [ -n "$ngrok_cmd" ]; then
    tmux new-window -t "$name" -n ngrok -c "$dir"
    tmux send-keys -t "$name:ngrok" "$ngrok_cmd" Enter
  fi

  tmux new-window -t "$name" -n claude -c "$dir"
  tmux send-keys -t "$name:claude" 'claude' Enter

  tmux select-window -t "$name:nvim"
}

create_simple_session() {
  local name="$1"
  local dir="$2"

  if tmux has-session -t "$name" 2>/dev/null; then return; fi

  tmux new-session -d -s "$name" -c "$dir" -n nvim
  tmux send-keys -t "$name:nvim" 'nvim' Enter

  tmux new-window -t "$name" -n shell -c "$dir"

  tmux new-window -t "$name" -n claude -c "$dir"
  tmux send-keys -t "$name:claude" 'claude' Enter

  tmux select-window -t "$name:nvim"
}

# --- Rails projects ---

create_rails_session "camino" "$CAMINO_DIR" \
  "HOST=https://lomangroup.ngrok.app bin/dev" \
  "ngrok http --domain=lomangroup.ngrok.app 3000"

create_rails_session "shopify" "$SHOPIFY_DIR"

create_rails_session "dml" "$DML_DIR"

# --- Simple projects ---

create_simple_session "fylgja" "$FYLGJA_DIR"
create_simple_session "rune" "$RUNE_DIR"
create_simple_session "alpin" "$ALPIN_DIR"
create_simple_session "dotfiles" "$DOTFILES_DIR"

# --- LifeOS (claude-first, no nvim) ---

if ! tmux has-session -t lifeos 2>/dev/null; then
  tmux new-session -d -s lifeos -c "$LIFEOS_DIR" -n claude
  tmux send-keys -t lifeos:claude 'claude' Enter

  tmux new-window -t lifeos -n shell -c "$LIFEOS_DIR"

  tmux select-window -t lifeos:claude
fi
