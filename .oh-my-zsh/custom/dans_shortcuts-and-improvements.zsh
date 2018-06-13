#   ---------------------------
#   XCODE
#   ---------------------------

alias xcode_clean="rm -rf ~/Library/Developer/Xcode/DerivedData/* && rm -rf ~/Library/Caches/com.apple.dt.Xcode/*"

#   ---------------------------
#   GIT
#   ---------------------------

function git() { hub $@; }
alias gap="git add -p"
alias gdp="git diff HEAD^ HEAD" # Git diff previous commit
alias gfpa="git fetch --prune --all"
alias gitlog="git log -15 --oneline --reverse"
alias gitstat="git status -sb"
alias gplease="git push origin --force-with-lease"
alias gpr-ios='git pull-request -F ~/Code/Instacart-ios/.github/PULL_REQUEST_TEMPLATE -o -e -c -p'
alias gpr-list='g pr list -f "%sC%>(8)%i%Creset  %t% l -----% au  %n"'
alias grbo="git rebase-origin" # Git rebase origin, -fp flag pushes to origin w/ flag --force-with-lease
alias mergetool="git mergetool -t opendiff"


cherry-pick-latest() {
  gco master
  ggpull
  g rev-parse head | pbcopy
  gco "releases/$1" && ggpull && gcp $(pbpaste)
}

recent-branches() {
  git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:short) %(authorname) %(refname:short)' | head -n 10
}

#   ---------------------------
#   EDITORS
#   ---------------------------

alias e=code                                         # Edit in VSCode
alias edit='code'                                    # edit: Opens any file in VSCode editor
alias subl='sublime'                                    # Open sublime with subl

export EDITOR='code'
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='code'
else
  export EDITOR='vim'
fi

#   ---------------------------
#   DAN's
#   ---------------------------

export PATH="/usr/local/sbin:$PATH"

alias lg=". ~/code/dans-scripts/daily_work_log.sh"

standup() {
  ( . /usr/bin/cd ~/code; git standup "$@"; )
}

start_pianobar() {
  echo 'Do you want to start pianobar? [y/N]'
  read x;
  if [ "$x" = 'y' ]; then
    pianobar;
  fi;
}

alias kill_pianobar="pgrep pianobar | xargs kill -15"

#   ---------------------------
#   KEY BINDINGS
#   ---------------------------

if [ "$0" != "bash" ]; then
  bindkey '^ ' forward-word
  bindkey '^[[[CE' end-of-line
fi


#   ---------------------------
#   ORGANIZATION
#   ---------------------------

alias add-dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'; killall Dock"
