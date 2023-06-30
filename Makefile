PROJECT_DIR ?= $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
DOCKER_PLATFORM:= $(shell echo $(DOCKER_PLATFORM))
DOCKERFILE:= $(shell echo $(DOCKERFILE))
CI:= $(shell echo $(CI))

.PHONY: help
help: Makefile
	@sed -n 's/^\(## \)\([a-zA-Z]\)/\2/p' $<

.PHONY: build-base-images
build-base-images:
	DOCKER_PLATFORM=$(DOCKER_PLATFORM) DOCKERFILE=$(DOCKERFILE) CI=$(CI) $(PROJECT_DIR)/.github/scripts/build-base-images.sh
