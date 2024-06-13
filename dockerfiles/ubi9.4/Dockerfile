# syntax=docker/dockerfile:experimental
FROM redhat/ubi9:latest

COPY ./dockerfiles/deps/ /deps/

RUN GPU_ENABLED=false /deps/base.sh && /deps/tesseract.sh && /deps/python.sh && rm -r /deps
