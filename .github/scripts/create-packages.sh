#!/usr/bin/env bash

set -euo pipefail

ARCH="${ARCH:-arm64}"
PACKAGE="${PACKAGE:-}"

if [ -z "$PACKAGE" ]; then
    echo "PACKAGE is not set"
    exit 1
fi

cd melange

if [ ! -f "melange.rsa" ]; then
    echo "Missing melange signing keys"
    exit 1
fi

melange build --arch "$ARCH" "$PACKAGE.yaml" --signing-key melange.rsa --keyring-append melange.rsa.pub -r packages/
