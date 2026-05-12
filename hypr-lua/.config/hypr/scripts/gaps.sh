#!/usr/bin/env sh

STATE_FILE="$HOME/.cache/hypr_gaps"

if [ ! -f "$STATE_FILE" ]; then
    touch "$STATE_FILE"
else
    rm "$STATE_FILE"
fi

hyprctl reload
