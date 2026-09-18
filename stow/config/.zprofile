# Login shells, and it runs *after* /etc/zprofile — which is the whole
# reason the file exists.
#
# macOS's /etc/zprofile calls path_helper, which rebuilds PATH from scratch
# with the system directories first. ~/.zshenv has already put Homebrew in
# front by then, and path_helper undoes it, so /usr/bin/git, /usr/bin/ruby
# and /usr/bin/python3 end up shadowing the brewed ones in any login shell.
# Re-asserting here is the conventional fix, and it has to be here rather
# than in ~/.zshenv because only this file runs late enough.
#
# `typeset -U path` in ~/.zshenv means this moves the existing entry to the
# front rather than adding a duplicate. HOMEBREW_PREFIX is already exported
# there, so this needs no subprocess and no detection of its own.
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH+:$PATH}"
fi
