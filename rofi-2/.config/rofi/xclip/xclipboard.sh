#!/bin/bash

# Get the clipboard history from xclip
CLIPBOARD_HISTORY=~/clipboard_history.txt

# Save current clipboard content to a file
xclip -o -selection clipboard >> "$CLIPBOARD_HISTORY"

# Remove duplicate entries and keep the last few
awk '!seen[$0]++' "$CLIPBOARD_HISTORY" > "${CLIPBOARD_HISTORY}.tmp" && mv "${CLIPBOARD_HISTORY}.tmp" "$CLIPBOARD_HISTORY"

# Use rofi to select from clipboard history
SELECTED=$(cat "$CLIPBOARD_HISTORY" | rofi -dmenu -p "Clipboard:")

# Copy selected text back to clipboard
if [ -n "$SELECTED" ]; then
    echo -n "$SELECTED" | xclip -selection clipboard
fi

