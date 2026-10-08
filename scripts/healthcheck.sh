#!/usr/bin/env bash
set -Eeuo pipefail

PORT="$(cat .runtime/port)"
URL="https://127.0.0.1:$PORT"
USERNAME="$(cat .runtime/username)"
PASSWORD="${BROWSER_PASSWORD:-}"

[[ -n "$PASSWORD" ]] || {
  echo "::error::BROWSER_PASSWORD is required."
  exit 1
}

echo "Waiting for authenticated KasmVNC at $URL"

for attempt in {1..90}; do
  STATUS="$(curl -ksS --max-time 5 \
    -u "$USERNAME:$PASSWORD" \
    -o /dev/null \
    -w "%{http_code}" \
    "$URL/" 2>/dev/null || true)"

  if [[ "$STATUS" == "200" ]]; then
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
