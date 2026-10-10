#!/usr/bin/env bash
# Emits a JSON array for persistent workspaces 1-6 with waybar-like state.
# Re-emitted on every relevant Hyprland event via socat.
# Fields: id, occupied, active, visible, class (active|visible|occupied|empty)

CD="$(dirname "$0")"
# shellcheck disable=SC1091
source "$CD/_sock.sh"

emit() {
    local ws active visible
    ws=$(hyprctl workspaces -j 2>/dev/null) || return
    active=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id') || return
    visible=$(hyprctl monitors -j 2>/dev/null | jq -r '.[].activeWorkspace.id') || return
    jq -cn \
        --argjson ws "$ws" \
        --argjson active "${active:-0}" \
        --argjson vis "$(printf '%s\n' "$visible" | jq -R . | jq -s 'map(tonumber)')" \
        '[range(1;7) | {id: .}] | map(
            . as $p
            | (($ws[] | select(.id == $p.id)) // {windows: 0}) as $w
            | . + {
                occupied: ($w.windows > 0),
                active: ($p.id == $active),
                visible: ($vis | index($p.id) != null)
              }
            | .class = (if .active then "active"
                        elif .visible then "visible"
                        elif .occupied then "occupied"
                        else "empty" end)
        )'
}

emit
socat -U - "UNIX-CONNECT:$SOCK2" 2>/dev/null | while IFS= read -r line; do
    case "${line%%>>*}" in
        workspace|movewindow*|openwindow|closewindow|focusedmon|moveworkspace*|createworkspace|destroyworkspace)
            emit
            ;;
    esac
done
