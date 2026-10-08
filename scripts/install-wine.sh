#!/usr/bin/env bash
set -Eeuo pipefail
docker exec -u 0 ngrok-cloud bash -lc '
  dpkg --add-architecture i386
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y wine64 wine32:i386 winetricks cabextract p7zip-full unzip unrar curl wget file aria2 vlc xdotool
'
docker exec -u 1000 ngrok-cloud bash -lc '
  mkdir -p /config/Games /config/Downloads /config/.wine
  export DISPLAY=:0 WINEPREFIX=/config/.wine
  wineboot --init || true
'
