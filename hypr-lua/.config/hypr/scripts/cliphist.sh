#!/usr/bin/env bash

pkill rofi || cliphist list | rofi -dmenu -p "Clipboard" -theme ~/.config/rofi/clipboard.rasi -theme-str "window {border: 3px; border-color: #24283b;}" | cliphist decode | wl-copy
