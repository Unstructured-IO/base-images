#!/bin/bash

apk add --allow-untrusted packages/libreoffice-7.6.7.2-r0.apk
ln -s /usr/local/lib/libreoffice/program/soffice.bin /usr/bin/libreoffice
ln -s /usr/local/lib/libreoffice/program/soffice.bin /usr/bin/soffice
chmod +x /usr/local/lib/libreoffice/program/soffice.bin
chmod +x /usr/bin/libreoffice
chmod +x /usr/bin/soffice
