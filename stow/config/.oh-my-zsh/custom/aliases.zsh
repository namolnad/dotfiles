
#   -----------------------------
#   MAKE TERMINAL BETTER
#   -----------------------------

# Delgations to more powerful implementatios
cat() { bat $@; }                           # Delegate cat to bat
alias ls='eza --long --all --group-directories-first --color-scale --icons --octal-permissions --git --header'                 # Delegate ls to eza

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
cd() { builtin cd "$@"; ls; }               # Always list directory contents upon 'cd'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop

alias rand='openssl rand -hex'              # rand:         Random bytes of count (hex string)
cheat() { curl "cht.sh/$1"; }               # cheat:        Get help on a command
alias add-dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'; killall Dock"
alias be='bundle exec'                      # be:           Run bundle exec

#   ---------------------------
#   EDITORS
#   ---------------------------

alias code="open -a \"Visual Studio Code\" $@"
alias e=nvim                                         # Edit in neovim
alias edit=nvim                                      # edit: Opens any file in neovim editor
alias t=tmux                                         # t: Opens tmux in the terminal
alias vim=nvim                                       # vim: Opens vim in the terminal

#   ---------------------------
#   GIT
#   ---------------------------

alias gap="git add -p"
alias gdp="git diff HEAD^ HEAD" # Git diff previous commit
alias gitlog="git log -15 --oneline --reverse"
alias gitstat="git status -sb"
alias gplease="git push origin --force-with-lease"
alias lg="lazygit"

#   ---------------------------
#   NETWORKING
#   ---------------------------

alias myip='curl https://4.ifcfg.me/'               # myip:         Public facing IP Address
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs
port() { lsof -i ":$1"; }                           # port:         Checks what's running on port

kill_port() {
  for PID in $(port $1 | awk '/a/ {print $2 }');
    do kill -9 "$PID";
  done;
}                                                  # kill_port:    Kill all processes running on port

#   ---------------------------
#   HOST RELATED INFO
#   ---------------------------

ii() {
  echo -e "\nYou are logged on ${RED}$HOST"
  echo -e "\nAdditionnal information:$NC " ; uname -a
  echo -e "\n${RED}Users logged on:$NC " ; w -h
  echo -e "\n${RED}Current date :$NC " ; date
  echo -e "\n${RED}Machine stats :$NC " ; uptime
  echo -e "\n${RED}Current network location :$NC " ; scselect
  echo -e "\n${RED}Public facing IP Address :$NC " ;myip
  #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
  echo
}
