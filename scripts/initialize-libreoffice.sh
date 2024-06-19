#!/bin/bash

if [ "$ARCH" != "arm64" ] && [ "$ARCH" != "aarch64" ]; then
    /usr/bin/soffice --headless || [ $? -eq 81 ] || exit 1
fi
