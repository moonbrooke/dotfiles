#!/usr/bin/env bash

notify-send "Getting list of available Wi-Fi networks..."

WIFI_LIST=$(nmcli --fields "SSID,SECURITY" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA1 WPA2/WPA/g" | sed -E "s/802.1X//g" | sort | uniq)

if [[ "$WIFI_LIST" =~ "WIFI is disabled" ]]; then
    notify-send "Wi-Fi is currently disabled."
    exit 1
fi

CHOSEN_NETWORK=$(echo "$WIFI_LIST" | rofi -dmenu -i -p "WiFi Networks: " -lines 10 )

if [ -z "$CHOSEN_NETWORK" ]; then
    exit 0
fi

CHOSEN_SSID=$(echo "$CHOSEN_NETWORK" | awk '{$NF=""; print $0}' | sed 's/[ \t]*$//')

KNOWN_CONNECTIONS=$(nmcli connection show | awk '{print $1}')

if echo "$KNOWN_CONNECTIONS" | grep -q -w "$CHOSEN_SSID"; then
    notify-send "Connecting to $CHOSEN_SSID..."
    SUCCESS_MESSAGE=$(nmcli connection up id "$CHOSEN_SSID" 2>&1)
else
    if [[ "$CHOSEN_NETWORK" =~ "--" ]]; then
        notify-send "Connecting to open network $CHOSEN_SSID..."
        SUCCESS_MESSAGE=$(nmcli device wifi connect "$CHOSEN_SSID" 2>&1)
    else
        WIFI_PASSWORD=$(rofi -dmenu -password -p "Password for $CHOSEN_SSID: " -lines 0)
        
        if [ -z "$WIFI_PASSWORD" ]; then
            notify-send "Connection cancelled."
            exit 0
        fi

        notify-send "Connecting to $CHOSEN_SSID..."
        SUCCESS_MESSAGE=$(nmcli device wifi connect "$CHOSEN_SSID" password "$WIFI_PASSWORD" 2>&1)
    fi
fi

if [[ "$SUCCESS_MESSAGE" == *"successfully"* ]]; then
    notify-send "Successfully connected to $CHOSEN_SSID."
else
    notify-send "Failed to connect to $CHOSEN_SSID." "$SUCCESS_MESSAGE"
fi
