#!/usr/bin/env bash
set -Eeuo pipefail

PORT="$(cat .runtime/port)"
URL="http://127.0.0.1:$PORT"

echo "Waiting for authenticated local service at $URL"

for attempt in {1..60}; do
  if curl -fsS --max-time 5       -u "$BROWSER_USER:$BROWSER_PASSWORD"       "$URL" >/dev/null 2>&1; then
    echo "Local service is READY."
    exit 0
  fi

  if ! docker inspect -f '{{.State.Running}}' ngrok-cloud 2>/dev/null | grep -q true; then
    echo "::error::Container stopped before the service became ready."
    docker logs ngrok-cloud || true
    exit 1
  fi

  sleep 2
done

echo "::error::Local service did not become ready."
docker logs ngrok-cloud || true
exit 1
