#!/usr/bin/env bash
# Emits {"text":"<icon> 94% (2h05m)","class":"|warning|critical"}.
# Mirrors waybar battery module: icons, charging format, warning<=30 / critical<=15.
# Times are formatted like waybar format-time " ({H}h{M}m)".

ICONS=("󰁺" "󰁼" "󰁿" "󰂁" "󰁹")
CHARGING_ICON="󰂄"

bat=$(upower -e 2>/dev/null | grep -i bat | head -1)
if [ -z "$bat" ]; then
    echo '{"text":"NO BAT","class":""}'
    exit 0
fi

info=$(upower -i "$bat" 2>/dev/null)
state=$(printf '%s\n' "$info" | awk -F: '/^[[:space:]]*state:/{gsub(/[[:space:]]/,"",$2); print $2}')
pct=$(printf '%s\n' "$info" | awk -F: '/percentage:/{gsub(/[^0-9]/,"",$2); print $2}')
[ -z "$pct" ] && pct=0

# upower reports "time to empty: 2.5 hours" (or "time to full: ...")
fmt_time() {
    local raw h m
    raw=$(printf '%s\n' "$info" | awk -F: -v k="$1" '$0 ~ k {print $2; exit}' | grep -o '[0-9]*\.*[0-9]*' | head -1)
    [ -z "$raw" ] && return 1
    h=${raw%.*}
    m=$(awk -v r="$raw" 'BEGIN{printf "%d", (r - int(r)) * 60}')
    [ -z "$h" ] && h=0
    printf ' (%dh%02dm)' "$h" "$m"
}

idx=$((pct * 5 / 100))
[ "$idx" -gt 4 ] && idx=4
[ "$idx" -lt 0 ] && idx=0
icon=${ICONS[$idx]}

class=""
[ "$pct" -le 30 ] && class="warning"
[ "$pct" -le 15 ] && class="critical"

case "$state" in
    charging)
        t=$(fmt_time 'time to full') || t=""
        text="$CHARGING_ICON $pct%$t"
        ;;
    fully-charged|full|charged)
        text="$icon $pct%"
        ;;
    *)
        t=$(fmt_time 'time to empty') || t=""
        text="$icon $pct%$t"
        ;;
esac

jq -cn --arg t "$text" --arg c "$class" '{text: $t, class: $c}'
