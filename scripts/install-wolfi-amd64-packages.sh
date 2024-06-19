#!/bin/bash

if [ "$ARCH" != "arm64" ] && [ "$ARCH" != "aarch64" ]; then
  apk add --allow-untrusted packages/libreoffice-7.6.5-r0.apk &&
    mv /share/tessdata/configs /usr/local/share/tessdata/ &&
    mv /share/tessdata/tessconfigs /usr/local/share/tessdata/ &&
    ln -s /usr/local/lib/libreoffice/program/soffice.bin /usr/bin/libreoffice &&
    ln -s /usr/local/lib/libreoffice/program/soffice.bin /usr/bin/soffice &&
    chmod +x /usr/local/lib/libreoffice/program/soffice.bin &&
    chmod +x /usr/bin/libreoffice &&
    chmod +x /usr/bin/soffice
fi
