# NGROK Cloud

Lightweight browser-accessible Linux desktop.

## Runtime

- Debian
- XFCE4
- Chromium installed
- TigerVNC + noVNC
- 1366x768
- Cloudflare Quick Tunnel
- One workflow
- No KasmVNC
- No Wine
- No gaming stack
- No runtime package installation
- No separate setup scripts

The workflow uses the lightweight `theholm/xfce4-desktop-over-http` image. It is a minimal XFCE4 desktop exposed through noVNC and already includes Chromium. The published image is about 564 MB. citeturn3search0

## Start

Actions > NGROK Cloud > Run workflow

Choose only the session duration:

- 1h
- 3h
- 6h

The workflow starts the Linux desktop, creates a Cloudflare Quick Tunnel and prints the public URL in the workflow summary.

Open the URL to get the full XFCE4 desktop. Chromium is installed inside the desktop and is not opened automatically.
