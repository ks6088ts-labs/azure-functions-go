SOURCE_FILES ?= $(shell find . -type d \( -name dist -o -name generated \) -prune -o -type f -name '*.go' -print)

GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)
GOPATH ?= $(shell go env GOPATH)
GOBUILD ?= GOOS=$(GOOS) GOARCH=$(GOARCH) CGO_ENABLED=0 go build
GOLANGCI_LINT_VERSION ?= 1.50.0
LDFLAGS ?= '-s -w'

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.DEFAULT_GOAL := help

.PHONY: install-deps-dev
install-deps-dev: ## install dependencies for development
	@# https://golangci-lint.run/usage/install/#linux-and-windows
	@which golangci-lint || curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(GOPATH)/bin v$(GOLANGCI_LINT_VERSION)

.PHONY: format
format: ## format codes
	gofmt -s -w $(SOURCE_FILES)

.PHONY: lint
lint: ## lint
	golangci-lint run -v

.PHONY: test
test: ## run tests
	go test -cover -v ./...

.PHONY: build
build: ## build applications
	$(GOBUILD) -ldflags=$(LDFLAGS) -o ./dist/handler .

.PHONY: ci-test
ci-test: install-deps-dev lint test build ## ci test
