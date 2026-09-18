# Runs for EVERY zsh — login, interactive, and, the case this file exists
# for, neither.
#
# `ssh host 'some command'` gets a shell that is neither interactive nor a
# login shell, so it reads this file and nothing else: not ~/.zshrc, not
# ~/.zprofile. Anything a remote script needs on PATH has to be set here, or
# it is simply not there — and the failure is quiet. A setup script run that
# way reported "ollama: NOT INSTALLED" about a machine with Ollama installed
# and running, because /opt/homebrew/bin was missing from a PATH nobody had
# thought about.
#
# This file must stay cheap, and that rules out the obvious spelling. Every
# zsh a script spawns pays for it: `eval "$(brew shellenv)"` costs ~14ms
# because it runs brew, a bash script, as a subprocess — enough to take zsh
# startup from 4ms to 16ms, four times over, in a loop, on every host. The
# exports below are exactly what `brew shellenv` emits, written out, and the
# prefix is the only thing that ever changes between machines.
#
# **No aliases, functions or completions here. Ever.** They belong in
# ~/.oh-my-zsh/custom/aliases.zsh, behind the `$CLAUDECODE` guard where the
# ones that misbehave already live.
#
# Being in ~/.zshrc is not by itself what keeps an alias away from an agent:
# Claude Code snapshots the interactive aliases and functions and sources
# them into its own non-interactive shell deliberately, which is why that
# guard had to exist at all. But this file is read by *every* zsh with no
# snapshotting involved, so anything put here reaches every script, every
# ssh command and every tool on every machine, with no guard in front of it
# and no way to opt out.
#
# The line to hold: PATH is a fact about the machine and belongs everywhere.
# An alias is a convenience for a person at a keyboard and belongs only
# where there is one.

# Keep PATH free of duplicates. zsh keeps the *first* occurrence of a
# repeated entry, which is what lets ~/.zprofile put Homebrew back at the
# front rather than appending a second copy.
typeset -U path PATH fpath

# Apple Silicon first, then Intel, so one file serves both machines.
for _brew_prefix in /opt/homebrew /usr/local; do
  if [[ -x $_brew_prefix/bin/brew ]]; then
    export HOMEBREW_PREFIX="$_brew_prefix"
    export HOMEBREW_CELLAR="$_brew_prefix/Cellar"
    export HOMEBREW_REPOSITORY="$_brew_prefix"
    export PATH="$_brew_prefix/bin:$_brew_prefix/sbin${PATH+:$PATH}"
    export INFOPATH="$_brew_prefix/share/info:${INFOPATH:-}"
    fpath[1,0]="$_brew_prefix/share/zsh/site-functions"
    break
  fi
done
unset _brew_prefix

# If any of the above ever drifts from what Homebrew actually wants, the
# authoritative version is `brew shellenv` — diff against it rather than
# guessing.
