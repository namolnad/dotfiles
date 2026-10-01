#!/bin/bash
# Runs window-hints.swift (Vimium-style letters over AeroSpace windows; see
# that file), compiling it on first use and whenever the source is newer than
# the build. aerospace.toml binds this to alt-w and alt-shift-w.
#
# Usage: window-hints.sh focus|swap [--dry-run]

src="${BASH_SOURCE[0]%/*}/window-hints.swift"
bin=~/.cache/window-hints/window-hints

if [[ ! -x $bin || $src -nt $bin ]]; then
  mkdir -p "${bin%/*}" && /usr/bin/swiftc -O -o "$bin" "$src" || exit 1
fi
exec "$bin" "$@"
