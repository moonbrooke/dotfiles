#!/bin/bash

SAVE_DIR=~/Pictures/Screenshots

FILENAME="screenshot_$(date +%Y-%b-%d-%H-%M-%S)_grim.png"
FILEPATH="$SAVE_DIR/$FILENAME"

mkdir -p "$SAVE_DIR"

if [[ "$1" == "full" ]]; then
    grim "$FILEPATH"
    TYPE="Full"
elif [[ "$1" == "select" ]]; then
    grim -g "$(slurp)" "$FILEPATH"
    TYPE="Area"
elif [[ "$1" == "window" ]]; then
    hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "$FILEPATH"
    TYPE="Window"
else
    echo "Usage: $0 {full|select|window}"
    exit 1
fi

notify-send -a "$TYPE Screenshot" -i $FILEPATH "$TYPE Screenshot" "Screenshot saved as <b>$FILENAME</b>"
