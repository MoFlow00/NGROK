#!/usr/bin/env bash
set -Eeuo pipefail

PORT="$(cat .runtime/port)"
URL="https://127.0.0.1:$PORT"

echo "Waiting for KasmVNC at $URL"

for attempt in {1..90}; do
  if curl -kfsS --max-time 5 "$URL/" >/dev/null 2>&1; then
    echo "KasmVNC is READY."
    exit 0
  fi

  if ! docker inspect -f '{{.State.Running}}' ngrok-cloud 2>/dev/null | grep -q true; then
    echo "::error::KasmVNC container stopped before becoming ready."
    docker logs ngrok-cloud || true
    exit 1
  fi

  sleep 2
done

echo "::error::KasmVNC did not become ready."
docker logs ngrok-cloud || true
exit 1
