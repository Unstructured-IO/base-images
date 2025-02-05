# syntax=docker/dockerfile:experimental
FROM cgr.dev/chainguard/wolfi-base:latest

USER root
RUN apk update && \
    apk add bash python-3.13 py3.13-pip && \
    apk cache clean

CMD ["/bin/bash"]
