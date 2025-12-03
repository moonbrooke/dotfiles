#!/bin/bash

# Simple script to handle a DIY shutdown menu with rofi.
#
# Requirements:
# - rofi
# - systemd (can be replaced for other init systems if needed)
#
# Instructions:
# - Save this file as power.sh
# - Make it executable: chmod +x /path/to/power.sh
# - Run it

ROFI_THEME="$HOME/.config/rofi/config.rasi"

# Main menu (no Cancel option)
chosen=$(echo -e "Logout\nShutdown\nReboot" | \
    rofi -dmenu -i -p "Power" -line-padding 4 -hide-scrollbar -theme "$ROFI_THEME")

# Exit if nothing selected
[ -z "$chosen" ] && exit

# Confirmation dialog
confirm=$(echo -e "Yes\nNo" | \
    rofi -dmenu -i -p "Are you sure?" -line-padding 4 -hide-scrollbar -theme "$ROFI_THEME")

# Only proceed if "Yes"
if [ "$confirm" == "Yes" ]; then
    case "$chosen" in
        "Logout") hyprctl dispatch exit ;;
        "Shutdown") ~/.config/hypr/scripts/shutdown.sh ;;
        "Reboot") ~/.config/hypr/scripts/reboot.sh ;;
    esac
fi
