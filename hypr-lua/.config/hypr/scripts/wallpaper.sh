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

SELECTED=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.jpeg" \) | while read -r file; do
    filename=$(basename "$file")
    echo -en "$filename\0icon\x1f$file\n"
done | rofi -dmenu -i -show-icons -p "Wallpapers" \
    -theme-str '
    window { width: 35%; border: 3px; border-color: #24283b; }
    listview { columns: 1; lines: 8; spacing: 5px; }
    element { orientation: horizontal; padding: 8px; }
    element-icon { size: 3em; }
    element-text { vertical-align: 0.5; margin: 0 0 0 10px; }
    ')

if [ -z "$SELECTED" ]; then
    exit 0
fi

FULL_PATH="$WALLPAPER_DIR/$SELECTED"

awww img "$FULL_PATH" \
    --transition-type wipe \
    --transition-angle 30 \
    --transition-step 90

notify-send -t 2000 "Wallpaper Updated" "$SELECTED"
