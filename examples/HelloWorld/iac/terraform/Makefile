TERRAFORM ?= terraform

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.DEFAULT_GOAL := help

.PHONY: install-deps
install-deps: ## install dependencies
	$(TERRAFORM) init

.PHONY: lint
lint: ## run linter
	$(TERRAFORM) validate

.PHONY: format-check
format-check: ## check code format
	$(TERRAFORM) fmt -check

.PHONY: format
format: ## format codes
	$(TERRAFORM) fmt -recursive

.PHONY: plan
plan:
	$(TERRAFORM) plan

.PHONY: ci-test
ci-test: install-deps lint format-check ## ci test
