PROJECT_DIR ?= $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
DOCKER_PLATFORM:= $(shell echo $(DOCKER_PLATFORM))
BASE_IMAGE_NAME:= $(shell echo $(BASE_IMAGE_NAME))
ARCH:= $(shell echo $(ARCH))
DOCKERFILE:= $(shell echo $(DOCKERFILE))
CI:= $(shell echo $(CI))

.PHONY: help
help: Makefile
	@sed -n 's/^\(## \)\([a-zA-Z]\)/\2/p' $<

.PHONY: build-base-images
build-base-images:
	DOCKER_PLATFORM=$(DOCKER_PLATFORM) DOCKERFILE=$(DOCKERFILE) CI=$(CI) $(PROJECT_DIR)/.github/scripts/build-base-images.sh

.PHONY: create-packages
create-packages: build-openjpeg build-pandoc build-boost build-poppler build-leptonica build-tesseract build-libreoffice

.PHONY: build-leptonica
build-leptonica:
	ARCH=$(ARCH) PACKAGE=leptonica $(PROJECT_DIR)/.github/scripts/create-packages.sh

.PHONY: build-tesseract
build-tesseract:
	ARCH=$(ARCH) PACKAGE=tesseract $(PROJECT_DIR)/.github/scripts/create-packages.sh

.PHONY: build-pandoc
build-pandoc:
	ARCH=$(ARCH) PACKAGE=pandoc $(PROJECT_DIR)/.github/scripts/create-packages.sh

.PHONY: build-boost
build-boost:
	ARCH=$(ARCH) PACKAGE=boost $(PROJECT_DIR)/.github/scripts/create-packages.sh

.PHONY: build-poppler
build-poppler:
	ARCH=$(ARCH) PACKAGE=poppler $(PROJECT_DIR)/.github/scripts/create-packages.sh

.PHONY: build-libreoffice
build-libreoffice:
	ARCH=$(ARCH) PACKAGE=libreoffice $(PROJECT_DIR)/.github/scripts/create-packages.sh

.PHONY: build-openjpeg
build-openjpeg:
	ARCH=$(ARCH) PACKAGE=openjpeg $(PROJECT_DIR)/.github/scripts/create-packages.sh
