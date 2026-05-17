#!/bin/bash

~/.config/hypr/scripts/close-all.sh
sleep 2
# hyprctl dispatch exit
hyprctl dispatch "hl.dsp.exit()"
