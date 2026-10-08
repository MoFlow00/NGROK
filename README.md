# NGROK Cloud

Lightweight browser-accessible Linux XFCE4 desktop using Selkies.

## Architecture

Ubuntu GitHub Runner
-> XFCE4
-> Selkies WebRTC
-> H.264 encoded desktop stream
-> Cloudflare Calls TURN when relay is required
-> Browser

Cloudflare Quick Tunnel remains only for the HTTPS/WebSocket signaling and web interface. The desktop media path is WebRTC instead of carrying the video stream through the Cloudflare Tunnel.

Selkies supports WebRTC as an opt-in transport and Cloudflare Calls TURN as a geodistributed TURN service. The GitHub-hosted runner does not need an inbound UDP port because TURN provides the relay path. citeturn2search0

## Why Selkies WebRTC

The previous QuickDesk setup used Xvfb + x11vnc + noVNC. That sends the desktop through a traditional VNC framebuffer path.

The previous Selkies setup used WebSockets for the encoded video stream. This version switches the default transport to WebRTC so the desktop uses a realtime media transport with UDP/ICE when available and Cloudflare TURN when a relay is required. citeturn0search1

## Runtime

- Ubuntu GitHub Runner
- XFCE4
- Selkies 2.0.0
- H.264 software encoding
- Selkies WebRTC transport
- Cloudflare Calls TURN relay
- Cloudflare Quick Tunnel for signaling/web access
- Dynamic browser-fit resolution
- WebSocket fallback through the Selkies menu
- No KasmVNC
- No x11vnc
- No noVNC
- No Wine
- No gaming stack
- No heavy desktop image

## Cloudflare setup

The workflow expects two GitHub repository secrets:

- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_API_TOKEN`

The API token needs the Cloudflare Calls Write permission because the workflow creates a temporary TURN key for each desktop session. Cloudflare's TURN API creates a TURN key under the account and requires Calls Write. citeturn3search0

The workflow deletes that temporary TURN key during cleanup, so there is no VPS, home device, or always-on relay server involved.

Do not put the API token in the repository files. Keep it only as a GitHub Actions secret. citeturn1search7

## Start

Actions > NGROK Cloud > Run workflow

Choose:

- 1h
- 3h
- 6h

The workflow generates a temporary Selkies password for every session and prints the URL and credentials in the workflow summary.

WebRTC is the default transport. WebSocket fallback remains available from the Selkies interface if needed.
