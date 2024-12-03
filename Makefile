.PHONY: all bootstrap

all: bootstrap

bootstrap: ## Setup machine, dependencies and dev environment
	@scripts/bootstrap

