VERSION ?= 0.0.1
IMAGE_TAG_BASE ?= docker.io/usamaahmadkhan/go-hello-world
IMG ?= $(IMAGE_TAG_BASE):v$(VERSION)
SHELL = /usr/bin/env bash -o pipefail

.PHONY: all
all: build


.PHONY: fmt
fmt:
	go fmt ./...

# Run go vet against code
.PHONY: vet
vet:
	go vet ./...

# Lint
.PHONY: lint
lint:
	golangci-lint run --timeout=10m ./...

# Unit-test
.PHONY: test
test: fmt lint
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

.PHONY: bump-chart-operator
bump-chart-operator:
	sed -i "s/^VERSION ?=.*/VERSION ?= $(VERSION)/" Makefile
	sed -i "s/newTag:.*/newTag: v$(VERSION)/" config/manager/kustomization.yaml
	sed -i "s/^version:.*/version:  $(VERSION)/" charts/tenant-operator/Chart.yaml
	sed -i "s/^appVersion:.*/appVersion:  $(VERSION)/" charts/tenant-operator/Chart.yaml
	sed -i "s/tag:.*/tag:  v$(VERSION)/" charts/tenant-operator/values.yaml