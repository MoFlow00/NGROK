# NGROK Cloud

Lightweight browser-accessible Linux XFCE4 desktop using Selkies.

## Architecture

Ubuntu GitHub Runner
-> XFCE4
-> Selkies
-> H.264 encoded desktop stream
-> Browser
-> Cloudflare Quick Tunnel

Selkies is designed as a low-latency HTML5 remote desktop and supports hardware or software video encoding. This workflow uses its H.264 software encoder because GitHub-hosted runners do not provide a dedicated GPU for this session.

## Why Selkies

The previous QuickDesk setup used Xvfb + x11vnc + noVNC. That sends the desktop through a traditional VNC framebuffer path.

Selkies encodes the desktop as video and renders it in the browser using its HTML5 client. Its virtual-display resize mode also lets the desktop follow the browser window instead of staying locked to one fixed resolution.

## Runtime

- Ubuntu GitHub Runner
- XFCE4
- Selkies 2.0.0
- H.264 software encoding
- Selkies WebSocket transport
- Dynamic browser-fit resolution
- Cloudflare Quick Tunnel
- No KasmVNC
- No x11vnc
- No noVNC
- No Wine
- No gaming stack
- No heavy desktop image

## Start

Actions > NGROK Cloud > Run workflow

Choose:

- 1h
- 3h
- 6h

The workflow generates a temporary Selkies password for every session and prints the URL and credentials in the workflow summary.

## Important

Selkies WebRTC mode is not used in this GitHub Actions + Cloudflare Quick Tunnel setup because WebRTC may require UDP/TURN connectivity through restrictive firewalls. Selkies WebSocket mode keeps the deployment on one TCP port while still using encoded video instead of VNC framebuffer updates. citeturn3search0
