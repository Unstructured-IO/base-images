#!/bin/bash

ARCH=$(uname -m)

if [[ "$ARCH" == "x86_64" ]] || [[ "$ARCH" == "amd64" ]]; then
  apk add --allow-untrusted packages/libreoffice-7.6.5-r0.apk
  ln -s /usr/local/lib/libreoffice/program/soffice.bin /usr/bin/libreoffice
  ln -s /usr/local/lib/libreoffice/program/soffice.bin /usr/bin/soffice
  chmod +x /usr/local/lib/libreoffice/program/soffice.bin
  chmod +x /usr/bin/libreoffice
  chmod +x /usr/bin/soffice
else
  apk add libreoffice
  ln -s /usr/lib/libreoffice/program/soffice.bin /usr/bin/libreoffice
  ln -s /usr/lib/libreoffice/program/soffice.bin /usr/bin/soffice
  chmod +x /usr/lib/libreoffice/program/soffice.bin
  chmod +x /usr/bin/libreoffice
  chmod +x /usr/bin/soffice
fi
