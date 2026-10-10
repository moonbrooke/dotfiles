#!/usr/bin/env bash
# Emits {"text":"VOL: 50%","class":""} or {"text":"MUTED","class":"muted"}.
# Mirrors waybar pulseaudio module (format "VOL: {volume}%", muted "MUTED").

if ! pactl info >/dev/null 2>&1; then
    echo '{"text":"VOL: --","class":"muted"}'
    exit 0
fi

vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -o '[0-9]*%' | head -1)
mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | awk '{print $2}')

if [ "$mute" = "yes" ]; then
    echo '{"text":"MUTED","class":"muted"}'
else
    jq -cn --arg v "${vol:---}" '{text: ("VOL: " + $v), class: ""}'
fi
