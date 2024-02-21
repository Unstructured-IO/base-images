# syntax=docker/dockerfile:experimental
FROM rockylinux:9.2

# # Install dependency packages and pandoc/libreoffice
RUN dnf -y update && \
    dnf -y upgrade && \
    dnf clean all

COPY ./dockerfiles/deps/ /deps/

RUN /deps/python.sh && rm -r /deps
