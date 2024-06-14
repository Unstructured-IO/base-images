# syntax=docker/dockerfile:experimental
FROM registry.access.redhat.com/ubi9/ubi:9.4-947.1717074712

COPY ./dockerfiles/deps/ /deps/

ARG DOCKERFILE="ubi9.4"

RUN --mount=type=secret,id=redhat_pw,uid=0 \
  [ -f /run/secrets/redhat_pw ] && \
  subscription-manager register \
    --username mrobinson-unstructured \
    --password $(cat /run/secrets/redhat_pw)  && \
  GPU_ENABLED=false /deps/base.sh  && \
  /deps/tesseract.sh && \
  /deps/python.sh && \
  rm -r /deps && \
  rm /etc/pki/entitlement/*.pem
