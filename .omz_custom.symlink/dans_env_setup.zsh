# Default User
export DEFAULT_USER='danloman'

for f in $(find $HOME/.custom_credentials -type f); do
  source "$f"
done

# GO
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

mkdir -p "${GOPATH}"

# JIRA
_evalcache jira --completion-script-zsh
# eval "$(jira --completion-script-zsh)"

# 1Password
# eval "$(op signin loman)"

# Github CLI completion
_evalcache gh completion -s zsh
# eval "$(gh completion -s zsh)"

# FASD
_evalcache fasd --init auto
# eval "$(fasd --init auto)"

alias v='f -e vim' # quick opening files with vim

# RIPGREP
export RIPGREP_CONFIG_PATH="${HOME}/.ripgreprc"

# Fastlane
FASTLANE_SKIP_UPDATE_CHECK=1
FASTLANE_USERNAME=daniel.h.loman@gmail.com

# Modify PATH for imagmagick
export PATH="$PATH:/usr/local/opt/imagemagick@6/bin:/usr/local/sbin"

iterm2_print_user_vars() {
  iterm2_set_user_var pwd $(pwd)
}
