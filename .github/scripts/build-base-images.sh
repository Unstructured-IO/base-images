#!/bin/bash

set -euo pipefail
DOCKER_REPOSITORY="${DOCKER_REPOSITORY:-quay.io/unstructured-io}"
REPO="base-images"
BUILD_REPO="${BUILD_REPO:-build-base-images}"
PIP_VERSION="${PIP_VERSION:-22.2.1}"
GITHUB_REF="${GITHUB_REF:-none}"
DOCKER_PLATFORM="${DOCKER_PLATFORM:-linux/amd64}"
DOCKERFILE="${DOCKERFILE:-rocky9-2.9}"
CI="${CI:-false}"
SHORT_SHA="${SHORT_SHA:-$(git rev-parse --short HEAD)}"

if [ -z "$DOCKERFILE" ]; then
    echo "DOCKERFILE is not set"
    exit 1
fi

ARCH=$(echo "$DOCKER_PLATFORM" |sed 's/\// /g' |awk '{print $2}')

cd dockerfiles
docker buildx create --use
DOCKERFILE=$(basename "$DOCKERFILE")
DOCKER_IMAGE="$DOCKER_REPOSITORY/$BUILD_REPO:$DOCKERFILE-$ARCH"

BUILDX_COMMAND=(docker buildx build)
if [ "$GITHUB_REF" == "refs/heads/main" ]; then
    BUILDX_COMMAND+=("--push")
fi

if [ "$CI" == "false" ]; then
    # (tabossert) This is a local build, so we want to load the image into the local docker daemon
    # Buildx does not support loading multi-arch builds, so CI needs to skip loading.
    BUILDX_COMMAND+=("--load")
fi

# shellcheck disable=SC2206
DOCKER_BUILD_CMD=("${BUILDX_COMMAND[@]}" \
--build-arg PIP_VERSION="$PIP_VERSION" \
--build-arg BUILDKIT_INLINE_CACHE=1 \
--progress plain \
-t "$DOCKER_IMAGE-$SHORT_SHA" -f "$REPO:$DOCKERFILE" .)

# only build for specific platform if DOCKER_PLATFORM is set
if [ -n "${DOCKER_PLATFORM:-}" ]; then
    DOCKER_BUILD_CMD+=("--platform=$DOCKER_PLATFORM")
fi

DOCKER_BUILDKIT=1 "${DOCKER_BUILD_CMD[@]}"
