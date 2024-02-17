# syntax=docker/dockerfile:experimental
FROM rockylinux:9.2

COPY ./dockerfiles/deps/ /deps/

RUN /deps/base.sh && /deps/tesseract.sh && /deps/python.sh && rm -r /deps
