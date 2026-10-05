#!/bin/bash

# Create dirs for services running as user 1000:1000
mkdir -p \
  ./gluetun \
  ./prowlarr/config \
  ./radarr/config \
  ./sonarr/config \
  ./jellyfin/config \
  ./jellyfin/cache \
  ./qbittorrent/config \
  /mnt/macbox/media/downloads \
  /mnt/macbox/media/movies \
  /mnt/macbox/media/tv \

docker compose --env-file ../.env up
