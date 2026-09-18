#!/bin/bash

cleanup_freeze() {
  [[ -n $PID ]] && kill $PID 2>/dev/null
}
trap cleanup_freeze EXIT

hyprpicker -r -z >/dev/null 2>&1 &
PID=$!
sleep .1
SELECTION=$(slurp 2>/dev/null)

[[ -z $SELECTION ]] && exit 0

TEXT=$(grim -g "$SELECTION" - | tesseract stdin stdout --oem 1 --psm 6 -l jpn --dpi 300 -c preserve_interword_spaces=1 2>/dev/null) || exit 1

[[ -z $TEXT ]] && exit 1

printf "%s" "$TEXT" | wl-copy
notify-send "Text Copied" "\"$TEXT\""
