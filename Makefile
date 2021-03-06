COMMIT = $$(git describe --tags --always)
# date format of goreleaser
DATE = $$(date --utc '+%Y-%m-%d_%H:%M:%S')
PKG = github.com/yuuki/binrep
PKGS = $$(go list ./... | grep -v vendor)
CREDITS = vendor/CREDITS

all: build

.PHONY: build
build: deps
	go build -ldflags "-X main.commit=\"$(COMMIT)\" -X main.date=\"$(DATE)\"" $(PKG)

.PHONY: test
test: vet
	go test -v ./...

.PHONY: vet
vet:
	go vet ./...

.PHONY: lint
lint: devel-deps
	golint -set_exit_status $(PKGS)

cover: devel-deps
	goveralls -service=travis-ci

.PHONY: deps
deps:
	go get github.com/jteeuwen/go-bindata/...

.PHONY: devel-deps
devel-deps: deps
	go get github.com/golang/lint/golint
	go get golang.org/x/tools/cmd/cover
	go get github.com/mattn/goveralls
	go get github.com/motemen/gobump
	go get github.com/Songmu/ghch

.PHONY: credits
credits:
	scripts/credits > $(CREDITS)
ifneq (,$(git status -s $(CREDITS)))
	go generate -x .
endif

.PHONY: release
release: credits
	scripts/release
