#!/usr/bin/env bash
set -Eeuo pipefail
PORT="$(cat .runtime/port)"
for attempt in {1..60}; do
  if curl -fsS --max-time 5 "http://127.0.0.1:$PORT" >/dev/null 2>&1; then
    echo "Local service READY"
    exit 0
  fi
  if ! docker inspect -f '{{.State.Running}}' ngrok-cloud 2>/dev/null | grep -q true; then
    docker logs ngrok-cloud || true
    exit 1
  fi
  sleep 2
done
docker logs ngrok-cloud || true
exit 1
