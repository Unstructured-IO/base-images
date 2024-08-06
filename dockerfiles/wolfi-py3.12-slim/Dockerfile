# syntax=docker/dockerfile:experimental
FROM cgr.dev/chainguard/wolfi-base:latest

USER root
RUN apk update && \
    apk add bash python-3.12 py3.12-pip && \
    apk cache clean

CMD ["/bin/bash"]
