# NGROK Cloud

Temporary browser-accessible Linux environments using GitHub Actions and Cloudflare Quick Tunnels.

Environments:
- Desktop: XFCE Linux desktop.
- Browser: Chromium.
- Wine: XFCE with Wine and common utilities.
- Gaming: XFCE with Wine and game utilities.

Start from Actions > NGROK Cloud > Run workflow. Choose the environment and session duration. The workflow prints a verified public URL.

Required repository secrets:
- BROWSER_USER
- BROWSER_PASSWORD

Sessions run on temporary GitHub-hosted runners. Public tunnel URLs change between sessions.
