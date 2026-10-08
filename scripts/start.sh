#!/usr/bin/env bash
set -Eeuo pipefail
ENVIRONMENT="${1:-desktop}"
USER_NAME="${BROWSER_USER:-clouduser}"
PASSWORD="${BROWSER_PASSWORD:-}"
[[ -n "$PASSWORD" ]] || { echo "::error::BROWSER_PASSWORD is required."; exit 1; }
mkdir -p .runtime "$HOME/ngrok-data/Downloads" "$HOME/ngrok-data/Games"
docker rm -f ngrok-cloud >/dev/null 2>&1 || true
IMAGE="lscr.io/linuxserver/webtop:ubuntu-xfce"
PORT="3000"
case "$ENVIRONMENT" in
  desktop|wine|gaming) IMAGE="lscr.io/linuxserver/webtop:ubuntu-xfce" ;;
  browser) IMAGE="lscr.io/linuxserver/chromium:latest" ;;
  *) echo "::error::Unsupported environment: $ENVIRONMENT"; exit 1 ;;
esac
docker run -d --name ngrok-cloud --privileged --shm-size=2gb   -p "$PORT:$PORT" -v "$HOME/ngrok-data:/config"   -e PUID=1000 -e PGID=1000 -e TZ=Asia/Dubai   -e CUSTOM_USER="$USER_NAME" -e PASSWORD="$PASSWORD" "$IMAGE"
echo "$PORT" > .runtime/port
echo "$ENVIRONMENT" > .runtime/environment
