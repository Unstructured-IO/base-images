PROJECT_DIR ?= $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

.PHONY: help
help: Makefile
	@sed -n 's/^\(## \)\([a-zA-Z]\)/\2/p' $<

.PHONY: build-base-images
build-base-images:
	@ $(PROJECT_DIR)/.github/scripts/build-base-images.sh
