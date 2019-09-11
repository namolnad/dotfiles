# Default User
export DEFAULT_USER='danloman'

for f in $(find $HOME/.custom_credentials -type f); do
  source "$f"
done

# Modify PATH
export PATH="$PATH:/usr/local/opt/imagemagick@6/bin:/usr/local/sbin"

