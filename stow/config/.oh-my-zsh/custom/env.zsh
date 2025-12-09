#   ---------------------------
#   ENVIRONMENT VARIABLES
#   ---------------------------

export DEFAULT_USER='danloman'
export CODE_DIR="$HOME/Developer"
export DOTFILES="$HOME/Developer/Environment"
export XDG_CONFIG_HOME="${HOME}/.config"

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

export PATH="$HOME/.local/bin:$PATH/usr/local/opt"

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
# eval "$(op signin)"

#   ---------------------------
#   Github CLI completion
#   ---------------------------
_evalcache gh completion -s zsh

#   ---------------------------
#   RBENV
#   ---------------------------
# export RBENV_ROOT="${XDG_CONFIG_HOME}/rbenv"

#   ---------------------------
#   RIPGREP
#   ---------------------------
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"

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
  export EDITOR='vim'
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

#   ---------------------------
#   ENVCRYPT
#   ---------------------------
dotenvcrypt_key_path="$XDG_CONFIG_HOME/dotenvcrypt/secret.key"
if [[ ! -f $dotenvcrypt_key_path || ! -s $dotenvcrypt_key_path ]]; then
  mkdir -p $(dirname $dotenvcrypt_key_path)
  (op item get xdsp7qgsyfo3lgrtcp7npriky4 --reveal --fields password) > $dotenvcrypt_key_path
fi
# Check if dotenvcrypt is installed and source its output
if command -v dotenvcrypt &> /dev/null; then
  set -a
  eval "$(dotenvcrypt decrypt $HOME/.env.enc)"
  set +a
fi
