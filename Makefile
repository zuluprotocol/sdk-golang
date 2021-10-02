# Makefile

SHELL := /usr/bin/env bash
GENERATED_DIRS := data-node github.com vega

.PHONY: default
default:
	@echo "Please select a target:"
	@echo "- preproto:    Copy *.proto from vega core repository."
	@echo "- proto:       Run buf to auto-generate API clients and gRPC documentation."

.PHONY: buf-build
buf-build: buf-lint
	@buf build

.PHONY: buf-generate
buf-generate: buf-build
	@if ! command -v protoc-gen-go 1>/dev/null ; then \
		go get github.com/golang/protobuf/protoc-gen-go@v1.4.3 || exit 1 ; \
	fi
	@if ! command -v protoc-gen-go-grpc 1>/dev/null ; then \
		go get google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1.0 || exit 1 ; \
	fi
	@if ! command -v protoc-gen-govalidators 1>/dev/null ; then \
		go get github.com/mwitkow/go-proto-validators/protoc-gen-govalidators@v0.3.2 || exit 1 ; \
	fi
	@rm -rf $(GENERATED_DIRS)
	@buf generate

.PHONY: buf-lint
buf-lint:
	@buf lint

.PHONY: clean
clean:
	@rm -rf $(GENERATED_DIRS)

.PHONY: coverage
coverage:
	@go test -cover ./...

.PHONY: gosec
gosec:
	@gosec ./...

.PHONY: lint
lint:
	@outputfile="$$(mktemp)" ; \
	golint ./... 2>&1 | tee "$$outputfile" ; \
	lines="$$(wc -l <"$$outputfile")" ; \
	rm -f "$$outputfile" ; \
	exit "$$lines"

.PHONY: preproto
preproto:
	@if test -z "$(VEGAPROTOS)" ; then echo "Please set VEGAPROTOS" ; exit 1 ; fi
	@rm -rf sources && cp -a "$(VEGAPROTOS)/sources" ./
	@rm -rf third_party && cp -a "$(VEGAPROTOS)/third_party" ./
	@sed -i -re 's#^option go_package = "validator";#option go_package = "github.com/mwitkow/go-proto-validators;validator";#' third_party/proto/github.com/mwitkow/go-proto-validators/validator.proto
	@find sources third_party -name '*.proto' -print0 \
		| xargs -0 sed --in-place -r \
			-e 's#[ \t]+$$##' \
			-e 's#option go_package = "code.vegaprotocol.io/protos/#option go_package = "code.vegaprotocol.io/sdk-golang/#'
	@(cd "$(VEGAPROTOS)" && git describe --tags) >sources/from.txt

.PHONY: proto
proto: buf-generate
	@./post-generate.sh

.PHONY: retest
retest:
	@go test -count=1 ./...

.PHONY: test
test:
	@go test ./...

.PHONY: vet
vet:
	@go vet ./...
