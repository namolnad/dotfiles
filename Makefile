.PHONY: all bootstrap update

all: bootstrap

bootstrap: ## Set up this Mac: packages, dotfiles, plugins, macOS settings and login items
	@scripts/bootstrap

update: ## Bring packages, plugins and dotfiles up to date (no macOS settings)
	@scripts/bootstrap --update
