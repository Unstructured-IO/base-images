#!/bin/bash

set -euo pipefail
DOCKER_REPOSITORY="${DOCKER_REPOSITORY:-quay.io/unstructured-io}"
BUILD_REPO="${BUILD_REPO:-build-base-images}"
PIP_VERSION="${PIP_VERSION:-22.2.1}"
GITHUB_REF="${GITHUB_REF:-none}"
DOCKER_PLATFORM="${DOCKER_PLATFORM:-linux/amd64}"
DOCKERFILE="${DOCKERFILE:-rocky9.2}"
CI="${CI:-false}"
SHORT_SHA="${SHORT_SHA:-$(git rev-parse --short HEAD)}"

if [ -z "$DOCKERFILE" ]; then
  echo "DOCKERFILE is not set"
  exit 1
fi

ARCH=$(echo "$DOCKER_PLATFORM" | sed 's/\// /g' | awk '{print $2}')

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

if [ "$DOCKERFILE" == "ubi9.4" ]; then
  # shellcheck disable=SC2206,SC2054
  VERSION="1.0.0"
  BUILD_DATE=$(date +%Y%m%d)
  RELEASE="$VERSION-$SHORT_SHA-$BUILD_DATE"

  DOCKER_BUILD_CMD=("${BUILDX_COMMAND[@]}"
    --build-arg PIP_VERSION="$PIP_VERSION"
    --build-arg BUILDKIT_INLINE_CACHE=1
    --secret id=redhat_pw,env=REDHAT_PW
    --secret id=redhat_user,env=REDHAT_USER
    --label "name=unstructured-io/ubi-base"
    --label "vendor=unstructured-io"
    --label "version=$VERSION"
    --label "release=$RELEASE"
    --label "commit=$SHORT_SHA"
    --label "build-date=$BUILD_DATE"
    --label "summary=Base UBI 9.4 image for the Unstructured API."
    --label "description=Base UBI 9.4 image with the required dependencies and configurations for building the Unstructured API."
    --progress plain
    -t "$DOCKER_IMAGE:$RELEASE"
    -t "$DOCKER_IMAGE:$VERSION"
    -t "$DOCKER_IMAGE:$SHORT_SHA"
    -t "$DOCKER_IMAGE:latest"
    -f "./dockerfiles/$DOCKERFILE/Dockerfile" .)
else
  # shellcheck disable=SC2206
  DOCKER_BUILD_CMD=("${BUILDX_COMMAND[@]}"
    --build-arg PIP_VERSION="$PIP_VERSION"
    --build-arg BUILDKIT_INLINE_CACHE=1
    --progress plain
    -t "$DOCKER_IMAGE-$SHORT_SHA" -f "./dockerfiles/$DOCKERFILE/Dockerfile" .)
fi

# only build for specific platform if DOCKER_PLATFORM is set
if [ -n "${DOCKER_PLATFORM:-}" ]; then
  DOCKER_BUILD_CMD+=("--platform=$DOCKER_PLATFORM")
fi

DOCKER_BUILDKIT=1 "${DOCKER_BUILD_CMD[@]}"
