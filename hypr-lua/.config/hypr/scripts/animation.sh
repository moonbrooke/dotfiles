#!/usr/bin/env sh

STATE_FILE="$HOME/.cache/hypr_animation"

if [ ! -f "$STATE_FILE" ]; then
    touch "$STATE_FILE"
    notify-send 'Setting Changed' 'Animation has been <b>ENABLED</b>' -t 2500 -i dialog-information &
else
    rm "$STATE_FILE"
    notify-send 'Setting Changed' 'Animation has been <b>DISABLED</b>' -t 2500 -i dialog-information &
fi

hyprctl reload
