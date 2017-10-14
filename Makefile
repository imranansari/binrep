COMMIT = $$(git describe --always)
PKG = github.com/yuuki/sbrepo
PKGS = $$(go list ./... | grep -v vendor)

all: build

.PHONY: build
build:
	go build -ldflags "-X main.GitCommit=\"$(COMMIT)\"" $(PKG)

.PHONY: test
test: vet
	go test -v $(PKGS)

.PHONY: vet
vet:
	go vet $(PKGS)