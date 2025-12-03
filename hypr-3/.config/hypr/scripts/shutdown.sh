#!/bin/bash

~/.config/hypr/scripts/close-all.sh
sleep 1 # Allow apps like Chrome to shutdown correctly
systemctl poweroff --no-wall
