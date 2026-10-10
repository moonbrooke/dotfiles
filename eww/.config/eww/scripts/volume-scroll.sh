#!/usr/bin/env bash
# Scroll handler for the volume widget (waybar scroll-step parity: 5%).
# Usage: volume-scroll.sh up|down
case "$1" in
    up) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    down) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
esac
