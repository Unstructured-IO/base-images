# syntax=docker/dockerfile:experimental
FROM cgr.dev/chainguard/wolfi-base:latest

COPY ./dockerfiles/deps/ /deps/

RUN GPU_ENABLED=false /deps/base.sh && /deps/tesseract.sh && /deps/python.sh && rm -r /deps
