#!/bin/bash

# Directory to save screenshots
SAVE_DIR=~/Pictures/Screenshots

# Generate filename with timestamp
FILENAME="screenshot_$(date +%Y-%b-%d-%H-%M-%S)_grim.png"
FILEPATH="$SAVE_DIR/$FILENAME"

# Check if the directory exists, if not, create it
mkdir -p "$SAVE_DIR"

# Take a screenshot based on the input argument
if [[ "$1" == "full" ]]; then
    # Full screen screenshot
    grim "$FILEPATH"
    TYPE="Full"
elif [[ "$1" == "select" ]]; then
    # Selected area screenshot
    grim -g "$(slurp)" "$FILEPATH"
    TYPE="Area"
elif [[ "$1" == "window" ]]; then
    # active window screenshot
    # grim -o $(xdotool getactivewindow) "$FILEPATH"
    hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "$FILEPATH"
    TYPE="Window"
else
    echo "Usage: $0 {full|select|window}"
    exit 1
fi

# Send notification with the filename
notify-send -a "$TYPE Screenshot" -i $FILEPATH "$TYPE Screenshot" "Screenshot saved as <b>$FILENAME</b>"
