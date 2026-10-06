#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Error" "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 0.5 
fi

SELECTED=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.jpeg" \) -print0 | sort -z | while IFS= read -r -d '' file; do
    echo -en "$file\0icon\x1f$file\n"
done | rofi -dmenu -i -show-icons -p "Wallpapers" \
    -cycle \
    -kb-mode-next "" -kb-mode-previous "" \
    -kb-row-left "Left" -kb-row-right "Right" \
    -kb-row-up "Up" -kb-row-down "Down" \
    -theme-str '
    window { width: 40%; border: 3px; border-color: #24283b; }
    listview { columns: 4; lines: 3; }
    element { orientation: vertical; cycle: true; }
    element-icon { size: 7em; }
    element-text { enabled: false; }
    ')

if [ -z "$SELECTED" ]; then
    exit 0
fi

FULL_PATH="$SELECTED"
FILENAME=$(basename "$SELECTED")

awww img "$FULL_PATH" \
    --transition-type wipe \
    --transition-angle 30 \
    --transition-step 90

notify-send -t 2500 "Wallpaper" "Wallpaper set to <span foreground='#9ece6a'>$FILENAME</span>" \
    --hint=string:x-dunst-stack-tag:wallpaper -i dialog-information &
