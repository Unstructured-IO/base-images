#!/bin/bash

ARCH=$(uname -m)

if [[ "$ARCH" == "x86_64" ]] || [[ "$ARCH" == "amd64" ]]; then
  /usr/bin/soffice --headless || [ $? -eq 81 ] || exit 1
fi
