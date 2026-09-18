#!/usr/bin/env sh

STATE_FILE="$HOME/.cache/hypr_gaps"

if [ ! -f "$STATE_FILE" ]; then
    touch "$STATE_FILE"
    notify-send 'Settings' 'Window gaps has been <span color="#9ece6a"><b>ENABLED</b></span>' -t 2500 -i dialog-information &
else
    rm "$STATE_FILE"
    notify-send 'Settings' 'Window gaps has been <span color="#f7768e"><b>DISABLED</b></span>' -t 2500 -i dialog-information &
fi

hyprctl reload
