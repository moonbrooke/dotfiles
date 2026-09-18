#!/bin/sh
check_and_start() {
    name=$1
    bin=$2

    if ! pgrep -x "$name" >/dev/null 2>&1; then
        echo "Starting $name..."
        sleep 1
        "$bin" &
    else
        echo "$name is already running"
    fi
}

check_and_start "pipewire" "/usr/bin/pipewire"
