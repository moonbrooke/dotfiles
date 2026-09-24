#!/bin/bash

KEYBOARD="/dev/input/event0"
CAPS_ON="type 17 (EV_LED), code 1 (LED_CAPSL), value 1"
CAPS_OFF="type 17 (EV_LED), code 1 (LED_CAPSL), value 0"

evtest "$KEYBOARD" | while read -r line; do
    if [[ "$line" == *"$CAPS_ON"* ]]; then
        notify-send 'Keyboard' 'Caps Lock: <span color="#9ece6a"><b>ON</b></span>' -t 2000 -i dialog-information &
    elif [[ "$line" == *"$CAPS_OFF"* ]]; then
        notify-send 'Keyboard' 'Caps Lock: <span color="#f7768e"><b>OFF</b></span>' -t 2000 -i dialog-information &
    fi
done
