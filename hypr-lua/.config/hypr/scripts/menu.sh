#!/usr/bin/env bash

pkill rofi || rofi -modes "drun" -show drun -display-drun "Menu" -display-run "Run" -display-window "Window" -show-icons -auto-close -theme-str "window {width: 35%; border: 3px; border-color: #24283b;}"
