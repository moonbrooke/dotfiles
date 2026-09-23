#!/usr/bin/env sh

if [ "$#" -eq 0 ]; then
    STATE_FILE="$HOME/.cache/waybar_state"
    CONFIG_DIR="$HOME/.config/waybar"

    STATE=""
    if [ -f "$STATE_FILE" ]; then
        STATE=$(tr -d '[:space:]' < "$STATE_FILE" 2>/dev/null || true)
    fi

    case "$STATE" in
        bottom) set -- -c "$CONFIG_DIR/bottom.jsonc" ;;
        *) set -- -c "$CONFIG_DIR/top.jsonc" ;;
    esac

    # Fall back to default config if the resolved file missing
    if [ "$1" = "-c" ] && [ ! -f "$2" ]; then
        set --
    fi
fi

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
