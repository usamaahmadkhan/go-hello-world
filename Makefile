VERSION ?= 0.0.1
NAME ?=go-hello-world
IMAGE_TAG_BASE ?= docker.io/usamaahmadkhan/$(NAME)
IMG ?= $(IMAGE_TAG_BASE):v$(VERSION)
SHELL = /usr/bin/env bash -o pipefail

# Run Build
.PHONY: all
all: build

# Run Formatting checks
.PHONY: fmt
fmt:
	go fmt ./...

# Run go vet against code
.PHONY: vet
vet: fmt
	go vet ./...

# Lint
.PHONY: lint
lint:
	golangci-lint run --timeout=10m ./...

# Unit-test
.PHONY: test
test:
	go test ./...

# Run against the configured Kubernetes cluster in ~/.kube/config
.PHONY: run
run: fmt vet
	go run ./main.go

##@ Build
.PHONY: build
build: fmt vet lint
	go build -o bin/manager main.go

# Build the docker image
.PHONY: docker-build
docker-build: test
	docker build . -t ${IMG}

# Push the docker image
.PHONY: docker-push
docker-push:
	docker push ${IMG}

# Generate Helm Chart
.PHONY: generate-chart
generate-chart:
	helm create $(NAME)

# Bump Version
.PHONY: bump-version
bump-version:
	sed -i "s/^VERSION ?=.*/VERSION ?= $(VERSION)/" Makefile
	sed -i "s/^appVersion:.*/appVersion:  $(VERSION)/" charts/$(NAME)/Chart.yaml

# Generate Manifests
.PHONY: manifests
manifests: bump-version
	helm template --release-name $(NAME) charts/$(NAME) / > kubernetes/$(NAME).yaml