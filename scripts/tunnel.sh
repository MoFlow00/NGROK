#!/usr/bin/env bash
set -Eeuo pipefail
PORT="$(cat .runtime/port)"
LOG=".runtime/tunnel.log"
cloudflared tunnel --no-autoupdate --url "http://127.0.0.1:$PORT" >"$LOG" 2>&1 &
PID=$!
echo "$PID" > .runtime/tunnel.pid
PUBLIC_URL=""
for attempt in {1..60}; do
  PUBLIC_URL="$(grep -oE 'https://[a-zA-Z0-9.-]+\.trycloudflare\.com' "$LOG" | tail -n 1 || true)"
  [[ -n "$PUBLIC_URL" ]] && break
  kill -0 "$PID" 2>/dev/null || { cat "$LOG"; exit 1; }
  sleep 2
done
[[ -n "$PUBLIC_URL" ]] || { cat "$LOG"; exit 1; }
for attempt in {1..30}; do
  curl -fsSIL --max-time 10 "$PUBLIC_URL" >/dev/null 2>&1 && break
  sleep 2
done
curl -fsSIL --max-time 10 "$PUBLIC_URL" >/dev/null 2>&1 || { cat "$LOG"; exit 1; }
ENVIRONMENT="$(cat .runtime/environment)"
cat > .runtime/connection.txt <<EOF
========================================
NGROK CLOUD IS READY
========================================
Environment : $ENVIRONMENT
Status      : ONLINE
Public URL  : $PUBLIC_URL
Username    : $BROWSER_USER
Password    : GitHub Secret
========================================
EOF
