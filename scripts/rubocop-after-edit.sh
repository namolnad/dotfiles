#!/bin/bash

# Run RuboCop on a Ruby file after Claude Code edits it
# Usage: rubocop-after-edit.sh <file_path>
#
# Applies safe autocorrections, then reports what's left to Claude. A PostToolUse
# hook that exits 2 has its stderr shown to Claude; any other exit is shown only
# to the user, so remaining offenses go to stderr with exit 2.
#
# Only runs in projects whose Gemfile.lock includes rubocop, through bundle exec,
# so each project's own RuboCop version and config apply.
#
# bundle exec evaluates the project's Gemfile and RuboCop loads the plugins its
# .rubocop.yml names, so this runs the repo's own Ruby without a permission
# prompt. It only runs where origin is a GitHub repo under a trusted owner;
# a cloned third-party repo, or one with no remote, is skipped.

TRUSTED_OWNERS="namolnad joincamino"

FILE_PATH="$1"

[ -f "$FILE_PATH" ] || exit 0

case "$FILE_PATH" in
    *.rb|*.rake|*.gemspec|*.ru|*/Rakefile|*/Gemfile) ;;
    *) exit 0 ;;
esac

# The nearest Gemfile.lock above the file marks the project root
DIR=$(cd "$(dirname "$FILE_PATH")" && pwd)
while [ "$DIR" != "/" ] && [ ! -f "$DIR/Gemfile.lock" ]; do
    DIR=$(dirname "$DIR")
done
[ -f "$DIR/Gemfile.lock" ] || exit 0
grep -q '^    rubocop ' "$DIR/Gemfile.lock" || exit 0

# Owner from git@github.com:owner/repo, ssh://git@github.com/owner/repo or
# https://github.com/owner/repo
ORIGIN=$(git -C "$DIR" remote get-url origin 2>/dev/null)
OWNER=$(printf '%s\n' "$ORIGIN" | sed -nE 's#^(git@github\.com:|ssh://git@github\.com/|https://github\.com/)([^/]+)/.*#\2#p')
case " $TRUSTED_OWNERS " in
    *" $OWNER "*) [ -n "$OWNER" ] || exit 0 ;;
    *) exit 0 ;;
esac

cd "$DIR" || exit 0

# --force-exclusion so files the project's config excludes (db/schema.rb, ...)
# are skipped even though they're passed by name
OUTPUT=$(bundle exec rubocop --autocorrect --force-exclusion --format simple "$FILE_PATH" 2>&1)
STATUS=$?

# 0: clean, or everything was corrected. 1: offenses remain. Anything else is
# RuboCop itself failing (bad config, missing gem), which shouldn't block Claude.
case $STATUS in
    0) exit 0 ;;
    1) echo "RuboCop offenses remain in $FILE_PATH after autocorrect:" >&2
       echo "$OUTPUT" >&2
       exit 2 ;;
    *) echo "RuboCop couldn't run on $FILE_PATH (exit $STATUS):"
       echo "$OUTPUT"
       exit 0 ;;
esac
