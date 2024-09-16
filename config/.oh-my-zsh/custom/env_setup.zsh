export DEFAULT_USER='danloman'
export CODE_DIR="$HOME/Developer"
export DOTFILES="$HOME/Developer/Environment"

#   ---------------------------
#   KEY BINDINGS
#   ---------------------------

if [ "$0" != "bash" ]; then
  bindkey '^ ' forward-word
  bindkey '^[[[CE' end-of-line
fi

# Updates editor information when the keymap changes.
function zle-keymap-select zle-line-init {
    # change cursor shape in iTerm2
    case $KEYMAP in
        vicmd) print -n -- "\E]50;CursorShape=0\C-G";; # block cursor
        viins|main) print -n -- "\E]50;CursorShape=1\C-G";; # line cursor
    esac

    zle reset-prompt
    zle -R
}

function zle-line-finish {
    print -n -- "\E]50;CursorShape=0\C-G" # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

#   ---------------------------
#   PATH
#   ---------------------------

export PATH="$PATH:/usr/local/opt"

#   ---------------------------
#   BREW
#   ---------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

#   ---------------------------
#   GO
#   ---------------------------
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

mkdir -p "${GOPATH}"


#   ---------------------------
#   1Password
#   ---------------------------
# eval "$(op signin loman)"

#   ---------------------------
#   Github CLI completion
#   ---------------------------
_evalcache gh completion -s zsh


#   ---------------------------
#   RIPGREP
#   ---------------------------
export RIPGREP_CONFIG_PATH="${HOME}/.ripgreprc"

iterm2_print_user_vars() {
  iterm2_set_user_var pwd $(pwd)
}

#   ---------------------------
#   ZSH
#   ---------------------------

setopt nocorrectall; setopt correct

#   ---------------------------
#   EDITORS
#   ---------------------------

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='code'
else
  export EDITOR='nvim'
fi
# This seems to be required to make `v` delegate to nvim
export vim='nvim'

#   ---------------------------
#   FZF SETUP
#   ---------------------------

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --hidden --depth 5 --ignore .git --nocolor -g ""'
export FZF_DEFAULT_OPS='--extended'

#   ---------------------------
#   YAZI
#   ---------------------------

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

