#!/bin/bash
# Focus a Safari tab whose URL contains <url-substring> in a window whose title
# starts with <profile-hint>. If no matching tab exists, open the URL in a
# matching profile window when one is available, otherwise in a new Safari window.
#
# Usage: safari-focus-tab.sh <url-substring> <profile-hint>
#   e.g.  safari-focus-tab.sh mail.google.com Camino

URL_SUB="$1"
PROFILE="$2"

if [[ -z "$URL_SUB" || -z "$PROFILE" ]]; then
  echo "Usage: $0 <url-substring> <profile-hint>" >&2
  exit 1
fi

osascript <<EOF
tell application "Safari"
  activate
  set found to false
  repeat with w in windows
    if name of w starts with "$PROFILE" then
      repeat with i from 1 to (count of tabs of w)
        set t to tab i of w
        if URL of t contains "$URL_SUB" then
          set current tab of w to t
          set index of w to 1
          set found to true
          exit repeat
        end if
      end repeat
    end if
    if found then exit repeat
  end repeat
  if not found then
    set targetWindow to missing value
    repeat with w in windows
      if name of w starts with "$PROFILE" then
        set targetWindow to w
        exit repeat
      end if
    end repeat
    if targetWindow is not missing value then
      tell targetWindow to set current tab to (make new tab with properties {URL:"https://$URL_SUB"})
      set index of targetWindow to 1
    else
      open location "https://$URL_SUB"
    end if
  end if
end tell
EOF
