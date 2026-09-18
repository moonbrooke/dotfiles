#!/usr/bin/env sh

STATE_FILE="$HOME/.cache/hypr_gamemode"

if [ ! -f "$STATE_FILE" ]; then
    touch "$STATE_FILE"
    pkill waybar
    notify-send 'Settings' 'Game Mode has been <span color="#9ece6a"><b>ACTIVATED</b></span>' -t 2500 -i dialog-information &
else
    rm "$STATE_FILE"
    pkill waybar
    waybar &
    notify-send 'Settings' 'Game Mode has been <span color="#f7768e"><b>DEACTIVATED</b></span>' -t 2500 -i dialog-information &
fi

hyprctl reload
