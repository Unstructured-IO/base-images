# syntax=docker/dockerfile:experimental
FROM registry.access.redhat.com/ubi9/ubi:9.4-947.1717074712

COPY ./dockerfiles/deps/ /deps/

ARG DOCKERFILE="ubi9.4"

RUN --mount=type=secret,id=redhat_pw,uid=0 \
  --mount=type=secret,id=redhat_user,uid=0 \
  [ -f /run/secrets/redhat_pw ] && [ -f /run/secrets/redhat_user ] && \
  subscription-manager register \
    --username $(cat /run/secrets/redhat_user) \
    --password $(cat /run/secrets/redhat_pw)  && \
  GPU_ENABLED=false /deps/base.sh  && \
  /deps/tesseract.sh && \
  /deps/python.sh && \
  mkdir /license  && \
  mv /deps/LICENSE.md /license && \
  rm -r /deps && \
  rm /etc/pki/entitlement/*.pem
