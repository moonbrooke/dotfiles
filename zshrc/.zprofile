if [[ -z "$WAYLAND_DISPLAY" && "$XDG_VTNR" -eq 1 ]]; then
    if [[ "$(. /etc/os-release 2>/dev/null && printf '%s' "$ID")" == void ]]; then
        exec dbus-run-session start-hyprland
    else
        exec start-hyprland
    fi
fi
