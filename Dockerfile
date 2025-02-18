FROM ghcr.io/linuxserver/baseimage-alpine:edge

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SNAPCAST_RELEASE
ARG LIBRESPOT_RELEASE

LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sweisgerber"

RUN set -ex \
  echo "**** setup apk testing mirror ****" \
  && echo "@testing https://nl.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories \
  && cat /etc/apk/repositories \
  && echo "**** install runtime packages ****" \
  && apk add --no-cache -U --upgrade \
    alsa-utils \
    dbus \
    librespot@testing=~${LIBRESPOT_RELEASE} \
    shairport-sync@testing \
    snapcast=~${SNAPCAST_RELEASE} \
    snapweb@testing \
  && echo "**** cleanup ****" \
  && rm -rf \
    /tmp/*

# apk add alsa-utils alsa-lib alsaconf alsa-ucm-conf
# environment settings
ENV \
START_SNAPCLIENT=false \
START_AIRPLAY=false \
SNAPCLIENT_OPTS="" \
SNAPSERVER_OPTS=""

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 1704
EXPOSE 1780
#
VOLUME /config /data
