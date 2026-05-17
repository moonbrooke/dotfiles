#!/bin/bash

hyprctl clients -j | jq -r '.[].pid' | sort -u | xargs -r kill

hyprctl dispatch "hl.dsp.focus({ workspace = 1 })"
