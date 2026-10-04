#!/bin/sh
# audio-autoswitch.sh — automatically switch between laptop Speakers and
# Headphones on plug/unplug.
#
# Why this exists: on this MSI Thin (ALC256 / sof-hda-dsp), Speaker and
# Headphones live in mutually exclusive UCM profiles, and WirePlumber's
# ACP auto-profile does not switch between them. So this daemon watches
# the headphone jack state and flips the card profile + default sink.
#
# Started from Hyprland autostart (exec-once). Single instance only.

CARD='alsa_card.pci-0000_00_1f.3-platform-skl_hda_dsp_generic'
PROF_HP='HiFi (HDMI1, HDMI2, HDMI3, Headphones, Mic1, Mic2)'
PROF_SP='HiFi (HDMI1, HDMI2, HDMI3, Mic1, Mic2, Speaker)'

# single-instance guard via atomic lockdir (XDG_RUNTIME_DIR is cleared on
# reboot, so no stale locks survive a restart; a PID check handles crashes)
LOCKDIR="${XDG_RUNTIME_DIR:-/tmp}/audio-autoswitch.lock"
if mkdir "$LOCKDIR" 2>/dev/null; then
    echo $$ > "$LOCKDIR/pid"
else
    oldpid=$(cat "$LOCKDIR/pid" 2>/dev/null)
    if [ -n "$oldpid" ] && kill -0 "$oldpid" 2>/dev/null; then
        exit 0
    fi
    echo $$ > "$LOCKDIR/pid"
fi
trap 'rm -rf "$LOCKDIR"' EXIT HUP INT TERM

# wait for PipeWire + our card to appear (boot ordering)
for _ in $(seq 1 60); do
    pactl list cards 2>/dev/null | grep -q "$CARD" && break
    sleep 2
done

jack_state() {
    # prints "on" if headphones are plugged in, else "off"
    if amixer -c1 contents 2>/dev/null \
        | grep -A2 "name='Headphone Jack'" \
        | tail -1 | grep -q "values=on"; then
        echo "on"
    else
        echo "off"
    fi
}

sink_like() {
    # $1 = substring of the sink node name, e.g. HiFi__Headphones__sink
    pactl list short sinks 2>/dev/null \
        | awk -v pat="$1" '$2 ~ pat {print $2; exit}'
}

switch_to_headphones() {
    amixer -c1 set Headphone unmute >/dev/null 2>&1
    pactl set-card-profile "$CARD" "$PROF_HP" >/dev/null 2>&1
    sleep 1
    amixer -c1 set Headphone unmute >/dev/null 2>&1
    sink=$(sink_like 'HiFi__Headphones__sink')
    if [ -n "$sink" ]; then
        pactl set-default-sink "$sink" >/dev/null 2>&1
        pactl set-sink-mute "$sink" 0 >/dev/null 2>&1
    fi
}

switch_to_speakers() {
    amixer -c1 set Speaker unmute >/dev/null 2>&1
    pactl set-card-profile "$CARD" "$PROF_SP" >/dev/null 2>&1
    sleep 1
    amixer -c1 set Speaker unmute >/dev/null 2>&1
    sink=$(sink_like 'HiFi__Speaker__sink')
    if [ -n "$sink" ]; then
        pactl set-default-sink "$sink" >/dev/null 2>&1
        pactl set-sink-mute "$sink" 0 >/dev/null 2>&1
    fi
}

last=""
while true; do
    jack=$(jack_state)
    if [ "$jack" != "$last" ]; then
        last="$jack"
        if [ "$jack" = "on" ]; then
            switch_to_headphones
        else
            switch_to_speakers
        fi
    fi
    sleep 2
done
