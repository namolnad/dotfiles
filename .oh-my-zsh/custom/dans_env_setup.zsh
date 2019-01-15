# Default User
export DEFAULT_USER='danloman'

# Display Ids
export INSTACART_LAPTOP='69733248'
export INSTACART_THUNDERBOLT_DISPLAY='69508137'
export HOME_IMAC='69678529'

for f in $(find $HOME/.custom_credentials -type f); do
  source $f
done

# Modify PATH
export PATH="$PATH:/usr/local/opt/imagemagick@6/bin:/usr/local/sbin"

# fzf setup
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f -d 15'
# export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
# export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*'"
export FZF_COMMAND_T="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPS='--extended'
