PROJECT_DIR ?= $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
DOCKER_PLATFORM:= $(shell echo $(DOCKER_PLATFORM))

.PHONY: help
help: Makefile
	@sed -n 's/^\(## \)\([a-zA-Z]\)/\2/p' $<

.PHONY: build-base-images
build-base-images:
	@ export DOCKER_PLATFORM=$(DOCKER_PLATFORM) && $(PROJECT_DIR)/.github/scripts/build-base-images.sh