#!/bin/bash

~/.config/hypr/scripts/close-all.sh
sleep 2 # Allow apps like Chrome to shutdown correctly
hyprctl dispatch exit
