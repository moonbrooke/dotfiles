#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Error" "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

SELECTED=$(ls -1 "$WALLPAPER_DIR" | grep -iE '\.(jpg|jpeg|png|gif|webp)$' | rofi -dmenu -i -p "Wallpapers" \
    -theme-str 'window {width: 35%; border: 2px; border-color: #313244;} listview {lines: 10;}')

if [ -z "$SELECTED" ]; then
    exit 0
fi

FULL_PATH="$WALLPAPER_DIR/$SELECTED"

if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 0.5
fi

awww img "$FULL_PATH" \
    --transition-type center \
    --transition-angle 30 \
    --transition-step 90

notify-send -t 2000 "Wallpaper Updated" "$SELECTED"otify-send -t 2000 "Wallpaper Updated" "$SELECTED"
