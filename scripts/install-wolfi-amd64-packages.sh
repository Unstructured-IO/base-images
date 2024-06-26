#!/bin/bash

ARCH=$(uname -m)

if [[ "$ARCH" == "x86_64" ]] || [[ "$ARCH" == "amd64" ]]; then
  apk add libreoffice && \
    mv /share/tessdata/configs /usr/local/share/tessdata/ && \
    mv /share/tessdata/tessconfigs /usr/local/share/tessdata/ && \
    /usr/lib/libreoffice/program/soffice.bin /usr/bin/libreoffice && \
    ln -s /usr/lib/libreoffice/program/soffice.bin /usr/bin/soffice && \
    chmod +x /usr/lib/libreoffice/program/soffice.bin && \
    chmod +x /usr/bin/libreoffice && \
    chmod +x /usr/bin/soffice
fi
