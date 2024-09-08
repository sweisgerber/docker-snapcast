# Snapcast (Docker Image)

Snapcast Multiroom audio docker image.

> Based on [linuxserver/docker-baseimage-alpine](https://github.com/linuxserver/docker-baseimage-alpine) & [snapcast](https://github.com/badaix/snapcast).
> Also available at [DockerHub](https://hub.docker.com/r/sweisgerber/snapcast)

Should get used in conjunction with a player, that plays to a FIFO, like:

- https://github.com/sweisgerber/docker-mopidy
- [or any other player](https://github.com/badaix/snapcast#setup-of-audio-playersserver).

## Features Include:

- Snapserver w/ [sane defaults](./root/defaults/snapserver.conf)
- Snapclient (optional, needs mounting of host audio devices into docker)
    - I prefer using the snapclient as [host distribution package](https://github.com/badaix/snapcast/tree/develop#install-linux-packages-recommended-for-beginners).
- [snapweb](https://github.com/badaix/snapweb) management interface & browser audio playback
    - default on http://<SERVER>:1780m which include a browser snapclient player
- alsa
- librespot (for functioning as spotify target)
- shairport-sync (for functioning as airplay target)
- FIFO usage to stream the audio from players to the network
- Based on [linuxserver/docker-baseimage-alpine](https://github.com/linuxserver/docker-baseimage-alpine)
    - ... which allows use of [linuxserver/docker-mods](https://github.com/linuxserver/docker-mods/tree/universal-package-install) to add more pip & OS packages
    - Uses s6-overlay from base image
    - small footprint

## docker-compose

I strongly advice to use docker-compose, as using a docker commandline is quite annoying with a complex setup.
An example can get found [in the repository](./docker-compose.example.yml).

```yaml
version: "3"
services:
  snapcast:
    image: docker.io/sweisgerber/snapcast:latest
    hostname: snapcast
    environment:
      - PUID=1000
      - PGID=1000 # set to audio group ID
      - TZ=Europe/Berlin
      - START_SNAPCLIENT=false # set to `true` for snapclient to start
      # --host: name or ip of compose service or dockerhost
      # --soundcard: <ID> from `snapclient -l` from inside the container
      # - SNAPCLIENT_OPTS=--host snapcast --soundcard <ID>
      #   => Don't use quotes for SNAPCLIENT_OPTS="" !
      # - HOST_AUDIO_GROUP=<AUDIO-GID> # set to GID of host audio group
    restart: "unless-stopped"
    ports:
      - 1704:1704
      - 1705:1705
      - 1780:1780
    # devices:
      # - /dev/snd:/dev/snd # optional, only if you want to use snapclient
    volumes:
      - /<path>/<to>/<snapcast>/config/:/config/
      - /<path>/<to>/<snapcast>/data/:/data/
      # /audio should get used to place FIFOs for audio playback from mpd/mopidy/host/etc
      - /<path>/<to>/audio-fifos/:/audio/
```

## Configuration

- https://github.com/badaix/snapcast/blob/master/doc/configuration.md

### Configuration SnapClient

To enable snapclient:

- Forward device `/dev/snd` into the container, which should get used exclusively by snapclient. Or try a more sophisticated setup:
    - https://github.com/mviereck/x11docker/wiki/Container-sound:-ALSA-or-Pulseaudio
    - https://stackoverflow.com/questions/51859636/docker-sharing-dev-snd-on-multiple-containers-leads-to-device-or-resource-bu
- Configue `START_SNAPCLIENT=true` as environment variable.
- Configure `SNAPCLIENT_OPTS` as environment variable as needed, or leave empty to try defaults.
    - probably you will need to specify soundcard `--soundcard`, find out with `snapclient --list`

In any case, give [the official documentation a read](https://github.com/badaix/snapcast#client)
