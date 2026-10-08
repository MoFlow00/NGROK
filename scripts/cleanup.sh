#!/usr/bin/env bash
set +e
[[ -f .runtime/tunnel.pid ]] && kill "$(cat .runtime/tunnel.pid)" 2>/dev/null || true
docker rm -f ngrok-cloud >/dev/null 2>&1 || true
