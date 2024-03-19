
source /dev/stdin < <(
  for config_file in ~/.oh-my-zsh/custom/*.zsh; do
    if [[ ! "$config_file" =~ "theme.zsh" ]] && [[ ! "$config_file" =~ "autocompletion-config.zsh" ]]; then
      cat $config_file
    fi
  done
)

# #   -----------------------------
# #   PROMPT
# #   -----------------------------

# # PS1 is the variable for the prompt you see everytime you hit enter
PROMPT_COMMAND='PS1="${c_path}\w${c_reset}$(git_prompt) :> "'

# #   ---------------------------
# #   GIT
# #   ---------------------------

# # determines if the git branch you are on is clean or dirty
git_prompt () {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  # Grab working branch name
  git_branch=$(Git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
  # Clean or dirty branch
  if git diff --quiet 2>/dev/null >&2; then
    git_color="${c_git_clean}"
  else
    git_color=${c_git_dirty}
  fi
  echo " [$git_color$git_branch${c_reset}]"
}

#   ---------------------------
#   10. AUTOCOMPLETE
#   ---------------------------

## Enable brew autocompletion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export vim="nvim"
