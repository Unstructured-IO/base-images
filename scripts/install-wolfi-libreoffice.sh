#!/bin/bash

apk add libreoffice && \
  ln -s /usr/lib/libreoffice/program/soffice.bin /usr/bin/libreoffice && \
  ln -s /usr/lib/libreoffice/program/soffice.bin /usr/bin/soffice && \
  chmod +x /usr/lib/libreoffice/program/soffice.bin && \
  chmod +x /usr/bin/libreoffice && \
  chmod +x /usr/bin/soffice
