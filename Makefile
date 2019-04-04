.PHONY: all setup

BUNDLE_INSTALL=bundle install --path vendor/bundle

all: setup custom_credentials keyboard_speed dependencies utilities manual_task_instructions

setup: ## Setup machine, dependencies and dev environment
	@cd ~ $@
	@$(MAKE) custom_credentials
	@$(MAKE) keyboard_speed
	@$(MAKE) dependencies
	@$(MAKE) utilities
	@$(MAKE) manual_task_instructions

custom_credentials: ## Setup custom credentials directory
	@echo "\nCreate custom_credentials directory (if not exists)"
	@mkdir -p ~/.custom_credentials $@

keyboard_speed: ## Adjust keyboard repeat rate
	@echo "\nSetting up keyboard repeat rate:"
	defaults write -g InitialKeyRepeat -int 13 # normal minimum is 15 (225 ms)
	defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

dependencies: ## Install required dependencies
	@echo "\nInstalling bundler:"
	gem install bundler --conservative
	command -v brew > /dev/null 2>&1 || echo "Installing homebrew\n"; /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

utilities: ## Install default utilities
	@echo "\nInstalling default utilities:"
ifdef VERBOSE
	$(BUNDLE_INSTALL) --verbose
	bundle exec brew bundle --verbose
else
	$(BUNDLE_INSTALL)
	bundle exec brew bundle
endif

manual_task_instructions: ## Echo manual tasks remaining
	@echo "\nTasks remaining:\n1) Ensure Dropbox syncing is set up\n2) Point development application settings to \"$$HOME/Dropbox/.dev_sync\"\n3) Install xVim and resign XCode\n  3a) clone xvim2 - git clone https://github.com/XVimProject/XVim2.git\n  3b) generate signing cert (https://github.com/XVimProject/XVim2/blob/master/SIGNING_Xcode.md)\n  3c) sudo codesign -f -s 'CERT_IDENTIFIER' /Applications/Xcode.app\n  3d) 'cd' into XVim2 dir and run 'make'\n4) Run \"$$(brew --prefix)/opt/fzf/install\""
