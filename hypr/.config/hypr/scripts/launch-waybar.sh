#!/usr/bin/env sh

if [ "$#" -eq 0 ]; then
    STATE_FILE="$HOME/.cache/waybar_state"
    CONFIG_DIR="$HOME/.config/waybar"

    STATE=""
    if [ -f "$STATE_FILE" ]; then
        STATE=$(tr -d '[:space:]' < "$STATE_FILE" 2>/dev/null || true)
    fi

    MODE="single"
    case "$STATE" in
        bottom) set -- -c "$CONFIG_DIR/bottom.jsonc" ;;
        island-top) set -- -c "$CONFIG_DIR/island-top.jsonc" ;;
        island-bottom) set -- -c "$CONFIG_DIR/island-bottom.jsonc" ;;
        double-bar)
            if [ -f "$CONFIG_DIR/double-bar-top.jsonc" ] && [ -f "$CONFIG_DIR/double-bar-bottom.jsonc" ]; then
                MODE="double-bar"
            else
                set -- -c "$CONFIG_DIR/top.jsonc"
            fi
            ;;
        *) set -- -c "$CONFIG_DIR/top.jsonc" ;;
    esac

    # Fall back to default config if the resolved file missing
    if [ "$MODE" = "single" ] && [ "$1" = "-c" ] && [ ! -f "$2" ]; then
        set --
    fi
else
    MODE="single"
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

if [ "${MODE:-single}" = "double-bar" ]; then
    waybar -c "$CONFIG_DIR/double-bar-top.jsonc" >/dev/null 2>&1 &
    waybar -c "$CONFIG_DIR/double-bar-bottom.jsonc" >/dev/null 2>&1 &
    wait
    exit "$?"
fi

exec waybar "$@"
