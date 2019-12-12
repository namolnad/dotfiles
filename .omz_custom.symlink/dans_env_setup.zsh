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
eval "$(jira --completion-script-zsh)"

# FASD
eval "$(fasd --init auto)"
alias v='f -e vim' # quick opening files with vim

# Modify PATH for imagmagick
export PATH="$PATH:/usr/local/opt/imagemagick@6/bin:/usr/local/sbin"

iterm2_print_user_vars() {
  iterm2_set_user_var pwd $(pwd)
}
