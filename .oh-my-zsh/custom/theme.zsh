# Updates editor information when the keymap changes.

function zle-keymap-select zle-line-init {
    # change cursor shape in iTerm2
    case $KEYMAP in
        vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
        viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
    esac

    zle reset-prompt
    zle -R
}

# function zle-line-init {
#   zle -K vicmd
# }

function zle-line-finish {
    print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# function zsh_vi_mode() {
#     case $KEYMAP in
#         (viins|main) echo -n "INSERT";;
#         (vicmd|*)      echo -n "-- NORMAL --";;
#     esac
# }

#   ---------------------------
#   ZSH THEME
#   ---------------------------

## ## POWERLEVEL9K SETTINGS ##
POWERLEVEL9K_BATTERY_CHARGING='yellow'
POWERLEVEL9K_BATTERY_CHARGED='green'
POWERLEVEL9K_BATTERY_DISCONNECTED='$DEFAULT_COLOR'
POWERLEVEL9K_BATTERY_LOW_THRESHOLD='10'
POWERLEVEL9K_BATTERY_LOW_COLOR='red'
POWERLEVEL9K_BATTERY_ICON='\uf1e6 '
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX='\uf0da'

POWERLEVEL9K_VCS_GIT_ICON='\uF1D3'
POWERLEVEL9K_VCS_GIT_GITHUB_ICON='\uF113'
POWERLEVEL9K_CUSTOM_INTERNET_SIGNAL="zsh_internet_signal"

POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'

POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND='dodgerblue3'
POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND='dodgerblue2'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(battery context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vi_mode time  rbenv)

POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_DIR_HOME_BACKGROUND="31"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="31"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="31"

POWERLEVEL9K_TIME_FORMAT="%D{\uf073 %d.%m.%y}"

POWERLEVEL9K_STATUS_VERBOSE=false

POWERLEVEL9K_PROMPT_ON_NEWLINE=false
