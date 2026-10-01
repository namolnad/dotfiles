#!/bin/bash
# tmux-resurrect hook, run before it restores pane processes. A claude that never
# got a message has no transcript, so `claude --resume` would only print "No
# conversation found". Take those out of tmux-assistant-resurrect's list and start
# a fresh claude in their panes instead.
export PATH="/opt/homebrew/bin:$PATH"

dir="$(tmux show-option -gqv @resurrect-dir)"
dir="${dir/#\~/$HOME}"
dir="${dir:-$HOME/.local/share/tmux/resurrect}"
sidecar="$dir/assistant-sessions.json"
projects="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects"
[ -f "$sidecar" ] || exit 0

unused=()
while IFS=$'\t' read -r sid cwd session window pane; do
  # Look in every project: a session resumes by id wherever it started
  [ -n "$(find "$projects" -mindepth 2 -maxdepth 2 -name "$sid.jsonl" -size +0 2>/dev/null)" ] && continue
  unused+=("$sid")

  pane_id="" command=""
  while IFS=$'\t' read -r s w p id cmd; do
    [ "$s" = "$session" ] && [ "$w" = "$window" ] && [ "$p" = "$pane" ] && pane_id="$id" command="$cmd"
  done < <(tmux list-panes -a -F '#{session_name}	#{window_index}	#{pane_index}	#{pane_id}	#{pane_current_command}')

  # Only ever type into a shell
  case "$command" in
  zsh | bash | sh | fish)
    tmux send-keys -t "$pane_id" "cd $(printf %q "$cwd") && claude" Enter
    echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] fresh-claude.sh: $session:$window.$pane never got a message ($sid), starting a fresh claude" >>"$dir/assistant-restore.log"
    ;;
  esac
done < <(jq -r '.sessions[] | select(.tool == "claude") | [.session_id, .cwd, .session_name, .window_index, .pane_index] | @tsv' "$sidecar")

[ ${#unused[@]} -gt 0 ] || exit 0
(umask 077 && jq --args '.sessions |= map(select(.session_id | IN($ARGS.positional[]) | not))' "${unused[@]}" <"$sidecar" >"$sidecar.tmp") &&
  mv "$sidecar.tmp" "$sidecar"
