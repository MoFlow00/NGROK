#!/usr/bin/env bash
set -Eeuo pipefail
docker exec -u 0 ngrok-cloud bash -lc '
  dpkg --add-architecture i386
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y wine64 wine32:i386 winetricks cabextract p7zip-full unzip unrar curl wget file aria2 vlc xdotool
'
docker exec -u 1000 ngrok-cloud bash -lc '
  mkdir -p /config/Games /config/Downloads /config/.wine
  export DISPLAY=:0 WINEPREFIX=/config/.wine
  wineboot --init || true
'

docker exec -u 0 ngrok-cloud bash -lc '
  cat > /usr/local/bin/ngrok-game-hub <<'"'"'EOF'"'"'
#!/usr/bin/env bash
set -Eeuo pipefail
CHOICE="$(zenity --list --title="NGROK Game Hub" --text="Choose an action" --radiolist --height=360 --width=620 --column="" --column="Action" TRUE "Open Downloads" FALSE "Open Games" FALSE "Fast Download" FALSE "Open Terminal" || true)"
case "$CHOICE" in
  "Open Downloads") xdg-open /config/Downloads ;;
  "Open Games") xdg-open /config/Games ;;
  "Fast Download")
    URL="$(zenity --entry --title="Fast Download" --text="Paste a direct download URL" || true)"
    [[ -n "$URL" ]] || exit 0
    cd /config/Downloads
    aria2c -x16 -s16 -k1M --file-allocation=none "$URL"
    zenity --info --title="Download complete" --text="The file is in Downloads." || true
    ;;
  "Open Terminal") xfce4-terminal ;;
esac
EOF
  chmod +x /usr/local/bin/ngrok-game-hub
'
docker exec -u 1000 ngrok-cloud bash -lc '
  printf "%s\n" "[Desktop Entry]" "Type=Application" "Name=NGROK Game Hub" "Exec=/usr/local/bin/ngrok-game-hub" "Icon=applications-games" "Terminal=false" > /config/Desktop/NGROK-Game-Hub.desktop
  chmod +x /config/Desktop/NGROK-Game-Hub.desktop
'
