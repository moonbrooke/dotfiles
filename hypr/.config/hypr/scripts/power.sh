#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/config.rasi"

chosen=$(echo -e "Logout\nShutdown\nReboot" | \
    rofi -dmenu -i -p "Power" -line-padding 4 \
    -hide-scrollbar -theme "$ROFI_THEME" \
    -theme-str 'window {width: 25%;}')

[ -z "$chosen" ] && exit

confirm=$(echo -e 'No\n<span foreground="#f7768e">Yes</span>' | \
    rofi -dmenu -i -p "Are you sure?" -line-padding 4 -hide-scrollbar -markup-rows -theme "$ROFI_THEME" \
    -theme-str 'window {width: 25%;}')

# rofi echoes the pango markup back, so strip it before comparing
confirm=$(printf '%s' "$confirm" | sed 's/<[^>]*>//g')

if [ "$confirm" == "Yes" ]; then
    case "$chosen" in
        "Logout") ~/.config/hypr/scripts/logout.sh ;;
        "Shutdown") ~/.config/hypr/scripts/shutdown.sh ;;
        "Reboot") ~/.config/hypr/scripts/reboot.sh ;;
    esac
fi
