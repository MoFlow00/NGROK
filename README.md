# NGROK Cloud

Browser-accessible Linux environments using GitHub Actions, KasmVNC and Cloudflare Quick Tunnels.

Environments:
- Desktop: Ubuntu desktop with KasmVNC.
- Browser: Chromium with KasmVNC.
- Wine: Ubuntu desktop with Wine and common utilities.
- Gaming: Ubuntu desktop with Wine and game utilities.

The project no longer uses Selkies or LinuxServer webtop/chromium.

Start:
Actions > NGROK Cloud > Run workflow

Choose:
- Environment
- Session duration

Required repository secret:
- BROWSER_PASSWORD

KasmVNC uses HTTPS on port 6901. The workflow creates a Cloudflare Quick Tunnel to that service and verifies the public URL before showing it.

KasmVNC standalone images use the fixed Kasm Workspaces 1.19.0 release. The browser and desktop images are published by Kasm Technologies. Kasm's standalone documentation uses port 6901 and the kasm_user account.
