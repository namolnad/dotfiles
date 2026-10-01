#!/bin/bash
# Wrapper for wezterm default_prog: attach to tmux, starting the server if needed.
#
# A fresh server comes back from the last tmux-resurrect save: sessions, windows,
# nvim, lazygit, and claude (via tmux-assistant-resurrect). With --clean, or with
# nothing saved, it auto-boots the project sessions from sessions.sh instead.
#
# restart.sh leaves a marker before it kills the server, and a client that exits
# because of that loops around to bring the server back up and re-attach.
export PATH="/opt/homebrew/bin:$PATH"

# Keep in sync with @resurrect-dir in tmux.conf
resurrect_dir="$HOME/.local/share/tmux/resurrect"
state_dir="$HOME/.local/state/tmux"
restart_marker="$state_dir/restart"
boot_lock="$state_dir/boot.lock"

mode=restore
[ "$1" = "--clean" ] && mode=clean

# restart.sh killed the server within the last minute
restart_pending() {
  [ -n "$(find "$restart_marker" -mmin -1 2>/dev/null)" ]
}

# Start the server unless it's up, then attach. Only one client boots it; any
# others queue on the lock and then attach to what it brought up.
start_and_attach() {
  local restore session
  mkdir -p "$state_dir"
  for _ in $(seq 75); do shlock -f "$boot_lock" -p $$ && break; sleep 0.2; done

  if tmux has-session 2>/dev/null; then
    rm -f "$boot_lock"
    # A restore under way swaps its placeholder session 0 for the saved ones
    for _ in $(seq 50); do tmux has-session -t =0 2>/dev/null || break; sleep 0.2; done
    tmux attach
    return
  fi

  if restart_pending; then
    mode="$(cat "$restart_marker")"
    rm -f "$restart_marker"
  fi

  if [ "$mode" = restore ] && grep -qs '^pane' "$resurrect_dir/last"; then
    # Every plugin has loaded once this returns (tpm runs without -b)
    tmux new-session -d -s 0 -c "$HOME"
    restore="$(tmux show-option -gqv @resurrect-restore-script-path)"
    rm -f "$boot_lock"
    # Restore once attached, so resurrect can switch this client to the session
    # that was active and drop session 0. Claude panes resume in the background.
    tmux new-session -A -s 0 -c "$HOME" \; \
      run-shell -b "${restore:-$HOME/.config/tmux/plugins/tmux-resurrect/scripts/restore.sh}"
  else
    # sessions.sh echoes the name of the session it created/found.
    session="$(~/.config/tmux/sessions.sh 2>/dev/null | tail -n1)"
    rm -f "$boot_lock"
    # -A: attach if it exists, create it otherwise. Never fails to give a shell.
    tmux new-session -A -s "${session:-dotfiles}" -c "$HOME/Developer/dotfiles"
  fi
}

while :; do
  start_and_attach
  rc=$?
  restart_pending || break
done
exit "$rc"
