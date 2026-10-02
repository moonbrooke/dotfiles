#!/usr/bin/env bash

. "$HOME/scripts/themes/colors"

SELECTOR_ARGS="-p 'Select Emoji: ' -lines 10 -theme-str 'window {width: 35%; border: 3px; border-color: $T_BG_ALT;}'"

rofimoji \
    --action copy \
    --skin-tone neutral \
    --max-recent 10 \
    --files emojis math \
    --selector-args="$SELECTOR_ARGS" \
