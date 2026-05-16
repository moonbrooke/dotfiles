#!/usr/bin/env bash

pkill rofi || rofi -modes "run" -show run -display-drun "Menu" -display-run "Run" -display-window "Window" -show-icons -auto-close -theme-str "window {border: 3px; border-color: #24283b;}"
