#!/usr/bin/env bash

if pkill -x rofi; then
    exit 0
fi

umask 077
temp_dir=$(mktemp -d) || exit 1
trap 'rm -rf -- "$temp_dir"' EXIT
entries_file="$temp_dir/entries"

if ! cliphist list >"$entries_file"; then
    exit 1
fi

selection=$(
    while IFS= read -r row; do
        if [[ "$row" == *$'\t'* ]]; then
            id=${row%%$'\t'*}
            preview=${row#*$'\t'}
            image_preview_re='^\[\[\ binary\ data\ [^[:space:]]+\ [^[:space:]]+\ ([a-z0-9]+)\ [0-9]+x[0-9]+\ \]\]$'

            if [[ "$id" =~ ^[0-9]+$ && "$preview" =~ $image_preview_re ]]; then
                format=${BASH_REMATCH[1]}

                case "$format" in
                    png|jpg|jpeg|gif|bmp|tiff)
                        image_path="$temp_dir/$id.$format"

                        if cliphist decode "$id" >"$image_path" && [[ -s "$image_path" ]]; then
                            printf '%s\0icon\x1f%s\n' "$row" "$image_path"
                            continue
                        fi

                        rm -f -- "$image_path"
                        ;;
                esac
            fi
        fi

        printf '%s\n' "$row"
    done <"$entries_file" |
        rofi -dmenu \
            -no-custom \
            -show-icons \
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
        selected_id=${selection%%$'\t'*}

        if [[ "$selected_id" =~ ^[0-9]+$ ]]; then
            cliphist decode "$selected_id" | wl-copy
        fi
        ;;
    11)
        confirmation=$(
            printf 'No\nYes\n' |
                rofi -dmenu \
                    -no-custom \
                    -i \
                    -p "Delete selected clipboard entry?" \
                    -theme ~/.config/rofi/config.rasi \
                    -theme-str "window {width: 35%; border: 3px; border-color: #24283b;}"
        )

        if [[ "$confirmation" == "Yes" ]]; then
            printf '%s\n' "$selection" | cliphist delete
            notify-send 'Clipboard' 'Clipboard entry has been deleted' -t 2000 \
                --hint=string:x-dunst-stack-tag:clipboard -i dialog-information &
        fi
        ;;
esac
