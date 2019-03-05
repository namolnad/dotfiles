#   ---------------------------
#   ZSH
#   ---------------------------

setopt nocorrectall; setopt correct


#   ---------------------------
#   XCODE
#   ---------------------------

alias xcode_clean="rm -rf ~/Library/Developer/Xcode/DerivedData/* && rm -rf ~/Library/Caches/com.apple.dt.Xcode/*"

#   ---------------------------
#   GIT
#   ---------------------------

alias gap="git add -p"
alias gdp="git diff HEAD^ HEAD" # Git diff previous commit
alias gitlog="git log -15 --oneline --reverse"
alias gitstat="git status -sb"
alias gplease="git push origin --force-with-lease"
alias gpr-ios='git pull-request -F ~/Code/Instacart-ios/.github/PULL_REQUEST_TEMPLATE -o -e -c -p'
alias gpr-list='g pr list -f "%sC%>(8)%i%Creset  %t% l -----% au  %n"'
alias grbo="git rebase-origin" # Git rebase origin, -fp flag pushes to origin w/ flag --force-with-lease
alias mergetool="git mergetool -t opendiff"
alias gcmp='git compare-commits'
alias gcmpf='git compare-files'

format-version-diff() {
  DiffFormatter $@ --project-dir="$HOME/Code/Instacart-ios" --release-manager=$(git config --get user.email)
}

cherry-pick-latest() {
  gco master
  ggpull
  g rev-parse head | pbcopy
  gco "releases/$1" && ggpull && gcp $(pbpaste)
}

recent-branches() {
  git recent-branches
}

#   ---------------------------
#   EDITORS
#   ---------------------------

alias e=code                                         # Edit in VSCode
alias edit='code'                                    # edit: Opens any file in VSCode editor

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='code'
else
  export EDITOR='vim'
fi

#   ---------------------------
#   RAILS
#   ---------------------------

routes_for_controller() {
  bundle exec rake routes | grep -i $1
}

#   ---------------------------
#   DAN's
#   ---------------------------

alias lg=". ~/code/dans-scripts/daily_work_log.sh"

standup() {
  ( . /usr/bin/cd ~/Code; git standup -d 7 "$@"; )
}

stand-up() {
  CODE_DIR="$HOME/Code"

  PROJECT_DIRS=( $(builtin cd $CODE_DIR; find -L . -maxdepth 2 -mindepth 0 -name .git) )
  for DIR in ${PROJECT_DIRS}; do
    if [[ ! -d ".git" || -f ".git" ]] ; then
      continue
    fi

    echo "$(builtin cd "$CODE_DIR/$(echo $DIR | awk -F'.git' '{print $1}')"; pwd; echo "$(git stand-up)")"
  done
}

start_pianobar() {
  echo 'Do you want to start pianobar? [y/N]'
  read x;
  if [ "$x" = 'y' ]; then
    pianobar;
  fi;
}

alias kill_pianobar="pgrep pianobar | xargs kill -15"

simulator_screen_recording() {
  xcrun simctl io booted recordVideo "$1.mov"
}

function cheat() {
      curl cht.sh/$1
}

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

#   ---------------------------
#   NETWORK
#   ---------------------------

port() {
  lsof -i ":$1"
}

kill_port() {
  for PID in $(port $1 | awk '/a/ {print $2 }');
    do kill -9 "$PID";
  done;
}

