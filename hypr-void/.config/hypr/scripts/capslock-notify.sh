#!/usr/bin/env bash

set -u

export LC_ALL=C

readonly SCAN_INTERVAL=2
readonly CAPS_ON='type 17 (EV_LED), code 1 (LED_CAPSL), value 1'
readonly CAPS_OFF='type 17 (EV_LED), code 1 (LED_CAPSL), value 0'
readonly EV_KEY_BIT=1
readonly EV_LED_BIT=17

declare -A monitor_pids=()
no_device_logged=false

log() {
    printf 'capslock-notify: %s\n' "$*" >&2
}

supports_event_type() {
    local device=$1
    local event_bit=$2
    local capabilities_path="/sys/class/input/${device##*/}/device/capabilities/ev"
    local capabilities

    [[ -r "$capabilities_path" ]] || return 1
    capabilities=$(<"$capabilities_path")
    [[ "$capabilities" =~ ^[[:xdigit:]]+$ ]] || return 1
    (( (16#$capabilities & (1 << event_bit)) != 0 ))
}

notify_caps() {
    local state=$1
    local color
    local label
    local attempt

    if [[ "$state" == on ]]; then
        color='#9ece6a'
        label=ON
    else
        color='#f7768e'
        label=OFF
    fi

    for attempt in 1 2 3; do
        if notify-send \
            --app-name=Keyboard \
            --urgency=low \
            --expire-time=2000 \
            --transient \
            --hint=string:x-dunst-stack-tag:capslock \
            --icon=dialog-information \
            'Keyboard' \
            "Caps Lock: <span color=\"$color\"><b>$label</b></span>"
        then
            return 0
        fi
        sleep 0.25
    done

    log 'failed to send Caps Lock notification'
    return 1
}

monitor_device() {
    local device=$1
    local device_name
    local evtest_pid=
    local line
    local last_state=

    device_name=$(<"/sys/class/input/${device##*/}/device/name")
    log "monitoring $device ($device_name)"

    cleanup_device_monitor() {
        if [[ -n "$evtest_pid" ]]; then
            kill "$evtest_pid" 2>/dev/null || true
            wait "$evtest_pid" 2>/dev/null || true
            evtest_pid=
        fi
    }

    trap 'cleanup_device_monitor; exit 0' INT TERM
    trap cleanup_device_monitor EXIT

    exec 3< <(exec evtest "$device" 2>/dev/null)
    evtest_pid=$!

    while IFS= read -r line <&3; do
        case "$line" in
            *'Event code 1 (LED_CAPSL) state 1'*)
                last_state=on
                ;;
            *'Event code 1 (LED_CAPSL) state 0'*)
                last_state=off
                ;;
            *"$CAPS_ON"*)
                if [[ "$last_state" != on ]] && notify_caps on; then
                    last_state=on
                fi
                ;;
            *"$CAPS_OFF"*)
                if [[ "$last_state" != off ]] && notify_caps off; then
                    last_state=off
                fi
                ;;
        esac
    done

    wait "$evtest_pid" 2>/dev/null || true
    evtest_pid=
}

start_monitor() {
    local device=$1

    monitor_device "$device" &
    monitor_pids["$device"]=$!
}

remove_stale_monitors() {
    local device
    local pid

    for device in "${!monitor_pids[@]}"; do
        pid=${monitor_pids[$device]}
        if ! kill -0 "$pid" 2>/dev/null; then
            wait "$pid" 2>/dev/null || true
            unset "monitor_pids[$device]"
            log "stopped monitoring $device"
        fi
    done
}

scan_devices() {
    local device
    local found_device=false

    for device in /dev/input/event*; do
        [[ -e "$device" && -r "$device" ]] || continue
        supports_event_type "$device" "$EV_KEY_BIT" || continue
        supports_event_type "$device" "$EV_LED_BIT" || continue

        found_device=true
        [[ -n "${monitor_pids["$device"]+active}" ]] && continue
        start_monitor "$device"
    done

    if [[ "$found_device" == true ]]; then
        no_device_logged=false
    elif [[ "$no_device_logged" == false ]]; then
        no_device_logged=true
        log 'no readable LED-capable keyboard found; retrying'
    fi
}

cleanup() {
    local pid

    for pid in "${monitor_pids[@]}"; do
        kill "$pid" 2>/dev/null || true
    done

    for pid in "${monitor_pids[@]}"; do
        wait "$pid" 2>/dev/null || true
    done
}

for command_name in evtest notify-send sleep; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        log "required command not found: $command_name"
        exit 1
    fi
done

trap cleanup EXIT
trap 'exit 0' INT TERM

while true; do
    remove_stale_monitors
    scan_devices
    sleep "$SCAN_INTERVAL"
done
