PROJECT_DIR ?= $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
DOCKER_PLATFORM:= $(shell echo $(DOCKER_PLATFORM))
DOCKERFILE:= $(shell echo $(DOCKERFILE))
SHORT_SHA:= $(shell echo $(SHORT_SHA))
CI:= $(shell echo $(CI))

.PHONY: help
help: Makefile
	@sed -n 's/^\(## \)\([a-zA-Z]\)/\2/p' $<

.PHONY: build-base-images
build-base-images:
	DOCKER_PLATFORM=$(DOCKER_PLATFORM) DOCKERFILE=$(DOCKERFILE) SHORT_SHA=$(SHORT_SHA) CI=$(CI) $(PROJECT_DIR)/.github/scripts/build-base-images.sh
