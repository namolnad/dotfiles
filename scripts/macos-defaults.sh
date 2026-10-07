# shellcheck shell=bash
# shellcheck disable=SC2154 # dim and reset are the bootstrap's
#
# macOS and app settings for scripts/bootstrap's full run (not --update).
# Sourced by the bootstrap, so it uses its helpers (warn, manual, DRY_RUN,
# STATE_DIR); settings that need root go through `sudo -A`, which gets the
# password from the bootstrap's askpass helper.
#
# Most of this takes full effect after logging out and back in.

DEFAULTS_FAILED=0

# Applies one setting. A failure is counted and reported, and the rest carry on.
setting() {
  if (( DRY_RUN )); then
    printf '    %s$ %s%s\n' "$dim" "$*" "$reset" >&2
    return 0
  fi
  "$@" >/dev/null 2>&1 || {
    DEFAULTS_FAILED=$((DEFAULTS_FAILED + 1))
    warn "didn't apply: $*"
  }
}

# Runs a function only on the first full bootstrap of a machine, for changes
# that throw away state (the Dock's apps) or are slow (reindexing Spotlight).
once() {
  local marker=$STATE_DIR/once-$1
  [[ -e $marker ]] && return 0
  if (( DRY_RUN )); then
    printf '    %s$ %s (first full run only)%s\n' "$dim" "$1" "$reset" >&2
    return 0
  fi
  "$1" && touch "$marker"
}

# PlistBuddy's Set fails on a key that doesn't exist yet, and a new machine's
# Finder plist has none of these, so a missing key is added, parents included.
plist_set() {
  local plist=$1 key=$2 type=$3 value=$4 rest parent=
  if (( DRY_RUN )); then
    printf '    %s$ PlistBuddy %s = %s%s\n' "$dim" "$key" "$value" "$reset" >&2
    return 0
  fi
  /usr/libexec/PlistBuddy -c "Set $key $value" "$plist" >/dev/null 2>&1 && return 0
  rest=${key#:}
  while [[ $rest == *:* ]]; do
    parent=$parent:${rest%%:*}
    rest=${rest#*:}
    /usr/libexec/PlistBuddy -c "Add $parent dict" "$plist" >/dev/null 2>&1
  done
  /usr/libexec/PlistBuddy -c "Add $key $type $value" "$plist" >/dev/null 2>&1 || {
    DEFAULTS_FAILED=$((DEFAULTS_FAILED + 1))
    warn "didn't apply: $key in $plist"
  }
}

wipe_dock() {
  # Only open apps show in the Dock (static-only below), between two spacers
  defaults write com.apple.dock persistent-apps -array &&
    defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="small-spacer-tile";}' &&
    defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="small-spacer-tile";}'
}

rebuild_spotlight_index() {
  # Load the new search categories, then index the main volume from scratch
  killall mds >/dev/null 2>&1
  sudo -A mdutil -i on / >/dev/null && sudo -A mdutil -E / >/dev/null
}

rebuild_launch_services() {
  # Removes duplicates from the "Open With" menu
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
    -r -domain local -domain system -domain user
}

apply_macos_defaults() {
  local finder_plist=$HOME/Library/Preferences/com.apple.finder.plist view
  DEFAULTS_FAILED=0

  # Close System Settings, so it doesn't overwrite what's set here
  (( DRY_RUN )) || osascript -e 'tell application "System Settings" to quit' >/dev/null 2>&1

  # General UI/UX
  setting defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.733333 0.721569"
  setting defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2 # medium sidebar icons
  setting defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
  setting defaults write com.apple.LaunchServices LSQuarantine -bool false # no "Are you sure you want to open" dialog
  once rebuild_launch_services
  setting defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true
  setting defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
  setting defaults write NSGlobalDomain NSDisableAutomaticTermination -bool false
  setting defaults write com.apple.CrashReporter DialogType -string "none"
  setting sudo -A defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName # host info on the login window clock
  setting sudo -A systemsetup -setrestartfreeze on
  setting defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1 # check daily
  setting defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  setting defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  # Sleep, on the charger and on battery (minutes; 0 is never). No
  # hibernation, so entering sleep is quicker.
  setting sudo -A pmset -c sleep 40 displaysleep 10
  setting sudo -A pmset -b sleep 1 displaysleep 0
  setting sudo -A pmset -a hibernatemode 0

  # Trackpad, keyboard and input
  setting defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  setting defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  setting defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  setting defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
  setting defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
  setting defaults write NSGlobalDomain AppleKeyboardUIMode -int 3 # Tab through every control
  setting defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
  setting defaults write NSGlobalDomain KeyRepeat -int 1
  setting defaults write NSGlobalDomain InitialKeyRepeat -int 12
  setting defaults write com.apple.BezelServices kDim -bool true
  setting defaults write com.apple.BezelServices kDimTime -int 300
  setting defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # Screen
  setting mkdir -p "$HOME/Documents/Screenshots"
  setting defaults write com.apple.screencapture location -string "$HOME/Documents/Screenshots"
  setting defaults write com.apple.screencapture type -string "png"
  setting defaults write com.apple.screencapture disable-shadow -bool false
  setting sudo -A defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

  # Finder
  setting defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
  setting defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
  setting defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
  setting defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
  setting defaults write com.apple.finder CreateDesktop -bool false
  setting defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  setting defaults write com.apple.finder ShowPathbar -bool true
  setting defaults write com.apple.finder ShowStatusBar -bool true
  setting defaults write com.apple.finder AppleShowAllFiles -bool true
  setting defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  setting defaults write com.apple.finder QuitMenuItem -bool true
  setting defaults write com.apple.finder DisableAllAnimations -bool true
  setting defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  setting defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" # search the current folder
  setting defaults write NSGlobalDomain com.apple.springing.enabled -bool true
  setting defaults write NSGlobalDomain com.apple.springing.delay -float 0
  setting defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
  setting defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
  setting defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
  for view in DesktopViewSettings FK_StandardViewSettings StandardViewSettings; do
    plist_set "$finder_plist" ":$view:IconViewSettings:showItemInfo" bool true
    plist_set "$finder_plist" ":$view:IconViewSettings:arrangeBy" string grid
    plist_set "$finder_plist" ":$view:IconViewSettings:gridSpacing" real 100
    plist_set "$finder_plist" ":$view:IconViewSettings:iconSize" real 80
  done
  plist_set "$finder_plist" ":DesktopViewSettings:IconViewSettings:labelOnBottom" bool false
  setting defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # list view
  setting defaults write com.apple.finder WarnOnEmptyTrash -bool false
  setting defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
  setting chflags nohidden "$HOME/Library"
  setting sudo -A chflags nohidden /Volumes
  local dropbox_emblem=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
  [[ -e $dropbox_emblem ]] && setting mv -f "$dropbox_emblem" "$dropbox_emblem.bak"
  setting defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true OpenWith -bool true Privileges -bool true

  # Dock and Mission Control
  setting defaults write com.apple.dock mouse-over-hilite-stack -bool true
  setting defaults write com.apple.dock tilesize -int 48
  setting defaults write com.apple.dock largesize -float 128
  setting defaults write com.apple.dock mineffect -string "scale"
  setting defaults write com.apple.dock minimize-to-application -bool true
  setting defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
  setting defaults write com.apple.dock show-process-indicators -bool true
  once wipe_dock
  setting defaults write com.apple.dock static-only -bool true
  setting defaults write com.apple.dock launchanim -bool false
  setting defaults write com.apple.dock expose-animation-duration -float 0.1
  setting defaults write com.apple.dock expose-group-by-app -bool false
  setting defaults write com.apple.spaces spans-displays -bool false
  setting defaults write com.apple.dock mru-spaces -bool false
  setting defaults write com.apple.dock autohide-delay -float 0
  setting defaults write com.apple.dock autohide-time-modifier -float 0
  setting defaults write com.apple.dock autohide -bool true
  setting defaults write com.apple.dock orientation -string "left"
  setting defaults write com.apple.dock showhidden -bool true
  setting defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

  # Safari keeps its settings in its sandbox container, which `defaults` can
  # only write to when this terminal has Full Disk Access
  if (( DRY_RUN )) || defaults write com.apple.Safari UniversalSearchEnabled -bool false 2>/dev/null; then
    setting defaults write com.apple.Safari SuppressSearchSuggestions -bool true
    setting defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
    setting defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true
    setting defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
    setting defaults write com.apple.Safari HomePage -string "about:blank"
    setting defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
    setting defaults write com.apple.Safari ShowFavoritesBar -bool false
    setting defaults write com.apple.Safari ShowSidebarInTopSites -bool false
    setting defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
    setting defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
    setting defaults write com.apple.Safari ProxiesInBookmarksBar "()"
    setting defaults write com.apple.Safari IncludeDevelopMenu -bool true
    setting defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
    setting defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
  else
    manual "Give your terminal Full Disk Access (System Settings → Privacy & Security), then re-run \`make bootstrap\` for the Safari settings"
  fi
  setting defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

  # Spotlight: which result categories to show, in order
  setting defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APPLICATIONS";}' \
    '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
    '{"enabled" = 1;"name" = "DIRECTORIES";}' \
    '{"enabled" = 1;"name" = "PDF";}' \
    '{"enabled" = 1;"name" = "FONTS";}' \
    '{"enabled" = 0;"name" = "DOCUMENTS";}' \
    '{"enabled" = 0;"name" = "MESSAGES";}' \
    '{"enabled" = 0;"name" = "CONTACT";}' \
    '{"enabled" = 0;"name" = "EVENT_TODO";}' \
    '{"enabled" = 0;"name" = "IMAGES";}' \
    '{"enabled" = 0;"name" = "BOOKMARKS";}' \
    '{"enabled" = 0;"name" = "MUSIC";}' \
    '{"enabled" = 0;"name" = "MOVIES";}' \
    '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
    '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
    '{"enabled" = 0;"name" = "SOURCE";}' \
    '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
    '{"enabled" = 0;"name" = "MENU_OTHER";}' \
    '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
    '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
    '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
    '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
  once rebuild_spotlight_index

  # Time Machine: don't offer new disks for backups
  setting defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

  # Activity Monitor
  setting defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
  setting defaults write com.apple.ActivityMonitor IconType -int 5 # CPU usage in the Dock icon
  setting defaults write com.apple.ActivityMonitor ShowCategory -int 100 # all processes
  setting defaults write com.apple.ActivityMonitor SortDirection -int 0
  setting defaults write com.apple.ActivityMonitor DiskGraphType -int 1
  setting defaults write com.apple.ActivityMonitor NetworkGraphType -int 1

  # TextEdit, Disk Utility, QuickTime, App Store, Photos, Messages
  setting defaults write com.apple.TextEdit RichText -int 0
  setting defaults write com.apple.TextEdit PlainTextEncoding -int 4
  setting defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
  setting defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
  setting defaults write com.apple.DiskUtility advanced-image-options -bool true
  setting defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true
  setting defaults write com.apple.appstore WebKitDeveloperExtras -bool true
  setting defaults write com.apple.appstore ShowDebugMenu -bool true
  setting defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
  setting defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false
  setting defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false
  setting defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

  # Rocket
  setting defaults write net.matthewpalmer.Rocket deactivated-apps -array Slack Xcode Terminal iTerm2 WezTerm wezterm-gui # wezterm-gui is WezTerm started from a shell
  setting defaults write net.matthewpalmer.Rocket launch-at-login -bool true
  setting defaults write net.matthewpalmer.Rocket use-fuzzy-search -bool true
  setting defaults write net.matthewpalmer.Rocket use-double-trigger -bool true

  manual "Log out and back in so every macOS setting takes effect"
  (( DEFAULTS_FAILED == 0 ))
}
