#!/usr/bin/env sh
# Wait for the audio stack before starting waybar so the
# pulseaudio module doesn't start hidden (no default sink yet).

MAX_TRIES=30
SLEEP=0.5

audio_ready() {
    pactl info >/dev/null 2>&1 || return 1
    pactl get-default-sink >/dev/null 2>&1 || return 1
    return 0
}

i=0
while [ "$i" -lt "$MAX_TRIES" ]; do
    if audio_ready; then
        break
    fi
    sleep "$SLEEP"
    i=$((i + 1))
done

exec waybar "$@"
