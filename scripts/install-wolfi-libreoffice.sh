#!/bin/bash

apk add --allow-untrusted packages/libreoffice-24-24.2.5.2-r1.apk

ln -s /usr/local/lib/libreoffice/program/soffice.bin /usr/bin/libreoffice && \
ln -s /usr/local/lib/libreoffice/program/soffice.bin /usr/bin/soffice && \
chmod +x /usr/local/lib/libreoffice/program/soffice.bin && \
chmod +x /usr/bin/libreoffice
chmod +x /usr/bin/soffice
