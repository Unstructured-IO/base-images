#!/bin/bash

ARCH=$(uname -m)

if [[ "$ARCH" == "x86_64" ]] || [[ "$ARCH" == "amd64" ]]; then
  apk add --allow-untrusted packages/libreoffice-24-24.2.3.2-r1.apk
else
  apk add libreoffice
fi

ln -s /usr/lib/libreoffice/program/soffice.bin /usr/bin/libreoffice
ln -s /usr/lib/libreoffice/program/soffice.bin /usr/bin/soffice
chmod +x /usr/lib/libreoffice/program/soffice.bin
chmod +x /usr/bin/libreoffice
chmod +x /usr/bin/soffice
