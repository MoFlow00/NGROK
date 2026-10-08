#!/usr/bin/env bash
set -Eeuo pipefail

PORT="$(cat .runtime/port)"
LOG=".runtime/tunnel.log"

rm -f "$LOG"

echo "Starting Cloudflare Quick Tunnel..."

cloudflared tunnel --no-autoupdate   --url "http://127.0.0.1:$PORT"   >"$LOG" 2>&1 &

TUNNEL_PID=$!
echo "$TUNNEL_PID" > .runtime/tunnel.pid

PUBLIC_URL=""

for attempt in {1..60}; do
  PUBLIC_URL="$(grep -oE 'https://[a-zA-Z0-9.-]+.trycloudflare.com' "$LOG" | tail -n 1 || true)"

  if [[ -n "$PUBLIC_URL" ]]; then
    break
  fi

  if ! kill -0 "$TUNNEL_PID" 2>/dev/null; then
    echo "::error::Cloudflare Tunnel stopped unexpectedly."
    cat "$LOG"
    exit 1
  fi

  sleep 2
done

if [[ -z "$PUBLIC_URL" ]]; then
  echo "::error::Unable to obtain a Cloudflare public URL."
  cat "$LOG"
  exit 1
fi

echo "Verifying authenticated public URL: $PUBLIC_URL"

PUBLIC_READY=false

for attempt in {1..30}; do
  if curl -fsS       --max-time 10       -u "$BROWSER_USER:$BROWSER_PASSWORD"       "$PUBLIC_URL" >/dev/null 2>&1; then
    PUBLIC_READY=true
    break
  fi

  sleep 2
done

if [[ "$PUBLIC_READY" != "true" ]]; then
  echo "::error::Public tunnel URL did not respond successfully."
  cat "$LOG"
  exit 1
fi

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

Open the Public URL in your browser.
========================================
EOF

echo "Public tunnel is READY."
