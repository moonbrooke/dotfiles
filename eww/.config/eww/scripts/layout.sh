#!/usr/bin/env bash
# Emits {"text":"DW","tooltip":"Current Layout: DWINDLE"}.
# Mirrors waybar custom/layout abbreviations.

full=$(hyprctl getoption general:layout 2>/dev/null \
    | sed -n 's/.*str: \(.*\)/\1/p' | tr '[:lower:]' '[:upper:]' | tr -d '[:space:]')
[ -z "$full" ] && full="DWINDLE"

case "$full" in
    DWINDLE) short="DW" ;;
    MASTER) short="MS" ;;
    SCROLLING) short="SC" ;;
    MONOCLE) short="MN" ;;
    *) short="${full:0:2}" ;;
esac

jq -cn --arg s "$short" --arg f "$full" '{text: $s, tooltip: ("Current Layout: " + $f)}'
