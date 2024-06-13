#!/bin/bash

# NOTE(robinson) - There is not a libreoffice build for the arm architecutre, so exit
# instead of attempting to install libreoffice
if [[ $ARCH == *"arm64"* ]]; then
  exit 0
fi

apk add --allow-untrusted packages/libreoffice-7.6.5-r0.apk &&
  ln -s /usr/local/lib/libreoffice/program/soffice.bin /usr/bin/libreoffice &&
  ln -s /usr/local/lib/libreoffice/program/soffice.bin /usr/bin/soffice &&
  chmod +x /usr/local/lib/libreoffice/program/soffice.bin &&
  chmod +x /usr/bin/libreoffice &&
  chmod +x /usr/bin/soffice
