#!/usr/bin/env bash

. "$HOME/scripts/themes/colors"

STATE_FILE="$HOME/.cache/hypr_animation"

if [ ! -f "$STATE_FILE" ]; then
    touch "$STATE_FILE"
    notify-send 'Settings' "Global animation has been <span color=\"$T_GREEN\"><b>ENABLED</b></span>" -t 2500 \
        --hint=string:x-dunst-stack-tag:animation -i dialog-information &
else
    rm "$STATE_FILE"
    notify-send 'Settings' "Global animation has been <span color=\"$T_RED\"><b>DISABLED</b></span>" -t 2500 \
        --hint=string:x-dunst-stack-tag:animation -i dialog-information &
fi

hyprctl reload
