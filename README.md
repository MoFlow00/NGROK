# NGROK Cloud

Lightweight browser-accessible Linux desktop based on the QuickDesk architecture.

## Runtime

- Ubuntu GitHub runner
- XFCE4
- Xvfb
- x11vnc
- noVNC
- websockify
- Cloudflare Quick Tunnel
- 1280x720
- XFCE compositor disabled
- No KasmVNC
- No Wine
- No gaming stack
- No heavy desktop image

The architecture follows QuickDesk: Xvfb -> XFCE4 -> x11vnc -> noVNC/websockify -> Cloudflare Tunnel. QuickDesk documents this same stack as its lightweight remote desktop design. citeturn0search0

## Start

Actions > NGROK Cloud > Run workflow

Choose only:

- 1h
- 3h
- 6h

The workflow installs only the packages needed for the desktop stack, starts XFCE4 on a virtual display, disables XFCE compositing, exposes it through noVNC and creates a Cloudflare Quick Tunnel.

The public URL opens the full Linux XFCE4 desktop. Chromium is not auto-started.
