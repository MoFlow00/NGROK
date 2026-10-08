#!/usr/bin/env bash
set -Eeuo pipefail

echo "Installing Wine and gaming utilities inside KasmVNC..."

docker exec -u 0 ngrok-cloud bash -lc '
  set -Eeuo pipefail
  dpkg --add-architecture i386
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y     wine64 wine32:i386 winetricks cabextract p7zip-full unzip unrar     curl wget file aria2 vlc xdotool zenity
'

docker exec -u 1000 ngrok-cloud bash -lc '
  set -Eeuo pipefail
  mkdir -p /home/kasm-user/Games /home/kasm-user/Downloads
  mkdir -p /home/kasm-user/.wine
  export DISPLAY=:1
  export WINEPREFIX=/home/kasm-user/.wine
  wineboot --init || true
'

docker exec -u 0 ngrok-cloud bash -lc '
  cat > /usr/local/bin/ngrok-game-hub <<'"'"'EOF'"'"'
#!/usr/bin/env bash
set -Eeuo pipefail

CHOICE="$(zenity --list   --title="NGROK Game Hub"   --text="Choose an action"   --radiolist   --height=360   --width=620   --column=""   --column="Action"   TRUE "Open Downloads"   FALSE "Open Games"   FALSE "Fast Download"   FALSE "Open Terminal" || true)"

case "$CHOICE" in
  "Open Downloads")
    xdg-open /home/kasm-user/Downloads
    ;;
  "Open Games")
    xdg-open /home/kasm-user/Games
    ;;
  "Fast Download")
    URL="$(zenity --entry --title="Fast Download" --text="Paste a direct download URL" || true)"
    [[ -n "$URL" ]] || exit 0
    cd /home/kasm-user/Downloads
    aria2c -x16 -s16 -k1M --file-allocation=none "$URL"
    zenity --info --title="Download complete" --text="The file is in Downloads." || true
    ;;
  "Open Terminal")
    xfce4-terminal
    ;;
esac
EOF
  chmod +x /usr/local/bin/ngrok-game-hub
'

docker exec -u 1000 ngrok-cloud bash -lc '
  cat > /home/kasm-user/Desktop/NGROK-Game-Hub.desktop <<EOF
[Desktop Entry]
Type=Application
Name=NGROK Game Hub
Exec=/usr/local/bin/ngrok-game-hub
Icon=applications-games
Terminal=false
Categories=Game;
EOF
  chmod +x /home/kasm-user/Desktop/NGROK-Game-Hub.desktop
'

echo "Wine installation completed."
