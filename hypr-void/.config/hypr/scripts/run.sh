#!/usr/bin/env bash

. "$HOME/scripts/themes/colors"

pkill rofi || rofi -modes "run" -show run -display-drun "Menu" -display-run "Run" -display-window "Window" -show-icons -auto-close -theme-str "window {width: 35%; border: 3px; border-color: $T_BG_ALT;}"
