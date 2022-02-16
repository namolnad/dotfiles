export DEFAULT_USER='danloman'
export CODE_DIR="$HOME/Developer"
export DEV_ENV="$HOME/Developer/Environment"

for f in $(find $DEV_ENV/.custom_credentials -type f); do
  source "$f"
done

# BREW
eval "$(/opt/homebrew/bin/brew shellenv)"

# GO
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

mkdir -p "${GOPATH}"

# 1Password
# eval "$(op signin loman)"

# Github CLI completion
_evalcache gh completion -s zsh
# eval "$(gh completion -s zsh)"

# FASD
_evalcache fasd --init auto
# eval "$(fasd --init auto)"

# RIPGREP
export RIPGREP_CONFIG_PATH="${HOME}/.ripgreprc"

# Fastlane
export FASTLANE_SKIP_UPDATE_CHECK=1
export FASTLANE_USERNAME=daniel.h.loman@gmail.com

# Modify PATH for imagmagick
export PATH="$PATH:/usr/local/opt/imagemagick@6/bin:/usr/local/sbin"

iterm2_print_user_vars() {
  iterm2_set_user_var pwd $(pwd)
}
