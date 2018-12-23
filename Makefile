setup:
	@cd ~ $@
	@echo "\nSetting up keyboard repeat rate:"
	defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
	defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
	@echo "\nInstalling bundler:"
	gem install bundler --conservative
	@echo "\nInstalling default utilities:"
	bundle exec bundle install
	bundle exec brew bundle
	@echo "\nTasks remaining:\n1) Download and install iTerm 2, VSCode, Xcode, Alfred 3, Dropbox, Gitup, 1Password, BetterSnapTool\n2) Ensure Dropbox syncing is set up\n3) Point development application settings to \"$$HOME/Dropbox/.dev_sync\"\n"

# Need to add better snap tool settings to syncing; instructions about xVim
