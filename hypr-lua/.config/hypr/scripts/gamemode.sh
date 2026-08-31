#!/usr/bin/env sh

STATE_FILE="$HOME/.cache/hypr_gamemode"

if [ ! -f "$STATE_FILE" ]; then
    touch "$STATE_FILE"
    pkill waybar
    notify-send 'Setting Changed' 'Game Mode has been <b>ENABLED</b>' -t 2500 -i dialog-information &
else
    rm "$STATE_FILE"
    pkill waybar
    waybar &
    notify-send 'Setting Changed' 'Game Mode has been <b>DISABLED</b>' -t 2500 -i dialog-information &
fi

hyprctl reload
