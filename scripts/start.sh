#!/usr/bin/env bash
set -Eeuo pipefail

ENVIRONMENT="${1:-desktop}"
PASSWORD="${BROWSER_PASSWORD:-}"

[[ -n "$PASSWORD" ]] || {
  echo "::error::BROWSER_PASSWORD is required."
  exit 1
}

mkdir -p .runtime "$HOME/ngrok-data/Games" "$HOME/ngrok-data/Downloads"

docker rm -f ngrok-cloud >/dev/null 2>&1 || true

KASM_TAG="1.19.0"
IMAGE=""
PORT="6901"

case "$ENVIRONMENT" in
  desktop|wine|gaming)
    IMAGE="kasmweb/desktop:$KASM_TAG"
    ;;
  browser)
    IMAGE="kasmweb/chromium:$KASM_TAG"
    ;;
  *)
    echo "::error::Unsupported environment: $ENVIRONMENT"
    exit 1
    ;;
esac

echo "Starting KasmVNC environment"
echo "Environment : $ENVIRONMENT"
echo "Image       : $IMAGE"
echo "Port        : $PORT"

sudo chown -R 1000:1000 "$HOME/ngrok-data"

docker pull "$IMAGE"

docker run -d   --name ngrok-cloud   --shm-size=2gb   --restart=no   -p "$PORT:$PORT"   -v "$HOME/ngrok-data/Games:/home/kasm-user/Games"   -v "$HOME/ngrok-data/Downloads:/home/kasm-user/Downloads"   -e VNC_PW="$PASSWORD"   -e VNC_RESOLUTION=1600x900   -e MAX_FRAME_RATE=24   -e VNCOPTIONS="-PreferBandwidth -DynamicQualityMin=4 -DynamicQualityMax=7 -DLP_ClipDelay=0"   -e KASMVNC_AUTO_RECOVER=true   -e TZ=Asia/Dubai   "$IMAGE"

echo "$PORT" > .runtime/port
echo "$ENVIRONMENT" > .runtime/environment
echo "kasm_user" > .runtime/username

echo "Container started."
docker ps --filter name=ngrok-cloud
