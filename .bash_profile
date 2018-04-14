source /dev/stdin < <(cat $ZSH/custom/instacart.zsh $ZSH/custom/theme.zsh)


# #   ---------------------------
# #   COLORS
# #   ---------------------------

# # A more colorful prompt
# c_reset='\[\e[0m\]'                                     # \[\e[0m\] resets the color to default color
# c_path='\[\e[0;31m\]'                                   #  \e[0;31m\ sets the color to red
# c_git_clean='\[\e[0;32m\]'                              # \e[0;32m\ sets the color to green
# c_git_dirty='\[\e[0;31m\]'                              # \e[0;31m\ sets the color to red
# black='\e[0;30m'
# darkgray='\e[1;30m'
# red='\e[0;31m'
# light_red='\e[1;31m'
# green='\e[0;32m'
# light_green='\e[1;32m'
# brown='\e[0;33m'
# yellow='\e[1;33m'
# blue='\e[0;34m'
# light_blue='\e[1;34m'
# purple='\e[0;35m'
# light_purple='\e[1;35m'
# cyan='\e[0;36m'
# light_cyan='\e[1;36m'
# light_gray='\e[0;37m'
# white='\e[1;37m'

# # Colors ls should use for folders, files, symlinks etc, see `man ls` and
# export LSCOLORS=ExGxFxdxCxDxDxaccxaeex                  # search for LSCOLORS
# alias ls='ls -Gh'                                       # Force ls to use colors (G) and use humanized file sizes (h)

# export GREP_OPTIONS='--color=always'                    # Force grep to always use the color option and show line numbers

# #   -----------------------------
# #   STARTUP
# #   -----------------------------

# echo -e "Is this thing on?

# ${light_blue}
# ---------------------------
#           VALUES
# ---------------------------
# ${light_cyan}
# * Solve for the customer *
# ${light_purple}
# * This is your baby
# * Every minute counts
# * Of course, but maybe
# * Go far, together

# "

# eval "$(rbenv init -)"
# export GITHUB_USERNAME='namolnad'

# export USER_FIRST_NAME='Dan'

# #   -----------------------------
# #   1c.  PROMPT
# #   -----------------------------

# # PS1 is the variable for the prompt you see everytime you hit enter
# PROMPT_COMMAND='PS1="${c_path}\W${c_reset}$(git_prompt) :> "'
# export PS1='\n\[\033[0;31m\]\W\[\033[0m\]$(git_prompt)\[\033[0m\]:> '

# #   -----------------------------
# #   2.  MAKE TERMINAL BETTER
# #   -----------------------------

# alias cp='cp -iv'                           # Preferred 'cp' implementation
# alias mv='mv -iv'                           # Preferred 'mv' implementation
# alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
# alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
# alias less='less -FSRXc'                    # Preferred 'less' implementation
# cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
# alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
# alias ..='cd ../'                           # Go back 1 directory level
# alias ...='cd ../../'                       # Go back 2 directory levels
# alias .3='cd ../../../'                     # Go back 3 directory levels
# alias .4='cd ../../../../'                  # Go back 4 directory levels
# alias .5='cd ../../../../../'               # Go back 5 directory levels
# alias .6='cd ../../../../../../'            # Go back 6 directory levels
# alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
# alias ~="cd ~"                              # ~:            Go Home
# alias c='clear'                             # c:            Clear terminal display
# alias which='type -all'                     # which:        Find executables
# alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
# alias show_options='shopt'                  # Show_options: display bash options settings
# alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
# alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
# mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
# trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
# ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
# alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop

# #   ---------------------------
# #   6.  NETWORKING
# #   ---------------------------

# alias myip='curl https://4.ifcfg.me/'               # myip:         Public facing IP Address
# alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
# alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
# alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
# alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
# alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
# alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
# alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
# alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
# alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs


# #   ---------------------------
# #   7. XCODE
# #   ---------------------------

# alias xcodeclean="rm -frd ~/Library/Developer/Xcode/DerivedData/* && rm -frd ~/Library/Caches/com.apple.dt.Xcode/*"

# #   ---------------------------
# #   8. ii :  display useful host related informaton
# #   ---------------------------

# ii() {
#   echo -e "\nYou are logged on ${RED}$HOST"
#   echo -e "\nAdditionnal information:$NC " ; uname -a
#   echo -e "\n${RED}Users logged on:$NC " ; w -h
#   echo -e "\n${RED}Current date :$NC " ; date
#   echo -e "\n${RED}Machine stats :$NC " ; uptime
#   echo -e "\n${RED}Current network location :$NC " ; scselect
#   echo -e "\n${RED}Public facing IP Address :$NC " ;myip
#   #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
#   echo
# }

# #   ---------------------------
# #   9. GIT
# #   ---------------------------

# alias gitcleanautocomplete="git fetch --prune --all"
# alias gitlog="git log -15 --oneline --reverse"
# alias mergetool="git mergetool -t opendiff"
# alias gitstat="git status -sb"

# # determines if the git branch you are on is clean or dirty
# git_prompt () {
#   if ! git rev-parse --git-dir > /dev/null 2>&1; then
#     return 0
#   fi
#   # Grab working branch name
#   git_branch=$(Git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
#   # Clean or dirty branch
#   if git diff --quiet 2>/dev/null >&2; then
#     git_color="${c_git_clean}"
#   else
#     git_color=${c_git_dirty}
#   fi
#   echo " [$git_color$git_branch${c_reset}]"
# }
# export PATH=/usr/local/sbin/:$PATH
# export PATH="/usr/local/sbin:$PATH"

# #   ---------------------------
# #   10. AUTOCOMPLETE
# #   ---------------------------

# ## Enable brew autocompletion
# if [ -f $(brew --prefix)/etc/bash_completion ]; then
# . $(brew --prefix)/etc/bash_completion
# fi

# #   ---------------------------
# #   11. SUBLIME
# #   ---------------------------

# alias e=sublime                                         # Edit sublime
# alias edit='sublime'                                    # edit: Opens any file in sublime editor
# alias subl='sublime'                                    # Open sublime with subl
# export EDITOR="subl --wait"                             # Set sublime as the default editor

# #   ---------------------------
# #   12. INSTACART
# #   ---------------------------

# alias ishopper="cd ~/code/instashopper-ios;pwd"
# alias ashopper="cd ~/code/instashopper-android;pwd"
# alias iconsumer="cd ~/code/instacart-ios;pwd"
# alias instacart="cd ~/code/carrot/customers/instacart;pwd"
# alias railss="cd ~/code/carrot/customers/instacart;pwd;myip;echo foreman run rails s -b 0.0.0.0;foreman run rails s -b 0.0.0.0"
# alias shoppers="cd ~/code/carrot/shoppers/shopper-api;pwd;myip;echo bundle exec rails server -b 0.0.0.0 -p 5000;bundle exec rails server -b 0.0.0.0 -p 5000"
# alias railsc="cd ~/code/carrot/customers/instacart;pwd;echo foreman run rails console;foreman run rails console"
# alias railsm="cd ~/code/carrot/migrations;pwd;echo bundle exec rake db:migrate;bundle exec rake db:migrate"
# alias endiveconsole="isc console console.endive"
# alias endivestaging="isc console consumer-web-endive.staging"
# alias romainestaging="isc console consumer-web-romaine.staging"
# alias clipscript="cat ~/code/dans-scripts/isc-scripts.rb | pbcopy"
# alias localsync="instacart;pgsync zones,warehouse_zones,regions,warehouses,delivery_hours,applicant_variants,applicant_experiments,postal_codes;pgsync users \"where email='dan.loman@instacart.com'\""

# eval "$(rbenv init -)"





# if [[ $EUID -ne 0 ]]; then
# 	export PS1="\[\e[1;32m\][\t : \w]\$ "
# else
# 	export PS1="\[\e[1;31m\][\t : \w]\$ "
# fi


# #### ALIASES #####

# ## Git log oneline in reverse order
# alias gitlog="git log -25 --oneline --reverse"

# ## Edit with sublime
# alias e=sublime