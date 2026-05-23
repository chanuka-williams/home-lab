#!/bin/bash

# Create dirs for services running as user 1000:1000
mkdir -p \
  ./gluetun \
  ./prowlarr/config \
  ./radarr/config \
  ./jellyfin/config \
  ./jellyfin/cache \
  ./qbittorrent/config \
  ./media/downloads \
  ./media/movies \

docker compose --env-file ../.env up