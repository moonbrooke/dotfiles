#!/usr/bin/env bash
# Emits {"text":"NET: <essid>|ETH: <ifname>|NET: OFF","class":"wifi|ethernet|disconnected"}.
# Mirrors waybar network module formats.

out=$(nmcli -t -f TYPE,STATE,DEVICE,CONNECTION device status 2>/dev/null)
if [ -z "$out" ]; then
    echo '{"text":"NET: OFF","class":"disconnected"}'
    exit 0
fi

wifi_con=$(printf '%s\n' "$out" | awk -F: '$1=="wifi" && $2=="connected" {print $4; exit}')
eth_dev=$(printf '%s\n' "$out" | awk -F: '$1=="ethernet" && $2=="connected" {print $3; exit}')

if [ -n "$wifi_con" ]; then
    jq -cn --arg c "$wifi_con" '{text: ("NET: " + $c), class: "wifi"}'
elif [ -n "$eth_dev" ]; then
    jq -cn --arg d "$eth_dev" '{text: ("ETH: " + $d), class: "ethernet"}'
else
    echo '{"text":"NET: OFF","class":"disconnected"}'
fi
