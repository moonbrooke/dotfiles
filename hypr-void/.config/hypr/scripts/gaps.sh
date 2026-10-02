#!/usr/bin/env bash

. "$HOME/scripts/themes/colors"

STATE_FILE="$HOME/.cache/hypr_gaps"

if [ ! -f "$STATE_FILE" ]; then
    touch "$STATE_FILE"
    notify-send 'Settings' 'Window gaps has been <span color="$T_GREEN"><b>ENABLED</b></span>' -t 2500 \
        --hint=string:x-dunst-stack-tag:gaps -i dialog-information &
else
    rm "$STATE_FILE"
    notify-send 'Settings' 'Window gaps has been <span color="$T_RED"><b>DISABLED</b></span>' -t 2500 \
        --hint=string:x-dunst-stack-tag:gaps -i dialog-information &
fi

hyprctl reload
