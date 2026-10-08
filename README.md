# NGROK Cloud

Simple browser-accessible Linux desktop using GitHub Actions, XFCE4, Google Chrome, KasmVNC and a Cloudflare Quick Tunnel.

## Desktop

- Ubuntu
- XFCE4
- Google Chrome
- 1280x720
- Lightweight KasmVNC settings
- No Wine, gaming stack, extra environments or runtime setup scripts

## Start

Actions > NGROK Cloud > Run workflow

Choose the session duration.

Required repository secret:

- BROWSER_PASSWORD

The workflow starts the Chrome image directly, checks the authenticated KasmVNC service, creates a Cloudflare Quick Tunnel and prints the public URL in the workflow summary.

Kasm's Chrome image includes XFCE4 and Google Chrome, so Chrome is not installed with apt during every run.
