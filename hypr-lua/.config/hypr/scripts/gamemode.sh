#!/usr/bin/env sh

STATE_FILE="$HOME/.cache/hypr_gamemode"

if [ ! -f "$STATE_FILE" ]; then
    touch "$STATE_FILE"
    pkill waybar
else
    rm "$STATE_FILE"
    pkill waybar
    waybar &
fi

hyprctl reload
