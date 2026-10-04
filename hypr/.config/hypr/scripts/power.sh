#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/config.rasi"

chosen=$(echo -e "Logout\nShutdown\nReboot" | \
    rofi -dmenu -i -p "Power" -line-padding 4 \
    -hide-scrollbar -theme "$ROFI_THEME" \
    -theme-str 'window {width: 35%; border: 3px; border-color: #24283b;}')

[ -z "$chosen" ] && exit

confirm=$(echo -e "Yes\nNo" | \
    rofi -dmenu -i -p "Are you sure?" -line-padding 4 -hide-scrollbar -theme "$ROFI_THEME" \
    -theme-str 'window {width: 35%; border: 3px; border-color: #24283b;}')

if [ "$confirm" == "Yes" ]; then
    case "$chosen" in
        "Logout") ~/.config/hypr/scripts/logout.sh ;;
        "Shutdown") ~/.config/hypr/scripts/shutdown.sh ;;
        "Reboot") ~/.config/hypr/scripts/reboot.sh ;;
    esac
fi
