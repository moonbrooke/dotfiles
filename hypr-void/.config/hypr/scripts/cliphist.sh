#!/usr/bin/env bash

if pkill -x rofi; then
    exit 0
fi

selection=$(
    cliphist list |
        rofi -dmenu \
            -no-custom \
            -p "Clipboard" \
            -mesg "<span foreground='#414868'>[Enter]: Copy | [Alt+X]: Delete</span>" \
            -kb-custom-2 "Alt+x" \
            -theme ~/.config/rofi/clipboard.rasi \
            -theme-str "window {width: 35%; border: 3px; border-color: #24283b;}"
)
rofi_status=$?

if [[ -z "$selection" ]]; then
    exit 0
fi

case "$rofi_status" in
    0)
        printf '%s\n' "$selection" | cliphist decode | wl-copy
        ;;
    11)
        confirmation=$(
            printf 'No\nYes\n' |
                rofi -dmenu \
                    -no-custom \
                    -i \
                    -p "Delete selected clipboard entry?" \
                    -theme ~/.config/rofi/config.rasi
        )

        if [[ "$confirmation" == "Yes" ]]; then
            printf '%s\n' "$selection" | cliphist delete
        fi
        ;;
esac
