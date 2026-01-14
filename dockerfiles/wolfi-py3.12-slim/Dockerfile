# syntax=docker/dockerfile:experimental
FROM cgr.dev/chainguard/wolfi-base:latest

USER root
RUN apk update && \
    apk add bash python-3.12 py3.12-pip && \
    apk cache clean

# NOTE(alan): To resolve GHSA-58pv-8j8x-9vj2
RUN python3.12 -m pip install --no-cache-dir --force-reinstall jaraco.context>=6.1.0

CMD ["/bin/bash"]
