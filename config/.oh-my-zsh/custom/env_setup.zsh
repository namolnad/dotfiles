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
