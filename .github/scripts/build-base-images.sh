#!/bin/bash

set -euo pipefail
DOCKER_REPOSITORY="${DOCKER_REPOSITORY:-quay.io/unstructured-io}"
PIP_VERSION="${PIP_VERSION:-22.2.1}"
GITHUB_REF="${GITHUB_REF:-none}"
DOCKER_PLATFORM="${DOCKER_PLATFORM:-linux/amd64}"

cd dockerfiles

docker buildx create --use
for DOCKERFILE in *; do
    DOCKERFILE_NAME=$(basename "$DOCKERFILE")
    DOCKER_IMAGE="${DOCKER_IMAGE:-$DOCKER_REPOSITORY/$DOCKERFILE_NAME}"

    DOCKER_BUILD_CMD=(docker buildx build --load \
    --build-arg PIP_VERSION="$PIP_VERSION" \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    --progress plain \
    --cache-from "$DOCKER_IMAGE" \
    -t "$DOCKER_IMAGE" -f "$DOCKERFILE_NAME" .)

    # only build for specific platform if DOCKER_PLATFORM is set
    if [ -n "${DOCKER_PLATFORM:-}" ]; then
        DOCKER_BUILD_CMD+=("--platform=$DOCKER_PLATFORM")
    fi

    DOCKER_BUILDKIT=1 "${DOCKER_BUILD_CMD[@]}"

    if [ "$GITHUB_REF" == "refs/heads/main" ]; then
        docker push "${DOCKER_IMAGE}"
    fi
done