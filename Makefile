PROJECT_DIR ?= $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
DOCKER_PLATFORM:= $(shell echo $(DOCKER_PLATFORM))
DOCKERFILE:= $(shell echo $(DOCKERFILE))
SHORT_SHA:= $(shell echo $(SHORT_SHA))
CI:= $(shell echo $(CI))

.PHONY: help
help: Makefile
	@sed -n 's/^\(## \)\([a-zA-Z]\)/\2/p' $<

## build-base-images:		build all the base images defined in this repo
.PHONY: build-base-images
build-base-images:
	DOCKER_PLATFORM=$(DOCKER_PLATFORM) DOCKERFILE=$(DOCKERFILE) SHORT_SHA=$(SHORT_SHA) CI=$(CI) $(PROJECT_DIR)/scripts/build-base-images.sh

## tidy-shell:			run the shell syntax linter to fix issues in-place
.PHONY: tidy-shell
tidy-shell:
	shfmt -i 2 -l -w .

## check-shell:			run the shell syntax linter, raising an error if any diff found
.PHONY: check-shell
check-shell:
	shfmt -i 2 -d .
