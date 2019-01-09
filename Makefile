.PHONY: all setup

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
	@echo "\n Pulling/cloning emacs Evil"
	git -C ~/.emacs.d/evil pull || git clone https://github.com/emacs-evil/evil ~/.emacs.d/evil

utilities: ## Install default utilities
	@echo "\nInstalling default utilities:"
ifdef VERBOSE
	bundle install --verbose
	bundle exec brew bundle --verbose
else
	bundle install
	bundle exec brew bundle
endif

manual_task_instructions: ## Echo manual tasks remaining
	@echo "\nTasks remaining:\n1) Download and install Dropbox\n2) Ensure Dropbox syncing is set up\n3) Point development application settings to \"$$HOME/Dropbox/.dev_sync\"\n4) Install xVim and resign XCode\n    4a) clone xvim2 - git clone https://github.com/XVimProject/XVim2.git\n    4b) generate signing cert (https://github.com/XVimProject/XVim2/blob/master/SIGNING_Xcode.md)\n    4c) sudo codesign -f -s 'Mac Developer: Daniel Loman (39ERR85875)' /Applications/Xcode.app\n    4d) `cd` into XVim2 dir and run `make`"
