# syntax=docker/dockerfile:experimental
FROM cgr.dev/chainguard/wolfi-base:latest
COPY ./docker-packages/*.apk packages/

USER root
RUN apk update && apk add py3.11-pip mesa-gl glib cmake libreoffice bash libmagic && \
    apk add --allow-untrusted packages/pandoc-3.1.8-r0.apk && \
    apk add --allow-untrusted packages/poppler-23.09.0-r0.apk && \
    apk add --allow-untrusted packages/leptonica-1.83.0-r0.apk && \
    apk add --allow-untrusted packages/tesseract-5.3.2-r0.apk && \
    mv /share/tessdata/configs /usr/local/share/tessdata/ && \
    mv /share/tessdata/tessconfigs /usr/local/share/tessdata/ && \
    ln -s /usr/lib/libreoffice/program/soffice.bin /usr/bin/libreoffice && \
    ln -s /usr/lib/libreoffice/program/soffice.bin /usr/bin/soffice && \
    chmod +x /usr/lib/libreoffice/program/soffice.bin && \
    chmod +x /usr/bin/libreoffice && \
    chmod +x /usr/bin/soffice

ENV TESSDATA_PREFIX=/usr/local/share/tessdata
CMD ["/bin/bash"]
