#!/usr/bin/env bash
# Emits {"text":"[class] title","empty":bool} for the active window.
# Mirrors waybar hyprland/window: "[{class}] {title}", truncated to 40 chars.
# Text is XML-escaped for safe use in a pango-markup label.

CD="$(dirname "$0")"
# shellcheck disable=SC1091
source "$CD/_sock.sh"

emit() {
    local t
    t=$(hyprctl activewindow -j 2>/dev/null \
        | jq -r 'if (.address // "") == "" then ""
                  else "[\(.class // "")] \(.title // "")" end | .[0:40]') || return
    t=${t//$'\n'/ }
    t=${t//&/&amp;}
    t=${t//</&lt;}
    t=${t//>/&gt;}
    jq -cn --arg t "$t" '{text: $t, empty: ($t == "")}'
}

emit
socat -U - "UNIX-CONNECT:$SOCK2" 2>/dev/null | while IFS= read -r line; do
    case "${line%%>>*}" in
        openwindow|closewindow|movewindow*|windowtitle*|activewindow*|workspace|focusedmon)
            emit
            ;;
    esac
done
