#!/usr/bin/env sh

STATE_FILE="/tmp/hypr_gaps_state"

if [ ! -f "$STATE_FILE" ]; then
    echo "on" > "$STATE_FILE"
fi

STATE=$(cat "$STATE_FILE")

if [ "$STATE" = "on" ]; then
    hyprctl --batch "\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;"
    echo "off" > "$STATE_FILE"
else
    hyprctl --batch "\
        keyword general:gaps_in 5;\
        keyword general:gaps_out 10;"
    echo "on" > "$STATE_FILE"
fi
