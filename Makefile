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

.PHONY: build-poppler
build-poppler:
	melange build --arch aarch64 ./melange/poppler.yaml --signing-key ./melange/melange.rsa --keyring-append ./melange/melange.rsa.pub -r ./packages/

.PHONY: build-pandoc
build-pandoc:
	melange build --arch aarch64 ./melange/pandoc.yaml --signing-key ./melange/melange.rsa --keyring-append ./melange/melange.rsa.pub -r ./packages/

.PHONY: build-leptonica
build-leptonica:
	melange build --arch aarch64 ./melange/leptonica.yaml --signing-key ./melange/melange.rsa --keyring-append ./melange/melange.rsa.pub -r ./packages/

.PHONY: build-tesseract
build-tesseract:
	melange build --arch aarch64 ./melange/tesseract.yaml --signing-key ./melange/melange.rsa --keyring-append ./melange/melange.rsa.pub -r ./packages/

.PHONY: build-openjpeg
build-openjpeg:
	melange build --arch aarch64 ./melange/openjpeg.yaml --signing-key ./melange/melange.rsa --keyring-append ./melange/melange.rsa.pub -r ./packages/

.PHONY: build-libreoffice
build-libreoffice:
	melange build --arch aarch64 ./melange/libreoffice.yaml --signing-key ./melange/melange.rsa --keyring-append ./melange/melange.rsa.pub -r ./packages/