#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/config.rasi"

chosen=$(echo -e "Toggle gaps on/off\n2/4\n5/10\n10/15" | \
    rofi -dmenu -i -p "Set Gaps (in/out)" -line-padding 4 \
    -hide-scrollbar -theme "$ROFI_THEME" \
    -theme-str 'window {width: 35%; border: 3px; border-color: #24283b;}')

[ -z "$chosen" ] && exit

case "$chosen" in
    "Toggle gaps on/off") ~/.config/hypr/scripts/gaps.sh ;;
    "2/4") ~/scripts/set-gaps 2 4 ;;
    "5/10") ~/scripts/set-gaps 5 10 ;;
    "10/15") ~/scripts/set-gaps 10 15 ;;
esac
