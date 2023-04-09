# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.17

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sweisgerber"

RUN \
  echo "**** install runtime packages ****" \
  && apk add --no-cache --upgrade \
    snapcast --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
  && apk add --no-cache --upgrade \
    librespot --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
    shairport-sync  --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
  && apk add --no-cache --upgrade \
    alsa-utils \
    avahi \
    avahi-compat-libdns_sd \
    dbus
# apk add alsa-utils alsa-lib alsaconf alsa-ucm-conf
# environment settings
ENV \
EDITOR="nano" \
HOME="/config" \
START_SNAPCLIENT=false \
SNAPCLIENT_OPTS="" \
SNAPSERVER_OPTS=""

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 1704
EXPOSE 1780
#
VOLUME /config /data
