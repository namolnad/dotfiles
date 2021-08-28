# If you come from bash you might have to change your $PATH.

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# For profiling slow start up times https://blog.mattclemente.com/2020/06/26/oh-my-zsh-slow-to-load.html#how-to-test-your-shell-load-time
# zmodload zsh/zprof

ZSH_THEME="powerlevel9k/powerlevel9k"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions vi-mode zsh-syntax-highlighting evalcache)

source $ZSH/oh-my-zsh.sh

# rbenv
# eval "$(rbenv init -)"
_evalcache rbenv init -

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Aliases can be found in ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="e ~/.zshrc"
alias ohmyzsh="e ~/.oh-my-zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

### BEGIN--Instacart Shell Settings. (Updated: Fri Jan 31 12:01:37 PST 2020. [Script Version 1.1.4])
# This Line Added Automatically by Instacart Setup Script
# The sourced file contains all of the instacart utilities and shell settings
# To remove this functionality, leave the block, and enter "NO-TOUCH" in the BEGIN line, and comment the line below:
source /Users/danloman/.instacart_shell_profile
### END--Instacart Shell Settings.
