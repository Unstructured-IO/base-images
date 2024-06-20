# syntax=docker/dockerfile:experimental
FROM cgr.dev/chainguard/wolfi-base:latest
COPY ./docker-packages/*.apk packages/
COPY ./scripts/install-wolfi-amd64-packages.sh install-wolfi-amd64-packages.sh

USER root
RUN apk update && apk add py3.11-pip mesa-gl glib cmake bash libmagic wget && \
    apk add --allow-untrusted packages/pandoc-3.1.8-r0.apk && \
    apk add --allow-untrusted packages/poppler-23.09.0-r0.apk && \
    apk add --allow-untrusted packages/leptonica-1.83.0-r0.apk && \
    apk add --allow-untrusted packages/tesseract-5.3.2-r0.apk && \
    ./install-wolfi-amd64-packages.sh && \
    rm install-wolfi-amd64-packages.sh && \
    apk cache clean && \
    rm -rf packages

ARG NB_UID=1000
ARG NB_USER=notebook-user
RUN addgroup --gid ${NB_UID} ${NB_USER} && \
    adduser --disabled-password --gecos "" --uid ${NB_UID} -G ${NB_USER} ${NB_USER}

ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}
COPY --chown=${NB_USER} scripts/initialize-libreoffice.sh ${HOME}/initialize-libreoffice.sh
ENV TESSDATA_PREFIX=/usr/local/share/tessdata
USER ${NB_USER}
WORKDIR ${HOME}

# NOTE(mike): This dummy call is a workaround for libreoffice not executing commands properly at the start of the container.
# The issue is decribed here: https://github.com/Unstructured-IO/unstructured/issues/3105
# soffice running twice explanation: https://github.com/jodconverter/jodconverter/issues/48#issuecomment-1863864333
# It is crucial to run as a non-root user, otherwise the config file will be created in /root
# Moreover, we expect the command to exit with code 81
RUN ./initialize-libreoffice.sh && rm initialize-libreoffice.sh

CMD ["/bin/bash"]
