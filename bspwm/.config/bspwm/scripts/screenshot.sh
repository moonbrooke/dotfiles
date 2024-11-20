#!/bin/bash

# Directory to save screenshots
SAVE_DIR=~/Pictures/Screenshots

# Generate filename with timestamp
FILENAME="screenshot_$(date +%Y-%b-%d-%H-%M-%S)_maim.png"
FILEPATH="$SAVE_DIR/$FILENAME"

# Check if the directory exists, if not, create it
mkdir -p "$SAVE_DIR"

# Take a screenshot based on the input argument
if [[ "$1" == "full" ]]; then
    # Full screen screenshot
    maim "$FILEPATH"
    TYPE="Full"
elif [[ "$1" == "select" ]]; then
    # Selected area screenshot
    maim -s "$FILEPATH"
    TYPE="Area"
elif [[ "$1" == "window" ]]; then
    # active window screenshot
    maim -i $(xdotool getactivewindow) "$FILEPATH"
    TYPE="Window"
else
    echo "Usage: $0 {full|select|window}"
    exit 1
fi

# Send notification with the filename
notify-send -a "$TYPE Screenshot" -i $FILEPATH "-" "Screenshot saved as <b>$FILENAME</b>"
