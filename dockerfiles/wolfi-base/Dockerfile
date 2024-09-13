# syntax=docker/dockerfile:experimental
FROM cgr.dev/chainguard/wolfi-base:latest
COPY ./docker-packages/*.apk packages/
COPY ./scripts/install-wolfi-libreoffice.sh install-wolfi-libreoffice.sh
COPY ./scripts/install-wolfi-tesseract.sh install-wolfi-tesseract.sh
COPY ./scripts/install-wolfi-mesa-gl.sh install-wolfi-mesa-gl.sh

USER root
# NOTE(robinson) - the mesa-gl section is a temporary workaround to install mesa-gl 24.1.0 because
# libgallum is missing in mesa-gl 24.2.0 from the wolfi package manager
RUN apk update && \
    apk add py3.11-pip glib cmake bash libmagic wget git openjpeg && \
    ./install-wolfi-mesa-gl.sh && rm install-wolfi-mesa-gl.sh && \
    apk add --allow-untrusted packages/pandoc-3.1.8-r0.apk && \
    apk add --allow-untrusted packages/poppler-23.09.0-r0.apk && \
    ./install-wolfi-tesseract.sh && rm install-wolfi-tesseract.sh && \
    ./install-wolfi-libreoffice.sh && rm install-wolfi-libreoffice.sh && \
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
