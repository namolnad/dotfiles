# Default User
export DEFAULT_USER='danloman'

# Display Ids
export INSTACART_LAPTOP='69733248'
export INSTACART_THUNDERBOLT_DISPLAY='69508137'
export HOME_IMAC='69678529'

for f in $(find $HOME/.custom_credentials -type f); do
  source $f
done
